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
 * The BinService class handles the management of bins and their content.
 *
 * @property binQueries The BinQueries object used for interacting with the database.
 * @property connections A map of bin IDs to WebSocket server sessions for tracking active connections.
 */
class BinService(private val binQueries: BinQueries) {


    /**
     * A mutable map that stores the connections between the server and the client for each bin.
     * The map uses binId as the key and a set of WebSocket server sessions as the value.
     */
    private val connections: MutableMap<String, MutableSet<DefaultWebSocketServerSession>> = ConcurrentHashMap()

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
            logger.error(e.localizedMessage)
        } finally {
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
     * Creates a new bin with the provided binId or a generated binId if none is provided.
     *
     * @param binId The ID of the bin (optional, default is generated using generateBinId()).
     * @return The created bin.
     */
    fun newBin(binId: String = generateBinId()): Bin = Bin(
        id = binId,
        content = "",
        createdTime = Instant.now(),
        lastUpdated = Instant.now(),
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
     * The connection is made using the provided binId and session.
     *
     * @param binId The ID of the bin.
     * @param session The WebSocket session object.
     */
    private fun addConnection(binId: String, session: DefaultWebSocketServerSession) {
        connections[binId] = (connections[binId] ?: mutableSetOf()).apply { add(session) }
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