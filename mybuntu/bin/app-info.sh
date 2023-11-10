APP_NAME=$1
PART=$2

while IFS= read -r LINE; do
  if [ "$(echo $LINE | awk '{print $1}')" == "$APP_NAME" ]; then

    if [ "$PART" == "" ]; then
      echo $LINE
      exit 0
    fi

    if [ "$PART" == "name" ]; then
      echo $(echo $LINE | awk '{print $1}')
      exit 0
    fi

    if [ "$PART" == "project" ]; then
      echo $(echo $LINE | awk '{print $2}')
      exit 0
    fi

    if [ "$PART" == "path" ]; then
      echo $(echo $LINE | awk '{print $3}')
      exit 0
    fi

    if [ "$PART" == "root" ]; then
      echo $(echo $LINE | awk '{print $4}')
      exit 0
    fi

    echo "Invalid part: $PART"
    echo "Valid parts are: name, project, path, root"
    exit 1
  fi
done < <(app list)

echo "Could not find app: $APP_NAME, run 'app list' to see available apps"
exit 1
