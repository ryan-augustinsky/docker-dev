BUILD_NAME=$1
ENVIRONMENT=$2

# if no build name or no environment, print usage
if [ -z "$BUILD_NAME" ] || [ -z "$ENVIRONMENT" ] || [ "$#" -lt 3 ]; then
  echo "Usage: $0 <build_name> <environment> <app-1> ... <app-N>"
  exit 1
fi

if ! [ -d "$BUILDS_DIR" ]; then
  echo "BUILDS_DIR $BUILDS_DIR does not exist"
  exit 1
fi

BUILD_DIR=$BUILDS_DIR/$BUILD_NAME
mkdir -p $BUILD_DIR

STARTUP_DIR=$BUILD_DIR/startup
DOCKER_FILE_PATH=$BUILD_DIR/Dockerfile
rm -rf $STARTUP_DIR
trap "rm -rf $STARTUP_DIR && rm -rf $DOCKER_FILE_PATH" EXIT

mkdir -p $STARTUP_DIR

cat << EOF > $DOCKER_FILE_PATH
FROM $docker_username/mybuntu:latest
COPY startup/ /mybuntu/startup/
CMD ["bash", "-c", "mybuntu && /bin/bash"]
EOF

# iterate over apps
for app in "${@:3}"
do
  app_unique=$app-$(openssl rand -hex 6)
  ROOT_DIR=$STARTUP_DIR/$app_unique
  mkdir -p $ROOT_DIR
  cat $(app info $app path) > $ROOT_DIR/docker-compose.yml
done

export DOCKER_IMAGE_NAME=prodbuntu
export DOCKER_IMAGE_TAG=$BUILD_NAME-$ENVIRONMENT
docker buildx build $BUILD_DIR -t $docker_username/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG --platform linux/amd64,linux/arm64 --push

app export docker-dev/prodbuntu $ENVIRONMENT > $BUILD_DIR/docker-compose.yml
echo $BUILD_DIR/docker-compose.yml

# mkdir -p $STARTUP_DIR/veganism-social

# # iterate 3 times
# for i in {1..3}
# do
#   ROOT_DIR=$STARTUP_DIR/veganism-social/sidekiq-$i
#   mkdir -p $ROOT_DIR
#   cat $(app info veganism-social/sidekiq path) > $ROOT_DIR/docker-compose.yml
# done

# export DOCKER_IMAGE_NAME=veganism-social
# export DOCKER_IMAGE_TAG=sidekiq-$ENVIRONMENT
# docker buildx build $BUILD_DIR -t $docker_username/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG --platform linux/amd64,linux/arm64 --push


# app export docker-dev/prodbuntu $ENVIRONMENT > $BUILD_DIR/docker-compose.yml
