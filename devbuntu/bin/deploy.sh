REMOTE_HOST=$1
ENVIRONMENT=$2

# if no build name or no environment, print usage
if [ -z "$REMOTE_HOST" ] || [ -z "$ENVIRONMENT" ] || [ "$#" -lt 3 ]; then
  echo "Usage: $0 <remote_host> <environment> <app-1> ... <app-N>"
  exit 1
fi

# Build name is random 6 hex characters
BUILD_NAME=$REMOTE_HOST

# set DOCKER_COMPOSE_FILE_PATH to the result of $(build $BUILD_NAME $ENVIRONMENT "${@:3}")
DOCKER_COMPOSE_FILE_PATH=$(build $BUILD_NAME $ENVIRONMENT "${@:3}")
echo "DOCKER_COMPOSE_FILE_PATH: $DOCKER_COMPOSE_FILE_PATH"
DOCKER_COMPOSE_FILE_NAME=$(basename $DOCKER_COMPOSE_FILE_PATH)
echo "DOCKER_COMPOSE_FILE_NAME: $DOCKER_COMPOSE_FILE_NAME"

# Variables
REMOTE_USER="root"
REMOTE_PATH="~"
LOCAL_PATH=$DOCKER_COMPOSE_FILE_PATH
PRIVATE_KEY_PATH="/mnt/code/.ssh/id_rsa"

#Copy file to remote server
scp -i $PRIVATE_KEY_PATH $DOCKER_COMPOSE_FILE_PATH $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH

#SSH and run commands on the remote server
ssh -i $PRIVATE_KEY_PATH $REMOTE_USER@$REMOTE_HOST << EOF
cd $REMOTE_PATH
ls -la
echo $docker_access_token | docker login --username=$docker_username --password-stdin
docker-compose -f $REMOTE_PATH/$DOCKER_COMPOSE_FILE_NAME pull
docker-compose -f $REMOTE_PATH/$DOCKER_COMPOSE_FILE_NAME down --remove-orphans
docker-compose -f $REMOTE_PATH/$DOCKER_COMPOSE_FILE_NAME up -d
EOF
