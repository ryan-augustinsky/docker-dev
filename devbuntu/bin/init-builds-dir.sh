mkdir -p /mnt/code/github

if ! [ -d /mnt/code/github/$BUILDS_REPO ]; then
  gh repo clone $BUILDS_REPO /mnt/code/github/$BUILDS_REPO
fi

#if /mnt/code/apps symlink exists, delete it
if [ -L /mnt/code/builds ]; then
  rm /mnt/code/builds
fi
ln -s /mnt/code/github/$BUILDS_REPO /mnt/code/builds

if [ -L $BUILDS_DIR ]; then
  rm $BUILDS_DIR
fi
ln -s /mnt/code/github/$BUILDS_REPO $BUILDS_DIR
