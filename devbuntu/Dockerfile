FROM auguryan/mybuntu:latest

RUN apt update && apt install -y \
    gh

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

# Install ruby with rvm
ENV RVM_DIR /usr/local/rvm
ENV RVM_SCRIPT /etc/profile.d/rvm.sh
ENV RUBY_VERSION 3.2.2

# get the gpg keys listed at https://rvm.io/rvm/security
RUN gpg --keyserver keyserver.ubuntu.com \
        --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
        7D2BAF1CF37B13E2069D6956105BD0E739499BDB

RUN mkdir -p $RVM_DIR \
    && curl -sSL https://get.rvm.io | bash -s stable \
    && source $RVM_SCRIPT \
    && echo 'source $RVM_SCRIPT' >> ~/.bashrc \
    && rvm install $RUBY_VERSION \
    && rvm use $RUBY_VERSION --default

# Install Rails
ENV RAILS_VERSION 7.1.1
RUN source $RVM_SCRIPT \
    && gem install rails -v $RAILS_VERSION

RUN npm install -g serve

COPY init.sh /devbuntu/.init.sh
RUN chmod +x /devbuntu/.init.sh
RUN echo "source /devbuntu/.init.sh" >> ~/.bashrc

COPY bin/ /devbuntu/bin/
RUN echo "export PATH=$PATH:/devbuntu/bin" >> ~/.bashrc

COPY containers/ /devbuntu/containers/

COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx

EXPOSE 3006
