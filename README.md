# graalvm-maven-builder

Builder-stage base image for GraalVM native builds: **Ubuntu 26.04 + GraalVM JDK 21 + Maven 3.9.16** (includes `native-image`).

Used as the `FROM` image for builder stages, e.g. in http-service-spliter.

## Images

Published on every push to `master` by GitHub Actions:

- `ghcr.io/xenoamess/graalvm-maven-builder:jdk21-maven3.9.16-latest`
- `docker.io/xenoamess/graalvm-maven-builder:jdk21-maven3.9.16-latest`

Each publish also creates a timestamped tag (`jdk21-maven3.9.16-<timestamp>`).

## Usage

```dockerfile
FROM ghcr.io/xenoamess/graalvm-maven-builder:jdk21-maven3.9.16-latest AS builder
WORKDIR /build
COPY . .
RUN mvn -Pnative package -DskipTests
```

`JAVA_HOME` is set to `/opt/graalvm`; `java`, `native-image`, and `mvn` are on `PATH`.

The image removes Maven's default `maven-default-http-blocker` mirror, so internal HTTP repositories work out of the box.

## Build locally

```sh
docker build -f docker/Dockerfile_builder .
```

`docker/build.sh` builds **and pushes** all 4 tags to GHCR and Docker Hub (requires docker daemon + registry logins) — pushing to `master` is the normal release path instead.
