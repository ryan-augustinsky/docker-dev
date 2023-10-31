IMAGE=auguryan/mybuntu
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$SCRIPT_DIR/../build-base.sh $IMAGE $SCRIPT_DIR
