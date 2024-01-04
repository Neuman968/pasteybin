package com.pasteybin.service

import com.pasteybin.data.Bin
import com.pasteybin.data.BinQueries
import com.pasteybin.plugins.binService
import com.pasteybin.plugins.logger
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import java.time.Instant
import java.util.concurrent.ConcurrentHashMap

/**
 * A list of characters that can be used in a bin ID.
 */
val binIdChars: List<Char> = ('A'..'Z') + ('a'..'z') + ('0'..'9')


/**
 * Represents a service for handling operations related to bins.
 *
 * @property binQueries An instance of the BinQueries class for interacting with the database.
 * @property connections A mutable map that stores the active connections for each bin.
 */
class BinService(
    private val binQueries: BinQueries,
    private val connections: MutableMap<String, MutableSet<DefaultWebSocketServerSession>> = ConcurrentHashMap(),
) {

    /**
     * Establishes a connection between the server and the client for the given bin.
     * The connection is made using the provided binId and session.
     *
     * @param binId The ID of the bin.
     * @param session The WebSocket session object.
     */
    suspend fun connect(binId: String, session: DefaultWebSocketServerSession) {
        addConnection(binId, session)
        try {
            for (frame in session.incoming) {
                frame as? Frame.Text ?: continue
                binService.contentUpdated(binId, frame)
            }
        } catch (e: Exception) {
            logger.info("Bin Service Exception:")
            logger.error(e.localizedMessage)
        } finally {
            logger.info("Removing connection.")
            binService.removeConnection(binId, session)
        }
    }

    /**
     * Retrieves the list of bins based on the last updated timestamp.
     *
     * @return The list of bins, ordered by the last updated timestamp in descending order.
     */
    fun getOrderLastUpdated(): List<Bin> = binQueries.selectAll().executeAsList()

    /**
     * Updates the content of a bin with the provided binId.
     *
     * @param binId The ID of the bin.
     * @param content The new content to be updated.
     */
    private fun updateContent(binId: String, content: String) = binQueries.update(content, Instant.now(), binId)

    /**
     * Updates the title of a bin with the specified binId and returns the updated Bin object.
     *
     * @param binId The ID of the bin.
     * @param title The new title to be updated.
     * @return The updated Bin object, or null if no bin with the specified binId is found.
     */
    fun updateTitle(binId: String, title: String): Bin? =
        binQueries.updateTitle(title, Instant.now(), binId).let {
            binQueries.selectOne(binId).executeAsOneOrNull()
        }

    /**
     * Retrieves a single bin by its ID.
     *
     * @param binId The ID of the bin to retrieve.
     * @return The retrieved Bin object, or null if no bin with the specified ID is found.
     */
    fun getOne(binId: String): Bin? = binQueries.selectOne(binId).executeAsOneOrNull()

    /**
     * Creates a new bin with the provided binId or a generated binId if none is provided.
     *
     * @param binId The ID of the bin (optional, default is generated using generateBinId()).
     * @return The created bin.
     */
    fun newBin(binId: String = generateBinId()): Bin = Bin(
        id = binId,
        content = "",
        title = "Bin: $binId",
        createdTime = Instant.now(),
        lastUpdatedTime = Instant.now(),
    ).apply { binQueries.insert(this) }

    /**
     * Generates a random bin ID consisting of three characters.
     *
     * @return The generated bin ID.
     */
    private fun generateBinId(): String = (1..3)
        .map { binIdChars.random() }
        .joinToString("")

    /**
     * Establishes a connection between the server and the client for the given bin.
     * The connection is made using the provided binId and session. Sends the current bin content over the websocket
     * on connect.
     *
     * @param binId The ID of the bin.
     * @param session The WebSocket session object.
     */
    private suspend fun addConnection(binId: String, session: DefaultWebSocketServerSession) {
        connections[binId] = (connections[binId] ?: mutableSetOf()).apply { add(session) }
        binQueries.selectOne(binId).executeAsOneOrNull()?.let { bin ->
            session.send(bin.content)
        }
    }

    /**
     * Removes a connection between the server and the client for the given bin.
     *
     * @param binId The ID of the bin.
     * @param session The WebSocket session object.
     */
    private fun removeConnection(binId: String, session: DefaultWebSocketServerSession) {
        connections[binId]?.remove(session)
    }

    /**
     * Updates the content of a bin with the provided binId and frame text.
     *
     * @param binId The ID of the bin.
     * @param frame The text frame containing the new content to be updated.
     */
    private suspend fun contentUpdated(binId: String, frame: Frame.Text) {
        val frameText = frame.readText()
        updateContent(binId, frameText)
        connections[binId]?.forEach { session ->
            session.send(frameText)
        }
    }
}