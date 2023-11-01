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
