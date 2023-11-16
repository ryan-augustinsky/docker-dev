ORIGIN_DIR=$(pwd)
trap "cd $ORIGIN_DIR" EXIT

echo $github_token | gh auth login --with-token

mkdir -p /mnt/code/github
# clone every repo from github to /mnt/code/github if it doesn't exist, using gh repo list
for repo in $(gh repo list --no-archived --json nameWithOwner --limit 1000 | jq -r '.[].nameWithOwner'); do
  if ! [ -d /mnt/code/github/$repo ]; then
    gh repo clone $repo /mnt/code/github/$repo
  else
    cd /mnt/code/github/$repo
    echo "Syncing $repo"
    gh repo sync
  fi
done
