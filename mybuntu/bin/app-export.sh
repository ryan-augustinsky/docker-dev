APP_NAME=$1
ENVIRONMENT=$2

# require APP_NAME and ENVIRONMENT, if missing display --help
if [ "$APP_NAME" == "" ] || [ "$ENVIRONMENT" == "" ]; then
  echo "Usage: app export APP_NAME ENVIRONMENT"
  echo "  APP_NAME: the name of the app to export"
  echo "  ENVIRONMENT: the environment to export, e.g. development or production"
  exit 1
fi

DOCKER_COMPOSE_PATH=$(app info $APP_NAME path)

if [ ! -f $DOCKER_COMPOSE_PATH ]; then
  echo "File $DOCKER_COMPOSE_PATH does not exist"
  exit 1
fi

PROJECT_NAME=$(app info $APP_NAME project)
while read -r line; do
  key=$(echo $line | cut -d '=' -f 1)
  value=$(echo $line | cut -d '=' -f 2-)

  export "$key"="$value"
done < <(secret dump $PROJECT_NAME --environment $ENVIRONMENT)

# $(docker-compose -f $DOCKER_COMPOSE_PATH config)
# echo the above but make sure to output the newlines from the docker-compose config
docker-compose -f $DOCKER_COMPOSE_PATH config
