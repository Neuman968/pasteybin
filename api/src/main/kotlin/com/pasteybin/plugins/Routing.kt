package com.pasteybin.plugins

import app.cash.sqldelight.ColumnAdapter
import app.cash.sqldelight.driver.jdbc.sqlite.JdbcSqliteDriver
import com.pasteybin.data.Bin
import com.pasteybin.data.Database
import com.pasteybin.service.BinService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import org.slf4j.LoggerFactory
import java.io.File
import java.time.Instant

val instantAdapter = object : ColumnAdapter<Instant, Long> {
    override fun decode(databaseValue: Long): Instant = Instant.ofEpochMilli(databaseValue)

    override fun encode(value: Instant): Long = value.toEpochMilli()
}

val dbEnv = System.getenv("DB_LOCATION") ?: "jdbc:sqlite:pastey.db"

val database = Database(JdbcSqliteDriver(dbEnv).apply {
    Database.Schema.create(this)
}, Bin.Adapter(instantAdapter, instantAdapter))

val binService: BinService = BinService(database.binQueries)

val logger = LoggerFactory.getLogger(Routing::class.java)

/**
 * Configures the routing for the application. Sets up the routes and handlers for different endpoints.
 *
 * This method is called within the `module` function of the application.
 *
 * - The root*/
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

                put("/title") {
                    binService.updateTitle(call.parameters["id"].toString(), call.receive())?.let {
                        call.respond(it)
                    } ?: call.respond(HttpStatusCode.NotFound, "Bin not found")
                }
                webSocket("/ws") {
                    binService.connect(call.parameters["id"].toString(), this)
                }
            }
        }
    }
}
