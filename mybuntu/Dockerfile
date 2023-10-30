FROM auguryan/ubuntu:latest
RUN apt update
RUN apt install -y docker
RUN apt install -y docker-compose
RUN apt install -y vim
RUN apt install -y curl
RUN mkdir /mybuntu
COPY init.sh /mybuntu/.init.sh
RUN chmod +x /mybuntu/.init.sh
RUN echo "/mybuntu/.init.sh" >> ~/.bashrc
