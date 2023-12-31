# Pasteybin 

[![Kotlin Version](https://img.shields.io/badge/Kotlin-1.5.31-blue.svg)](https://kotlinlang.org/)
[![Ktor Version](https://img.shields.io/badge/Ktor-1.6.4-orange.svg)](https://ktor.io/)
[![Flutter Version](https://img.shields.io/badge/Flutter-2.8.0-blue.svg)](https://flutter.dev/)

[![GitHub CI](https://github.com/your-username/your-project/workflows/CI/badge.svg)](https://github.com/your-username/your-project/actions)

Open Source Pastebin alternative. Runs on any hardware that can run docker.

## Installation

To run the application you can run the docker image with command

The user interface runs on port `8081` and can be accessed through `http://localhost:8081`
The api server runs on port `8080`

```bash
docker run -p "8081:8081" -p "8080:8080" -v $(pwd):/db:rw --name pasteybin com.pasteybin:latest
```


## Technologies used in this project

- **Backend:** 
   - [Kotlin](https://kotlinlang.org/)
   - [Ktor](https://ktor.io)
   - [SqlDelight](https://github.com/cashapp/sqldelight)
   - [SqlLite3](https://www.sqlite.org/index.html)
   - [Mockk](https://mockk.io/)
- **Frontend:** Flutter (Web)
   - [Flutter](https://flutter.dev/)
   - [Json Annotation](https://pub.dev/packages/json_annotation)
   - [WebSocket Channel](https://pub.dev/packages/web_socket_channel)
   - [Go Router](https://pub.dev/packages/go_router)

## Cloning the project

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/your-project.git
   cd your-project
