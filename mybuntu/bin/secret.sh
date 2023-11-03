# check if the secret has been cached already
if [ ! -f /mybuntu/secrets/$1 ]; then
  mkdir -p /mybuntu/secrets
  vlt secrets get --plaintext $1 > /mybuntu/secrets/$1
fi

# read the secret
cat /mybuntu/secrets/$1

