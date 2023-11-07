# Syntax: secret <app> <secret> [--no-cache]
# Example: secret ubuntu docker_access_token

if [ "$1" == "--help" ] || [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: secret <app> <secret> [--no-cache]"
  echo "Fetches a secret for a specified app. If --no-cache is set, the secret is fetched even if it has been cached."
  echo "  <app>       The name of the app for which to fetch the secret."
  echo "  <secret>    The name of the secret to fetch."
  echo "  --no-cache  Fetch the secret even if it has been cached."
  exit 0
fi

CACHE_SECRET_ROOT=/mybuntu/secrets
CACHE_SECRET_APP=$CACHE_SECRET_ROOT/$1
CACHE_SECRET=$CACHE_SECRET_APP/$2

# create the secrets directory if it doesn't exist
mkdir -p $CACHE_SECRET_APP

# check if the secret has not been cached already or if --no-cache is set
if [ ! -f $CACHE_SECRET ] || [ "$3" == "--no-cache" ]; then
  SECRET=$(vlt secrets get --project personal --app-name $1 --plaintext $2)
  # if the secret begins with Error: set it to null
  if [[ $SECRET == Error:* ]]; then
    SECRET=""
  fi

  echo $SECRET > $CACHE_SECRET
fi

# read the secret
cat $CACHE_SECRET

