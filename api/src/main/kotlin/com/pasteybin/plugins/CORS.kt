package com.pasteybin.plugins

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureCors() {
    install(CORS) {
        allowMethod(HttpMethod.Post)
        allowMethod(HttpMethod.Put)
        allowMethod(HttpMethod.Delete)
        allowMethod(HttpMethod.Get)
        allowMethod(HttpMethod.Options)
        anyHost()
        allowHeader("Accept")
        allowHeader("Content-Type")
        allowHeadersPrefixed("sec")
        allowHeader("Refer")
        allowHeader("User-Agent")
        allowNonSimpleContentTypes = true
    }
    routing {
        options("{...}") {
            call.respond("OK")
        }
    }
}