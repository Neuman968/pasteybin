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

                    println("Adding user!")
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
                        println(e.localizedMessage)
                    } finally {
//                        connections.remove(this)
//                        println("Removing $thisConnection!")
//                        connections -= thisConnection
                    }

                }
//                    webSocketService.addConnection(this)
//                    println("onConnect")
                // NOTE: the below keep the connection alive, otherwise it will close automatically
//                    try {
//                        for (frame in incoming) {
//                            val text = (frame as Frame.Text).readText()
//                            println("onMessage $text")
//                            outgoing.send(Frame.Text(text))
//                        }
//                    } catch (e: ClosedReceiveChannelException) {
//                        logger.error("Closed Channel: ", e)
//                    } catch (e: Throwable) {
//                        logger.error("Generic Error: ", e)
//                    }
            }
        }
    }
}
