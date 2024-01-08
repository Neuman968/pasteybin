# Pasteybin 

[![Kotlin Version](https://img.shields.io/badge/Kotlin-1.5.31-blue.svg)](https://kotlinlang.org/)
[![Ktor Version](https://img.shields.io/badge/Ktor-1.6.4-orange.svg)](https://ktor.io/)
[![Flutter Version](https://img.shields.io/badge/Flutter-2.8.0-blue.svg)](https://flutter.dev/)
![build status](https://github.com/Neuman968/pasteybin/actions/workflows/ci.yml/badge.svg) 
[![PR's Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat)](http://makeapullrequest.com)

Open Source Pastebin alternative.

## Installation

To run the application you can run the docker image with command

The user interface runs on port `8081` and can be accessed through `http://localhost:8081`
The api server runs on port `8080`

```bash
docker run -p "8081:8081" -p "8080:8080" -v $(pwd):/db:rw --name pasteybin neuman314/pasteybin
```

You can also specify api host if hosted somewhere other than `localhost:8080`

```bash
docker run -e 'API_HOST=raspberrypi:8080' -e 'CORS_HOSTS=raspberrypi:8080,raspberrypi:8081' -p "8081:8081" -p "8080:8080" -v $(pwd):/db:rw --name pasteybin neuman314/pasteybin
```

If you navigate to `http://localhost:8081/` to use the application.

## Cors Configuration

Allowed Cors can be configured using the CORS_HOSTS and CORS_SCHEMES environment variables. 

When the CORS_HOSTS environment variable is not set, it defautls to a wildcard host *
The default CORS_HOSTS when running in docker is `localhost:8080` and `localhost:8081`
Default CORS_SCHEMES is http and ws. If using TLS, can be set to https and wss


## Running from source 

Clone the repository.

```bash
git clone git@github.com:Neuman968/pasteybin.git
```

Note: Java and Flutter are required in order to build the project.

The flutter application is located in the `ui` folder. 

The Kotlin server application is located in the `api` folder.

There is a `build.sh` utility that allows for building the docker image using gradle jib. Flutter is compiled as a web application and the static html and javascript is hosted by ktor on port `8081`. The REST and websocket endpoints are hosted on port `8080`. 


## Contributing

Contributions are welcome, including feature requests, pull requests, etc.

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


