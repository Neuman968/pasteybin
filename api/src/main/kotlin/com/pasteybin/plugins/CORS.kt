package com.pasteybin.plugins

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

/**
 * Configures Cross-Origin Resource Sharing (CORS) for the application.
 * CORS allows a web page to make requests to a different domain than the one it originated from.
 *
 * This method is called within the `module` function of the application.
 *
 * This method sets up the allowed methods, hosts, headers, and content types for CORS.
 */
fun Application.configureCors() {
    install(CORS) {
        allowMethod(HttpMethod.Post)
        allowMethod(HttpMethod.Put)
        allowMethod(HttpMethod.Delete)
        allowMethod(HttpMethod.Get)
        allowMethod(HttpMethod.Options)

        val schemes: List<String> = corsScheme()
        corsHosts().forEach { host ->
            allowHost(host, schemes)
        }

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

/**
 * Retrieves the list of allowed CORS schemes from the environment variable "CORS_SCHEMES".
 * If the environment variable is null or empty, the default schemes ["http", "ws"] will be used.
 *
 * @return The list of allowed CORS schemes.
 */
fun corsScheme(): List<String> = System.getenv("CORS_SCHEMES")?.split(",") ?: listOf("http", "ws")

/**
 * Retrieves the list of allowed CORS hosts from the environment variable "CORS_HOSTS".
 * If the environment variable is null or empty, the default hosts ["localhost:8080", "localhost:8081"] will be used.
 *
 * @return The list of allowed CORS hosts.
 */
fun corsHosts(): List<String> = System.getenv("CORS_HOSTS")?.split(",") ?: listOf("localhost:8080", "localhost:8081")
