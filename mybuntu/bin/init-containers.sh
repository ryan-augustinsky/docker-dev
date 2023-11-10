# ensure $1 is set, write --help
if [ "$1" == "" ]; then
  echo "Usage: $0 <app-dir>"
  exit 1
fi

APP_DIR=$1

if [ ! -d $APP_DIR ]; then
  echo "Directory $APP_DIR does not exist"
  exit 1
fi

# stop & rm all docker-containers that have $APP_DIR at the start of their working directory (found with docker container inspect, inside Config/Labels/com.docker.compose.project.working_dir)
docker container ls --format '{{.ID}} {{.Names}}' | while read -r CONTAINER_LINE; do
  CONTAINER_ID=$(echo $CONTAINER_LINE | awk '{print $1}')
  CONTAINER_NAME=$(echo $CONTAINER_LINE | awk '{print $2}')
  CONTAINER_WORKING_DIR=$(docker container inspect $CONTAINER_ID --format '{{ index .Config.Labels "com.docker.compose.project.working_dir" }}')
  if [[ $CONTAINER_WORKING_DIR == $APP_DIR* ]]; then
    docker container stop $CONTAINER_NAME
    docker container rm $CONTAINER_NAME
  fi
done

app list | while read -r APP_LINE; do
  APP_NAME=$(echo $APP_LINE | awk '{print $1}')
  app restart $APP_NAME
done
