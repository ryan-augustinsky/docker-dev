FROM auguryan/mybuntu:latest
RUN apt update

RUN mkdir /devbuntu
COPY init.sh /devbuntu/.init.sh
RUN chmod +x /devbuntu/.init.sh
RUN echo "/devbuntu/.init.sh" >> ~/.bashrc
