FROM auguryan/mybuntu:latest as base

# Install ruby with jemalloc
FROM ghcr.io/moritzheiber/ruby-jemalloc:3.2.2-slim as ruby

FROM base
COPY --link --from=ruby /opt/ruby /opt/ruby
ENV PATH="/opt/ruby/bin:${PATH}"

RUN apt update && apt install -y \
    gh \
    libjemalloc-dev \
    libjemalloc2

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN mkdir /devbuntu

# Install nvm, node, and npm
# https://stackoverflow.com/questions/25899912/how-to-install-nvm-in-docker
ENV NVM_DIR /devbuntu/.nvm
ENV NODE_VERSION 20.9.0
RUN mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install -g serve

RUN echo "if [ "\$PWD" = "\$HOME" ]; then cd /code; fi" >> ~/.bashrc

COPY bin/ /devbuntu/bin/
RUN for f in /devbuntu/bin/*.sh; do ln -s $f /devbuntu/bin/$(basename $f .sh); done
RUN chmod +x /devbuntu/bin/*.sh
ENV PATH="/devbuntu/bin:${PATH}"

COPY containers/ /devbuntu/containers/

COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx

EXPOSE 3006

# run the init script
ENTRYPOINT ["init"]
