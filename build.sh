SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ORDERED_DIRS='ubuntu mybuntu devbuntu'
for d in $ORDERED_DIRS; do
    IMAGE=$docker_username/$(basename $d)
    SOURCE_CODE=$SCRIPT_DIR/$(basename $d)

    # if $SCRIPT_DIR/$d/configure-build.sh exists, run it
    if [ -f $SCRIPT_DIR/$d/configure-build.sh ]; then
        sh $SCRIPT_DIR/$d/configure-build.sh
    fi

    $SCRIPT_DIR/build-base.sh $IMAGE $SOURCE_CODE
done
