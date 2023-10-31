FROM auguryan/mybuntu:latest
RUN apt update

RUN mkdir /devbuntu
COPY init.sh /devbuntu/.init.sh
RUN chmod +x /devbuntu/.init.sh
RUN echo "source /devbuntu/.init.sh" >> ~/.bashrc

COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx
