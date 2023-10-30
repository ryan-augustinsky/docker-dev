echo "Building $1:latest"
docker buildx create --use
docker buildx build . --platform linux/amd64,linux/arm64 --push -t $1:latest
docker pull $1:latest
docker image prune --force --filter "REPOSITORY=$1"
