# symlink all .sh files in /devbuntu/bin to no extension in /devbuntu/bin
for f in /devbuntu/bin/*.sh; do ln -s $f /devbuntu/bin/$(basename $f .sh); done

cat /run/secrets/docker-access-token | docker login --username=$(cat /run/secrets/docker-username) --password-stdin
docker plugin install --grant-all-permissions --alias hetzner costela/docker-volume-hetzner
docker plugin set hetzner apikey=$(cat /run/secrets/hetzner-token)
docker plugin enable hetzner

cat >~/.netrc <<EOL
machine github.com
login $(cat /run/secrets/github-username)
password $(cat /run/secrets/github-token)

machine api.github.com
login $(cat /run/secrets/github-username)
password $(cat /run/secrets/github-token)
EOL

git config --global user.email "$(cat /run/secrets/git-email)"
git config --global user.name "$(cat /run/secrets/git-name)"

alias build='/code/docker-dev/devbuntu/build.sh'

cd /code
