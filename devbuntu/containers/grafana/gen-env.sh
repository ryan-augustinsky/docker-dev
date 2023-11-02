TUNNEL_TOKEN=$(secret cloudflare_grafana_token)
cat << EOF > .env
TUNNEL_TOKEN=${TUNNEL_TOKEN}
EOF
