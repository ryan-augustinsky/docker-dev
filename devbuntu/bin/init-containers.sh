# iterate through every dir in /devbuntu/container
# in each dir, run the gen-env.sh script if it exists
# then run docker-compose up -d
for container in /devbuntu/containers/*; do
  if [ -d $container ]; then

    # creates an .env file to use in docker-compose.yml
    if [ -f $container/gen-env.sh ]; then
      $container/gen-env.sh > $container/.env
    fi

    docker-compose -f $container/docker-compose.yml down
    docker-compose -f $container/docker-compose.yml up -d
  fi
done
