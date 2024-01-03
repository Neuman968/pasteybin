package com.pasteybin.plugins

import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.io.File

fun Application.staticUiModule() {
    install(ContentNegotiation) {
    }
    routing {
        get("/apihost") {
            call.respondText { System.getenv("API_HOST") ?: "localhost:8080" }
        }

        get("/usetls") {
            call.respondText { System.getenv("USE_TLS") ?: "false" }
        }
        staticFiles("/", File("/opt/pasteybin/ui")) {
            default("index.html")
            enableAutoHeadResponse()
        }
    }
}