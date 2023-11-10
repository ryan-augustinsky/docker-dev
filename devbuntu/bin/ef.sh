# get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# check that listef.py exists in the same directory as this script
if [ ! -f "$DIR/listef.py" ]; then
    echo "listef.py not found in $DIR"
    exit 1
fi

short_code=$1
if [ -z "$short_code" ]; then
    echo "Usage: $0 <short_code>"
    exit 1
fi

# gets the url for the short code
python3 "$DIR/listef.py" ef $short_code
