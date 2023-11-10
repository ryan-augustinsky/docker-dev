if [ "$1" == "--help" ] || [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: secret get <app> <secret> [--environment ENVIRONMENT] [--no-cache] "
  echo "Fetches a secret for a specified app. If --no-cache is set, the secret is fetched even if it has been cached."
  echo "  <app>       The name of the app for which to fetch the secret."
  echo "  <secret>    The name of the secret to fetch."
  echo "Options:"
  echo "  --environment  The environment for which to fetch the secret. Defaults to $DEFAULT_ENVIRONMENT."
  echo "  --no-cache  Fetch the secret even if it has been cached. Defaults to false."
  exit 0
fi

APP_NAME=$1
SECRET_NAME=$2

# get values from --envirionment (default: $DEFAULT_ENVIRONMENT) and --no-cache (default: false)
ENVIRONMENT=$DEFAULT_ENVIRONMENT
NO_CACHE=false
while [[ $# -gt 0 ]]
do
  if [ "$1" == "--environment" ]; then
    shift
    ENVIRONMENT=$1
  elif [ "$1" == "--no-cache" ]; then
    NO_CACHE=true
  fi
  shift
done

CACHE_SECRET_ROOT=/mybuntu/secrets
CACHE_SECRET_APP=$CACHE_SECRET_ROOT/$APP_NAME
CACHE_SECRET_ENVIRONMENT=$CACHE_SECRET_APP/$ENVIRONMENT
CACHE_SECRET=$CACHE_SECRET_ENVIRONMENT/$SECRET_NAME

# create the secrets directory if it doesn't exist
mkdir -p $CACHE_SECRET_ROOT
mkdir -p $CACHE_SECRET_APP
mkdir -p $CACHE_SECRET_ENVIRONMENT

# check if the secret has not been cached already or if --no-cache is set
if [ ! -f $CACHE_SECRET ] || [ "$NO_CACHE" == "true" ]; then
  SECRET=$(vlt secrets get --project $APP_NAME --app-name $ENVIRONMENT --plaintext $SECRET_NAME)
  # if the secret begins with Error: set it to null
  if [[ $SECRET == Error:* ]]; then
    SECRET=""
  fi

  echo $SECRET > $CACHE_SECRET
fi

# read the secret
cat $CACHE_SECRET
