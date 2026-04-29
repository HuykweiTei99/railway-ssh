FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install packages (bỏ systemctl)
RUN apt update && apt install -y \
    openssh-server \
    curl wget unzip sudo \
    python3 nano \
    htop btop neofetch \
    && mkdir /var/run/sshd

# Tạo user
RUN useradd -m trthaodev && echo "trthaodev:thaodev@" | chpasswd && adduser trthaodev sudo

# SSH config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'ClientAliveInterval 60' >> /etc/ssh/sshd_config && \
    echo 'ClientAliveCountMax 3' >> /etc/ssh/sshd_config

# Ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf ngrok-v3-stable-linux-amd64.tgz && mv ngrok /usr/local/bin/

# Copy script start
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 8080

CMD ["/start.sh"]