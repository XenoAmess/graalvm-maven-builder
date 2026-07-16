#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

TAG_PREFIX="${TAG_PREFIX:-jdk21-maven3.9.16}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

GHCR_IMAGE="ghcr.io/xenoamess/graalvm-maven-builder"
DOCKERHUB_IMAGE="docker.io/xenoamess/graalvm-maven-builder"

echo "========================================"
echo "Building builder image: ${TAG_PREFIX}"
echo "========================================"

cd "${PROJECT_ROOT}"

docker build -f docker/Dockerfile_builder \
  -t "${GHCR_IMAGE}:${TAG_PREFIX}-latest" \
  -t "${GHCR_IMAGE}:${TAG_PREFIX}-${TIMESTAMP}" \
  -t "${DOCKERHUB_IMAGE}:${TAG_PREFIX}-latest" \
  -t "${DOCKERHUB_IMAGE}:${TAG_PREFIX}-${TIMESTAMP}" \
  .

for tag in "${TAG_PREFIX}-latest" "${TAG_PREFIX}-${TIMESTAMP}"; do
  docker push "${GHCR_IMAGE}:${tag}"
  docker push "${DOCKERHUB_IMAGE}:${tag}"
done

echo "Pushed:"
echo "  ${GHCR_IMAGE}:${TAG_PREFIX}-latest"
echo "  ${GHCR_IMAGE}:${TAG_PREFIX}-${TIMESTAMP}"
echo "  ${DOCKERHUB_IMAGE}:${TAG_PREFIX}-latest"
echo "  ${DOCKERHUB_IMAGE}:${TAG_PREFIX}-${TIMESTAMP}"
