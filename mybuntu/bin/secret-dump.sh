# Gets all of the secrets from vlt and dumps them to the console.
if [ "$1" == "--help" ] || [ -z "$1" ]; then
  echo "Usage: secret dump <app> [--environment ENVIRONMENT]]"
  echo "Dumps all secrets for a specified app."
  echo "  <app>  The name of the app for which to dump the secrets."
  echo "Options:"
  echo "  --environment  The environment for which to fetch the secret. Defaults to development."
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

# get the secrets
SECRET_NAMES=$(vlt secrets list --project $APP_NAME --app-name $ENVIRONMENT --format json | jq -r '.[].name')

# dump the secrets
for s in $SECRET_NAMES; do
  echo "$s=$(secret get $APP_NAME $s --environment $ENVIRONMENT)"
done
