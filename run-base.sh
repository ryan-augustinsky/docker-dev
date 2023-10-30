
# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p "$SCRIPT_DIR/.secrets"
SECRET_DIRS=(
    "$SCRIPT_DIR/.secrets/docker"
    "$SCRIPT_DIR/.secrets/git"
    "$SCRIPT_DIR/.secrets/github"
    "$SCRIPT_DIR/.secrets/ovpn"
    "$SCRIPT_DIR/.secrets/hetzner"
)
DOCKER_SECRETS=(
    "access-token.txt"
    "username.txt"
)
GIT_SECRETS=(
    "email.txt"
    "name.txt"
)
GITHUB_SECRETS=(
    "username.txt"
    "token.txt"
)
OVPN_SECRETS=(
    "config.ovpn"
)
HETZNER_SECRETS=(
    "token.txt"
)

EXIT=false

for i in "${SECRET_DIRS[@]}"; do
    mkdir -p "$i"
done

for i in "${DOCKER_SECRETS[@]}"; do
    touch "$SCRIPT_DIR/.secrets/docker/$i"
done

for i in "${GIT_SECRETS[@]}"; do
    touch "$SCRIPT_DIR/.secrets/git/$i"
done

for i in "${GITHUB_SECRETS[@]}"; do
    touch "$SCRIPT_DIR/.secrets/github/$i"
done

for i in "${OVPN_SECRETS[@]}"; do
    touch "$SCRIPT_DIR/.secrets/ovpn/$i"
done

for i in "${OVPN_SECRETS[@]}"; do
    touch "$SCRIPT_DIR/.secrets/hetzner/$i"
done

for i in "${DOCKER_SECRETS[@]}"; do
    [ -s "$SCRIPT_DIR/.secrets/docker/$i" ] || { echo >&2 "$SCRIPT_DIR/.secrets/docker/$i is empty"; EXIT=true; }
done

for i in "${GIT_SECRETS[@]}"; do
    [ -s "$SCRIPT_DIR/.secrets/git/$i" ] || { echo >&2 "$SCRIPT_DIR/.secrets/git/$i is empty"; EXIT=true; }
done

for i in "${GITHUB_SECRETS[@]}"; do
    [ -s "$SCRIPT_DIR/.secrets/github/$i" ] || { echo >&2 "$SCRIPT_DIR/.secrets/github/$i is empty"; EXIT=true; }
done

for i in "${OVPN_SECRETS[@]}"; do
    [ -s "$SCRIPT_DIR/.secrets/ovpn/$i" ] || { echo >&2 "$SCRIPT_DIR/.secrets/ovpn/$i is empty"; EXIT=true; }
done

for i in "${HETZNER_SECRETS[@]}"; do
    [ -s "$SCRIPT_DIR/.secrets/hetzner/$i" ] || { echo >&2 "$SCRIPT_DIR/.secrets/hetzner/$i is empty"; EXIT=true; }
done

if [ "$EXIT" = true ]; then
    exit 1
fi

echo "All secrets are present and not empty."

# docker run --privileged --rm -it --entrypoint bash $1
docker-compose run $1 bash
# echo "$(gh auth token)" >> ./.secrets/github/token.txt
