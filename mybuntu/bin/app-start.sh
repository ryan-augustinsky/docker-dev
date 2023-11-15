# Starts an app using docker-compose
if [ "$1" == "--help" ] || [ -z "$1" ]; then
  echo "Usage: app start <app> [--environment ENVIRONMENT]]"
  echo "Starts an app using docker-compose"
  echo "  <app>  The name of the app for which to start."
  echo "Options:"
  echo "  --environment  The environment for which to fetch the secrets. Defaults to $DEFAULT_ENVIRONMENT."
  exit 0
fi

APP_NAME=$1

# get values from --envirionment (default: $DEFAULT_ENVIRONMENT)
ENVIRONMENT=$DEFAULT_ENVIRONMENT
while [[ $# -gt 0 ]]
do
  if [ "$1" == "--environment" ]; then
    shift
    ENVIRONMENT=$1
  fi
  shift
done

DOCKER_COMPOSE_PATH=$(app info $APP_NAME path)

if [ ! -f $DOCKER_COMPOSE_PATH ]; then
  echo "File $DOCKER_COMPOSE_PATH does not exist"
  exit 1
fi

PROJECT_NAME=$(app info $APP_NAME project)
export $(secret dump $PROJECT_NAME --environment $ENVIRONMENT | xargs)
docker-compose -f $DOCKER_COMPOSE_PATH pull
docker-compose -f $DOCKER_COMPOSE_PATH up -d
