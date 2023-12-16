package com.pasteybin.plugins

import app.cash.sqldelight.ColumnAdapter
import app.cash.sqldelight.driver.jdbc.sqlite.JdbcSqliteDriver
import com.pasteybin.data.Bin
import com.pasteybin.data.Database
import com.pasteybin.service.BinService
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import org.slf4j.LoggerFactory
import java.time.Instant

val instantAdapter = object : ColumnAdapter<Instant, Long> {
    override fun decode(databaseValue: Long): Instant = Instant.ofEpochMilli(databaseValue)

    override fun encode(value: Instant): Long = value.toEpochMilli()
}

val database = Database(JdbcSqliteDriver(JdbcSqliteDriver.IN_MEMORY).apply {
    Database.Schema.create(this)
}, Bin.Adapter(instantAdapter, instantAdapter))


val binService: BinService = BinService(database.binQueries)

val logger = LoggerFactory.getLogger(Routing::class.java)

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
                    binService.connect(call.parameters["id"].toString(), this)
                }
            }
        }
    }
}
