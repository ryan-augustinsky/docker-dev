# symlink all .sh files in /devbuntu/bin to no extension in /devbuntu/bin
for f in /devbuntu/bin/*.sh; do ln -s $f /devbuntu/bin/$(basename $f .sh); done

init-github
init-docker
init-git

cd /code
