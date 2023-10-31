BUILD_DIRS=(ubuntu mybuntu devbuntu)
for BUILD_DIR in ${BUILD_DIRS[@]}; do
    /docker-dev/devbuntu/$BUILD_DIR/build.sh
done
