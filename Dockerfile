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

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | \
    bash
RUN apt-get update && apt-get install -y nodejs
RUN apt-get update && apt-get install -y tmux

RUN curl https://getcroc.schollz.com | \
    bash

RUN echo "eval `dircolors /home/damoa/code/gnome-terminal-colors-solarized/dircolors`" >> /home/damoa/.bashrc
RUN echo "alias v='vi'" >> /home/damoa/.bashrc
RUN echo "alias vo='git diff --name-only | xargs -o vi'" >> /home/damoa/.bashrc
RUN echo "alias gp='git push'" >> /home/damoa/.bashrc
RUN echo "alias gcm='git pull --quiet && git branch --merged | grep -v master | xargs git branch -d 2> /dev/null'" >> /home/damoa/.bashrc
RUN echo "alias gpu='git rev-parse --abbrev-ref HEAD | xargs -I{} git push -u origin {} && sleep 3 && git config --local remote.origin.url| sed -n \"s#.*/\([^.]*\)\.git#\1#p\" | xargs -I % chromium https://github.com/sofatutor/%/pull/new/$(git rev-parse --abbrev-ref HEAD)'" >> /home/damoa/.bashrc

RUN apt-get update && apt-get install -y silversearcher-ag

RUN mkdir -p /home/damoa/.vim/pack/my_plugins/start
RUN git clone https://github.com/preservim/nerdtree.git /home/damoa/.vim/pack/my_plugins/start/nerdtree
RUN git clone https://github.com/cohama/agit.vim.git /home/damoa/.vim/pack/my_plugins/start/agit
RUN git clone https://github.com/rking/ag.vim.git /home/damoa/.vim/pack/my_plugins/start/ag
RUN echo "map ,a \|:Ag ''<Left>" >> /home/damoa/.vimrc
RUN apt-get update && apt-get install -y fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/damoa/.fzf && /home/damoa/.fzf/install
RUN git clone https://github.com/junegunn/fzf.vim.git /home/damoa/.vim/pack/my_plugins/start/fzf.vim
RUN echo "set rtp+=/home/damoa/.fzf" >> /home/damoa/.vimrc
RUN echo "map ,f :FZF<cr>" >> /home/damoa/.vimrc


WORKDIR /home/damoa/code
USER damoa
ENV TERM xterm-256color
