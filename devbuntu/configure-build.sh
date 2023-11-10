SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
COMPOSE_REPO=https://github.com/ryan-augustinsky/compose
STARTUP_DIR=$SCRIPT_DIR/startup
SRE_DIR=$STARTUP_DIR/sre
rm -r $STARTUP_DIR
mkdir -p $STARTUP_DIR
cd $STARTUP_DIR

# checkout $COMPOSE_REPO's ONLY /compose/sre/ directory, no other files into SRE_DIR
git init
git remote add origin $COMPOSE_REPO
git config core.sparseCheckout true

# checkout only sre/ and listef files in .git/info/sparse-checkout
echo "sre/" >> .git/info/sparse-checkout
echo "listef/" >> .git/info/sparse-checkout

git pull --depth=1 origin main
