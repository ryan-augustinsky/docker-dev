echo "Building $1:latest"
# fixes a problem with buildx not stopping properly
docker stop $(docker ps -a -q --filter ancestor=moby/buildkit:buildx-stable-1 --format="{{.ID}}")
docker system prune --force
docker volume prune -a -f
docker buildx create --use
docker buildx build $2/. --platform linux/amd64,linux/arm64 --push -t $1:latest
docker pull $1:latest
