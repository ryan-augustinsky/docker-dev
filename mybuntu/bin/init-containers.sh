# iterate through every dir in /devbuntu/container or /mybuntu/contaner
# in each dir, run the gen-env.sh script if it exists
# then run docker-compose up -d
for container in /$1/containers/*; do
  if [ -d $container ]; then

    # creates an .env file to use in docker-compose.yml
    if [ -f $container/gen-env.sh ]; then
      chmod +x $container/gen-env.sh
      $container/gen-env.sh > $container/.env
    fi

    docker-compose -f $container/docker-compose.yml up -d --no-recreate
  fi
done
