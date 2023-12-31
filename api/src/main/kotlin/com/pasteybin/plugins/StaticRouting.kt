package com.pasteybin.plugins

import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.routing.*
import java.io.File

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