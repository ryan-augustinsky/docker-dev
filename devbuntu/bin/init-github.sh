secret github_token | gh auth login --with-token
mkdir -p /code/github
# clone every repo from github to /code/github if it doesn't exist, using gh repo list
for repo in $(gh repo list --no-archived --json nameWithOwner --limit 1000 | jq -r '.[].nameWithOwner'); do
  if ! [ -d /code/github/$repo ]; then
    gh repo clone $repo /code/github/$repo
  fi
done
