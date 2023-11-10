APP_NAME=$1

DOCKER_COMPOSE_PATH=$(app info $APP_NAME path)

if [ ! -f $DOCKER_COMPOSE_PATH ]; then
  echo "File $DOCKER_COMPOSE_PATH does not exist"
  exit 1
fi

docker-compose -f $DOCKER_COMPOSE_PATH pull
