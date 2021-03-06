# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM ubuntu:latest
MAINTAINER Shaozhen Ding <dsz0111@gmail.com>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs
RUN curl -O https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz && tar -xvf Python-2.7.6.tar.xz
RUN cd Python-2.7.6 && ./configure --prefix=/usr/local && make && make install

# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
# VOLUME /workspace

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 8080

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["node", "/cloud9/server.js", "--listen", "0.0.0.0", "--port", "8080", "-w", "/workspace"]
