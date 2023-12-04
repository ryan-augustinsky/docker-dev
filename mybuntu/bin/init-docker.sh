rm -f ~/.docker/config.json
echo $docker_access_token | docker login --username=$docker_username --password-stdin

if ! [ "$(docker plugin inspect hetzner -f '{{.Enabled}}')" ]; then
  docker plugin install --grant-all-permissions --alias hetzner costela/docker-volume-hetzner
  docker plugin set hetzner apikey=$hetzner_token
  docker plugin enable hetzner
fi
