FROM ubuntu:20.04
MAINTAINER Damoa https://github.com/damoa

RUN useradd -ms /bin/bash damoa

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y openssh-server

# Install OpenSSH Server, Git, curl
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    autoconf \
    bison \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    libpq-dev

RUN apt-get update && apt-get install -y \
    postgresql \
    postgresql-contrib

RUN service postgresql start

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN rbenv install 2.7.6
RUN rbenv install 3.1.2

# Install nvm and node 14.19.3 + 18.3.0
# Install base dependencies
RUN apt-get update && apt-get install -y -q \
    apt-transport-https \
    ca-certificates \
    wget \
    aspell \
    aspell-en \
    aspell-de \
    libaspell-dev \
    libxslt-dev \
    libxml2-dev \
    libgmp-dev \
    software-properties-common

# RUN apt-get update && apt-get install -y -q \
#     mysql-server \
#     libmysqlclient-dev \

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 18.3.0

RUN mkdir -p "$NVM_DIR"; \
    curl -o- \
        "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" | \
        bash \
    ; \
    source $NVM_DIR/nvm.sh; \
    nvm install $NODE_VERSION; \
    nvm install 14.19.3 \
    # Install yarn
    npm install -g yarn


# Sphinx (Serverversion 2.2.11)
RUN apt-get update && apt-get install -y sphinxsearch

# Install vim
RUN add-apt-repository -y ppa:jonathonf/vim && apt-get update && apt-get install -y vim

ENV RAILS_ENV development
ENV NODE_ENV development

RUN apt-get update && DEBIAN_FRONTEND='noninteractive' apt-get install -y dconf-cli gnome-terminal
RUN eval `dircolors ${CODE_DIR_IMAGE}/gnome-terminal-colors-solarized/dircolors`

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | \
    bash
RUN apt-get update && apt-get install -y nodejs
RUN apt-get update && apt-get install -y tmux

RUN curl https://getcroc.schollz.com | \
    bash

WORKDIR ${CODE_DIR_IMAGE}
USER damoa
ENV TERM xterm-256color
