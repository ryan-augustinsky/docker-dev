cat /run/secrets/docker-access-token | docker login --username=$(cat /run/secrets/docker-username) --password-stdin

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
