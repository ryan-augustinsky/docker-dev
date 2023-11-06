ORIGIN_DIR=$(pwd)
MASTODON_DIR=/code/github/ryan-augustinsky/veganism.social

# if argument is bundle
if [ "$1" == "bundle" ]; then
  cd $MASTODON_DIR
  export BUNDLE_PATH=/devbuntu/bundle
  bundle config set path $BUNDLE_PATH
  bundle install
  cd $ORIGIN_DIR
fi

# if argument is "start"
if [ "$1" == "start" ]; then
  mastodon bundle

  cd $MASTODON_DIR
  yarn install

  RAILS_ENV=development bundle exec $MASTODON_DIR/bin/webpack-dev-server &
  RAILS_ENV=development $MASTODON_DIR/bin/rails s -b 0.0.0.0 -p 3000 &
  cd $ORIGIN_DIR
  mastodon status
fi

# if argument is "stop"
if [ "$1" == "stop" ]; then
  # kill processes with puma or webpack-dev-server
  kill -9 $(ps aux | grep '[p]uma' | awk '{print $2}')
  kill -9 $(ps aux | grep '[w]ebpack-dev-server' | awk '{print $2}')
fi

# if argument is "restart"
if [ "$1" == "restart" ]; then
  mastodon stop
  mastodon start
fi

# if argument is "status"
if [ "$1" == "status" ]; then
  # check if puma or webpack-dev-server is running
  if [ $(ps aux | grep '[p]uma' | awk '{print $2}') ]; then
    echo "puma is running"
  else
    echo "puma is not running"
  fi

  if [ $(ps aux | grep '[w]ebpack-dev-server' | awk '{print $2}') ]; then
    echo "webpack-dev-server is running"
  else
    echo "webpack-dev-server is not running"
  fi
fi

# if argument is "logs"
if [ "$1" == "logs" ]; then
  # check if -n is supplied
  if [ "$2" == "-n" ]; then
    tail -n $3 $LOG_DIR/mastodon.log
  else
    tail -f $LOG_DIR/mastodon.log
  fi
fi

# if argument is "console"
if [[ "$1" == "console" || "$1" == "c" ]]; then
  mastodon bundle
  cd $MASTODON_DIR
  RAILS_ENV=development $MASTODON_DIR/bin/rails c
  cd $ORIGIN_DIR
fi

# if argument is cd
if [ "$1" == "cd" ]; then
  cd $MASTODON_DIR
fi
