FROM auguryan/mybuntu:latest as base

# Install ruby with jemalloc
FROM ghcr.io/moritzheiber/ruby-jemalloc:3.2.2-slim as ruby

FROM base
COPY --link --from=ruby /opt/ruby /opt/ruby
ENV PATH="/opt/ruby/bin:${PATH}"

RUN apt update && apt install -y \
    gh \
    # needed to build ruby
    libjemalloc-dev \
    libjemalloc2 \
    # needed to build many ruby gems
    build-essential \
    # needed to build ruby pg (postgres) gem
    libpq-dev \
    # needed to build ruby psych gem
    libyaml-dev \
    # needed to build ruby idn-ruby gem
    libidn-dev \
    # needed to build ruby nokogiri gem
    libssl-dev \
    # needed to build ruby charlock_holmes gem
    libicu-dev \
    # needed to build ruby charlock_holmes gem
    zlib1g-dev

COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx

RUN mkdir /devbuntu
RUN ln -s /mybuntu/logs /devbuntu/logs
ENV LOG_DIR /devbuntu/logs

ENV BUNDLE_PATH=/devbuntu/bundle
RUN mkdir -p $BUNDLE_PATH

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
RUN npm install -g yarn

COPY bin/ /devbuntu/bin/
RUN chmod +x /devbuntu/bin/*.sh
RUN for f in /devbuntu/bin/*.sh; do ln -s $f /devbuntu/bin/$(basename $f .sh); done
ENV PATH="/devbuntu/bin:${PATH}"

COPY containers/ /devbuntu/containers/

RUN echo "if [ "\$PWD" = "\$HOME" ]; then cd /code; fi" >> ~/.bashrc

# run the init script
CMD ["bash", "-c", "mybuntu && devbuntu && /bin/bash"]
