FROM auguryan/mybuntu:latest
RUN apt update
RUN apt install openvpn -y

# Enable IPV6 for OpenVPN
# https://forum.hackthebox.com/t/openvpn-troubles/3478/5
RUN sysctl net.ipv6.conf.all.disable_ipv6=0

RUN mkdir /devbuntu
COPY init.sh /devbuntu/.init.sh
RUN chmod +x /devbuntu/.init.sh
RUN echo "/devbuntu/.init.sh" >> ~/.bashrc
