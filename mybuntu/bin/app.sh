if [ "$1" == "start" ]; then
  shift
  source app-start $@
  exit 0
fi

if [ "$1" == "stop" ]; then
  shift
  source app-stop $@
  exit 0
fi

if [ "$1" == "pull" ]; then
  shift
  source app-pull $@
  exit 0
fi

if [ "$1" == "restart" ]; then
  shift
  source app-restart $@
  exit 0
fi

if [ "$1" == "list" ]; then
  shift
  source app-list $@
  exit 0
fi

if [ "$1" == "info" ]; then
  shift
  source app-info $@
  exit 0
fi

if [ "$1" == "export" ]; then
  shift
  source app-export $@
  exit 0
fi

echo "Invalid command: $1"
echo "Valid commands are: start, stop, pull, restart, list, info, export"
