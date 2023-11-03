SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ORDERED_DIRS=(ubuntu mybuntu devbuntu prodbundu)
for d in $ORDERED_DIRS; do
    IMAGE=$(secret docker_username)/$(basename $d)
    SOURCE_CODE=$SCRIPT_DIR/$(basename $d)
    $SCRIPT_DIR/build-base.sh $IMAGE $SOURCE_CODE
done
