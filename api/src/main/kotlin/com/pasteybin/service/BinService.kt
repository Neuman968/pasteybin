package com.pasteybin.service

import com.pasteybin.data.Bin
import com.pasteybin.data.BinQueries
import com.pasteybin.plugins.binService
import com.pasteybin.plugins.logger
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import java.time.Instant
import java.util.concurrent.ConcurrentHashMap

val binIdChars: List<Char> = ('A'..'Z') + ('a'..'z') + ('0'..'9')

class BinService(private val binQueries: BinQueries) {

    private val connections: MutableMap<String, MutableSet<DefaultWebSocketServerSession>> = ConcurrentHashMap()

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

    fun getOrderLastUpdated(): List<Bin> = binQueries.selectAll().executeAsList()

    fun updateContent(binId: String, content: String) = binQueries.update(content, Instant.now(), binId)

    fun newBin(binId: String = generateBinId()): Bin = Bin(
        id = binId,
        content = "",
        createdTime = Instant.now(),
        lastUpdated = Instant.now(),
    ).apply { binQueries.insert(this) }

    private fun generateBinId(): String = (1..3)
        .map { binIdChars.random() }
        .joinToString("")

    private fun addConnection(binId: String, session: DefaultWebSocketServerSession) {
        connections[binId] = (connections[binId] ?: mutableSetOf()).apply { add(session) }
    }

    private fun removeConnection(binId: String, session: DefaultWebSocketServerSession) {
        connections[binId]?.remove(session)
    }

    private suspend fun contentUpdated(binId: String, frame: Frame.Text) {
        val frameText = frame.readText()
        updateContent(binId, frameText)
        connections[binId]?.forEach { session ->
            session.send(frameText)
        }
    }
}