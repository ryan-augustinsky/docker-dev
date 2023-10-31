FROM auguryan/mybuntu:latest
RUN apt update

RUN mkdir /prodbuntu
COPY init.sh /prodbuntu/.init.sh
RUN chmod +x /prodbuntu/.init.sh
RUN echo "source /prodbuntu/.init.sh" >> ~/.bashrc
