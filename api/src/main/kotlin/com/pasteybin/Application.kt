package com.pasteybin

import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.pasteybin.plugins.configureCors
import com.pasteybin.plugins.configureRouting
import com.pasteybin.plugins.configureSockets
import io.ktor.serialization.jackson.*
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.http.content.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.routing.*
import java.io.File

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = false)

    embeddedServer(Netty, port = 8081, host = "0.0.0.0", module = Application::staticUiModule)
        .start(wait = true)
}

fun Application.staticUiModule() {
    install(ContentNegotiation) {
    }
    routing {
        staticFiles("/", File("/opt/pasteybin/ui")) {
            default("index.html")
            enableAutoHeadResponse()
        }
    }
}

fun Application.module() {
    install(ContentNegotiation) {
        jackson {
            registerModule(JavaTimeModule())
            disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
        }
    }
    configureSockets()
    configureCors()
    configureRouting()
}
