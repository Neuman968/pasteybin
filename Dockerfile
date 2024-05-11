FROM ubuntu:latest as flutter-deps

RUN apt-get update -y && apt-get upgrade -y;
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa

ARG FLUTTER_VERSION=3.19.6

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

RUN cd /usr/local/flutter && git fetch && git checkout $FLUTTER_VERSION

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

COPY ./ui /app
WORKDIR /app

RUN flutter clean && flutter pub get
RUN flutter build web

FROM gradle:jdk19-jammy

ARG DOCKER_USERNAME=unset
ARG DOCKER_PASSWORD=unset
ARG DOCKER_IMAGE=neuman314/pasteybin-untagged

COPY ./api .

COPY --from=flutter-deps /app/build/web ./static

RUN ./gradlew clean jib -Pmultiplatform_build=true \
	-PDOCKER_IMAGE=$DOCKER_IMAGE \
	-PDOCKER_USERNAME=$DOCKER_USERNAME \
	-PDOCKER_PASSWORD=$DOCKER_PASSWORD


ENTRYPOINT [ "sh" ]
