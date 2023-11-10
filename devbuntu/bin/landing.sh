ORIGIN_DIR=$(pwd)
LANDING_DIR=/mnt/code/github/ryan-augustinsky/landing
PORT=3006

# if argument is start
if [ "$1" == "start" ]; then
  cd $LANDING_DIR
  npm install
  PORT=$PORT npm run start
  cd $ORIGIN_DIR
fi

# if argument is stop
if [ "$1" == "stop" ]; then
  # kill processes with react-scripts or serve
  kill -9 $(ps aux | grep '[r]eact-scripts' | awk '{print $2}')
  kill -9 $(ps aux | grep '[b]in/serve' | awk '{print $2}')
fi

# if argument is restart
if [ "$1" == "restart" ]; then
  landing stop
  landing start
fi

# if arguement is fetch
if [ "$1" == "fetch" ]; then
  cd $LANDING_DIR
  npm run fetch
  cd $ORIGIN_DIR
fi

# if argument is build
if [ "$1" == "build" ]; then
  cd $LANDING_DIR
  npm run build
  cd $ORIGIN_DIR
fi

# if argument is serve
if [ "$1" == "serve" ]; then
  cd $LANDING_DIR
  PORT=3006 npm run serve
  cd $ORIGIN_DIR
fi
