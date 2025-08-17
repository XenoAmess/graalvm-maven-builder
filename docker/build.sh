docker pull ghcr.io/graalvm/jdk-community:latest
export version=$(date "+%Y%m%d_%H%M%S")
echo ${version}
export tag=ghcr.io/xenoamess/graalvm-maven-builder:0.0.1.${version}
DOCKER_BUILDKIT=1 docker build -t ${tag} -f Dockerfile_builder ../
docker push ${tag}
