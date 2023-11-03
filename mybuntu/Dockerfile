FROM auguryan/ubuntu:latest

RUN apt update && apt install -y docker docker-compose vim curl jq dirmngr

# Hashicorp Vault
RUN apt update && apt install -y --no-install-recommends gpg curl lsb-release ca-certificates openssl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update && apt install vlt -y --no-install-recommends

RUN mkdir /mybuntu
COPY init.sh /mybuntu/.init.sh
RUN chmod +x /mybuntu/.init.sh
RUN echo "/mybuntu/.init.sh" >> ~/.bashrc
