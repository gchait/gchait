FROM dart:3.3.0 AS build
ARG SRC

WORKDIR /app
COPY ${SRC}/pubspec.* ./
RUN dart pub get

COPY ${SRC} .
RUN dart compile exe ./bin/server.dart -o ./bin/server

FROM scratch
ARG PORT

WORKDIR /app/bin
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server ./

EXPOSE ${PORT}
ENV PORT ${PORT}

CMD ["./server"]
