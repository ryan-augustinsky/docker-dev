echo "Building $1:latest"
# fixes a problem with buildx not stopping properly
docker stop $(docker ps -a -q --filter ancestor=moby/buildkit:buildx-stable-1 --format="{{.ID}}")
docker container prune -f
docker volume prune -a -f
docker buildx create --use

# run $2/configure-build.sh if it exists
if [ -f $2/configure-build.sh ]; then
  $2/configure-build.sh
fi

docker buildx build $2/. --platform linux/amd64,linux/arm64 --push -t $1:latest --cache-to type=registry,ref=$1:cache --cache-from type=registry,ref=$1:cache
docker pull $1:latest
