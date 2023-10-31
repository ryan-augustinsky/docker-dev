FROM auguryan/ubuntu:latest
RUN apt update
RUN apt update && apt install -y docker docker-compose vim curl
RUN mkdir /mybuntu
COPY init.sh /mybuntu/.init.sh
RUN chmod +x /mybuntu/.init.sh
RUN echo "/mybuntu/.init.sh" >> ~/.bashrc
