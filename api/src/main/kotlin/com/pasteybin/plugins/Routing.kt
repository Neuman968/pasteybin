package com.pasteybin.plugins

import app.cash.sqldelight.ColumnAdapter
import app.cash.sqldelight.driver.jdbc.sqlite.JdbcSqliteDriver
import com.pasteybin.data.Bin
import com.pasteybin.data.Database
import com.pasteybin.service.BinService
import io.ktor.network.sockets.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import kotlinx.coroutines.channels.ClosedReceiveChannelException
import org.slf4j.LoggerFactory
import java.time.Duration
import java.time.Instant
import java.util.*
import java.util.concurrent.ConcurrentHashMap
import kotlin.collections.LinkedHashSet

val instantAdapter = object : ColumnAdapter<Instant, Long> {
    override fun decode(databaseValue: Long): Instant = Instant.ofEpochMilli(databaseValue)

    override fun encode(value: Instant): Long = value.toEpochMilli()
}

val database = Database(JdbcSqliteDriver(JdbcSqliteDriver.IN_MEMORY).apply {
    Database.Schema.create(this)
}, Bin.Adapter(instantAdapter, instantAdapter))


val binService: BinService = BinService(database.binQueries)

val logger = LoggerFactory.getLogger(Routing::class.java)

val connections: MutableMap<String, MutableSet<DefaultWebSocketServerSession>> = ConcurrentHashMap()

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respond(mapOf("foo" to "Hello World!"))
        }

        route("/bin") {
            get {
                call.respond(binService.getOrderLastUpdated())
            }
            post {
                call.respond(binService.newBin())
            }

            route("/{id}") {

                post {
                    call.respond(binService.newBin(call.parameters["id"].toString()))
                }
                webSocket("/ws") {
                    val binPathId = call.parameters["id"].toString()
                    val session = this
                    connections[binPathId] = (connections[binPathId] ?: mutableSetOf()).apply { add(session) }

                    try {
                        for (frame in incoming) {
                            frame as? Frame.Text ?: continue
                            val receivedText = frame.readText()
                            binService.updateContent(binPathId, receivedText)
                            connections[binPathId]?.forEach {
                                it.send(receivedText)
                            }
                        }
                    } catch (e: Exception) {
                        logger.error(e.localizedMessage)
                    } finally {
                        connections[binPathId]?.remove(this)
                    }
                }
            }
        }
    }
}
