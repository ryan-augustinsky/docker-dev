FROM auguryan/ubuntu:latest

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN mkdir /mybuntu
RUN mkdir /mybuntu/logs
ENV LOG_DIR /mybuntu/logs

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt update && apt install -y libssl-dev pkg-config docker docker-compose vim curl jq dirmngr lsof cargo
ENV PATH="/root/.cargo/bin:${PATH}"
# update crates
RUN cargo install cargo-update

# Hashicorp Vault
RUN apt update && apt install -y --no-install-recommends gpg curl lsb-release ca-certificates openssl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update && apt install vlt -y --no-install-recommends

COPY bin/ /mybuntu/bin/
RUN chmod +x /mybuntu/bin/*.sh
RUN for f in /mybuntu/bin/*.sh; do ln -s $f /mybuntu/bin/$(basename $f .sh); done
ENV PATH="/mybuntu/bin:${PATH}"

COPY startup/ /mybuntu/startup/

RUN mkdir -p /mybuntu/apps
ENV APP_DIR /mybuntu/apps

# run the init script
CMD ["bash", "-c", "mybuntu && /bin/bash"]
