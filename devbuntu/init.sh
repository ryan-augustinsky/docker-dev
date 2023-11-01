# symlink all .sh files in /devbuntu/bin to no extension in /devbuntu/bin
for f in /devbuntu/bin/*.sh; do ln -s $f /devbuntu/bin/$(basename $f .sh); done

init-github

secret docker_access_token | docker login --username=$(secret docker_username) --password-stdin

if ! [ "$(docker plugin inspect hetzner -f '{{.Enabled}}')" ]; then
  docker plugin install --grant-all-permissions --alias hetzner costela/docker-volume-hetzner
  docker plugin set hetzner apikey=$(secret hetzner_token)
  docker plugin enable hetzner
fi

cat >~/.netrc <<EOL
machine github.com
login $(secret github_username)
password $(secret github_token)

machine api.github.com
login $(secret github_username)
password $(secret github_token)
EOL

git config --global user.email "$(secret git_email)"
git config --global user.name "$(secret git_name)"

cd /code
