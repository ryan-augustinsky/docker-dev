# check if the secret has been cached already
if [ ! -f /devbuntu/secrets/$1 ]; then
  mkdir -p /devbuntu/secrets
  vlt secrets get --plaintext $1 > /devbuntu/secrets/$1
fi

# read the secret
cat /devbuntu/secrets/$1

