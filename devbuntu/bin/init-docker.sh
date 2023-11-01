secret docker_access_token | docker login --username=$(secret docker_username) --password-stdin

if ! [ "$(docker plugin inspect hetzner -f '{{.Enabled}}')" ]; then
  docker plugin install --grant-all-permissions --alias hetzner costela/docker-volume-hetzner
  docker plugin set hetzner apikey=$(secret hetzner_token)
  docker plugin enable hetzner
fi
