# symlink all .sh files in /devbuntu/bin to no extension in /devbuntu/bin
for f in /devbuntu/bin/*.sh; do ln -s $f /devbuntu/bin/$(basename $f .sh); done

secret github_token | gh auth login --with-token
mkdir -p /code/github
# clone every repo from github to /code/github if it doesn't exist, using gh repo list
for repo in $(gh repo list --json nameWithOwner --limit 1000 | jq -r '.[].nameWithOwner'); do
  if ! [ -d /code/github/$repo ]; then
    gh repo clone $repo /code/github/$repo
  fi
done

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

ln -s -f /code/docker-dev/build.sh /devbuntu/bin/build

cd /code
