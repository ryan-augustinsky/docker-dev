mkdir -p /mnt/code/github

if ! [ -d /mnt/code/github/$APP_REPO ]; then
  gh repo clone $APP_REPO /mnt/code/github/$APP_REPO
fi

#if /mnt/code/apps symlink exists, delete it
if [ -L /mnt/code/apps ]; then
  rm /mnt/code/apps
fi
ln -s /mnt/code/github/$APP_REPO /mnt/code/apps

if [ -L $APP_DIR ]; then
  rm $APP_DIR
fi
ln -s /mnt/code/github/$APP_REPO $APP_DIR
