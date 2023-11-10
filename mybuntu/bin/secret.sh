# Syntax: secret [get|dump]
# Example: $docker_access_token
# Example: secret dump ubuntu

if [ "$1" == "--help" ] || [ -z "$1" ]; then
  echo "Usage: secret [get|dump]"
  echo "Fetches or dumps secrets for a specified app."
  echo "  get   Fetches a secret for a specified app."
  echo "  dump  Dumps all secrets for a specified app."
  exit 0
fi

# get:
# Syntax: secret get <app> <secret> [--no-cache]
# Example: $docker_access_token
if [ "$1" == "get" ]; then
  shift
  source secret-get $@
  exit 0
fi

if [ "$1" == "dump" ]; then
  shift
  source secret-dump $@
  exit 0
fi

echo "Invalid command: $1"
