SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BUILD_DIRS=(ubuntu mybuntu devbuntu)
for BUILD_DIR in ${BUILD_DIRS[@]}; do
    $SCRIPT_DIR/$BUILD_DIR/build.sh
done
