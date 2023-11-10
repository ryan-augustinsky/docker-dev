# !/bin/bash

# get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# check that listef.py exists in the same directory as this script
if [ ! -f "$DIR/listef.py" ]; then
    echo "listef.py not found in $DIR"
    exit 1
fi

# pass all args and stdin to listef.py
python3 "$DIR/listef.py" list $1
