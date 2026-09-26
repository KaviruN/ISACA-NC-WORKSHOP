FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    apache2 \
    php \
    libapache2-mod-php \
    netcat-traditional \
    iputils-ping \
    openssh-server \
    sudo \
    && apt clean

# Vulnerable ping tool
COPY index.php /var/www/html/index.php

RUN mkdir /var/run/sshd

# --- Flag 1: reachable as soon as they get the www-data shell ---
# Placed outside the web root so it's not viewable via HTTP, only via actual shell access
RUN echo "ISACA{stage1_www_data_code_exec}" > /var/www/flag1.txt && chmod 644 /var/www/flag1.txt

# --- Prepare root's SSH dir so www-data can append to it, but not touch anything else ---
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh && touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

# --- The ONE narrow sudo permission: append-only to authorized_keys, nothing else ---
RUN echo "www-data ALL=(root) NOPASSWD: /usr/bin/tee -a /root/.ssh/authorized_keys" >> /etc/sudoers

# --- Flag 2: only reachable once they're actually root via SSH ---
RUN echo "ISACA{stage2_root_ssh_persistence}" > /root/flag2.txt && chmod 600 /root/flag2.txt

EXPOSE 80 22

CMD service ssh start && apache2ctl -D FOREGROUND
