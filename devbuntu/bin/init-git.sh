cat >~/.netrc <<EOL
machine github.com
login $github_username
password $github_token

machine api.github.com
login $github_username
password $github_token
EOL

# https://stackoverflow.com/a/44247040
git config --global --add url."git@github.com:".insteadOf "https://github.com/"

git config --global user.email "$git_email"
git config --global user.name "$git_name"
