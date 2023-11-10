cat >~/.netrc <<EOL
machine github.com
login $github_username
password $github_token

machine api.github.com
login $github_username
password $github_token
EOL

git config --global user.email "$git_email"
git config --global user.name "$git_name"
