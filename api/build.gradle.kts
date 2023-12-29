import com.bmuschko.gradle.docker.tasks.image.DockerBuildImage

val ktor_version: String by project
val kotlin_version: String by project
val logback_version: String by project

plugins {
    kotlin("jvm") version "1.9.21"
    id("io.ktor.plugin") version "2.3.7"
    id("app.cash.sqldelight") version "2.0.1"
    id("com.bmuschko.docker-remote-api") version "9.4.0"

}

group = "com.pasteybin"
version = "0.0.1"

application {
    mainClass.set("com.pasteybin.ApplicationKt")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
    mavenCentral()
    google()
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm")
    implementation("io.ktor:ktor-server-websockets-jvm")
    implementation("io.ktor:ktor-server-netty-jvm")
    implementation("ch.qos.logback:logback-classic:$logback_version")
    implementation("io.ktor:ktor-server-cors:$ktor_version")
    implementation("io.ktor:ktor-server-content-negotiation:$ktor_version")
    implementation("io.ktor:ktor-serialization-jackson:$ktor_version")
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310")

    implementation("app.cash.sqldelight:sqlite-driver:2.0.1")
    testImplementation("io.ktor:ktor-server-tests-jvm")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlin_version")
    testImplementation("io.mockk:mockk:1.12.0")
}

//tasks {
//    val buildDockerImage by creating(DockerBuildImage::class) {
//        inputDir = project.file("path/to/your/application")
////        images = listOf("your-docker-image:latest")
//        dockerFile = project.file("path/to/your/Dockerfile")
//
//    }
//}

tasks.create("buildMyAppImage", DockerBuildImage::class) {
    inputDir.set(file("../Dockerfile"))
    images.add("pastybin-ui-base")
}

sqldelight {
    databases {
        create("Database") {
            packageName.set("com.pasteybin.data")
        }
    }
}