# AGENTS.md

Single-purpose repo: builds and publishes one Docker image (`docker/Dockerfile_builder`) — Ubuntu 26.04 + GraalVM JDK 21 + Maven 3.9.16, used as a builder-stage base for GraalVM native builds (e.g. http-service-spliter). There is no application code, no tests, no lint.

## Publishing

- Push to `master` is the release: `.github/workflows/build.yml` builds and pushes `ghcr.io/xenoamess/graalvm-maven-builder` and `docker.io/xenoamess/graalvm-maven-builder` (Docker Hub only if `DOCKERHUB_USERNAME`/`DOCKERHUB_TOKEN` secrets exist). Do not build/push locally unless asked.
- After every change, commit and push to `master` immediately — that push is what triggers the publish.
- `docker/build.sh` does the same locally but pushes 4 tags and requires the docker daemon running plus registry logins.
- Tags are `jdk21-maven3.9.16-latest` and `jdk21-maven3.9.16-<timestamp>`.

## Version bump sync (easy to miss)

The Maven version appears in 3 places and must be bumped together:
- `docker/Dockerfile_builder` — `ARG MAVEN_VERSION`
- `docker/build.sh` — `TAG_PREFIX` default
- `.github/workflows/build.yml` — `env.TAG_PREFIX`

## Dockerfile quirks

- The `perl -0pi` line in the Maven install `RUN` intentionally deletes the `maven-default-http-blocker` mirror from Maven's `conf/settings.xml` (Maven 3.8.1+ blocks external HTTP repos by default; downstream projects use internal HTTP repos). Do not remove it. The following `! grep -q` line fails the build if removal stops matching after a Maven upgrade.
- Maven is fetched from `archive.apache.org/dist/maven/maven-${major}/...`; the `maven-3/` vs `maven-4/` path segment is derived from the version prefix.
- The install `RUN` ends with `java -version && native-image --version && mvn -version` as a fail-early toolchain check — keep verification inside that `RUN`.

## Verification

No test suite. Verify by building the image: `docker build -f docker/Dockerfile_builder .` (needs ~1 GB download: GraalVM + Maven).
