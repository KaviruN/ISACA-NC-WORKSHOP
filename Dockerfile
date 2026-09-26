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

# Vulnerable php
COPY index.php /var/www/html/index.php

#Copy the robots txt

COPY robots.txt /var/www/html/robots.txt

# Remove the default index.html

RUN rm -rf /var/www/html/index.html

RUN mkdir /var/run/sshd

# --- Flag 1: reachable as soon as they get the www-data shell ---

RUN echo "ISACA{USER_LFAG}" > /var/www/user.txt && chmod 644 /var/www/user.txt

# --- Prepare root's SSH dir so www-data can append to it, but not touch anything else ---
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh && touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

# --- The ONE narrow sudo permission: append-only to authorized_keys, nothing else ---
RUN echo "www-data ALL=(root) NOPASSWD: /usr/bin/tee -a /root/.ssh/authorized_keys" >> /etc/sudoers

# --- Flag 2: only reachable once they're actually root via SSH ---
RUN echo "ISACA{ROOT_FLAG}" > /root/root.txt && chmod 600 /root/root.txt 

EXPOSE 80 22

CMD service ssh start && apache2ctl -D FOREGROUND
