FROM opensuse:tumbleweed

ENV REMOTE_BRANCH master
ENV GITHUB_REPO ceph/ceph
ENV MGR_MODULE dashboard
ENV PATH="/home/user/bin/:${PATH}"
ENV CEPH_DEV=true
ENV CEPH_BUILD_DIR=/ceph/build
ENV RGW=1
ENV CEPH_PORT=8080
ENV NVM_DIR /home/user/.nvm
ENV NODE_VERSION 8

ARG USER_UID=1000

# Update os
RUN zypper ref
RUN zypper -n dup

# Install required tools
RUN zypper -n install \
    aaa_base babeltrace-devel bash ccache curl gcc gcc7 gcc7-c++ git \
    glibc-locale google-opensans-fonts iproute2 jq libstdc++6-devel-gcc7 \
    lttng-ust-devel man neovim net-tools-deprecated psmisc python \
    python-Cython python-PrettyTable python-devel python2-CherryPy \
    python2-Cython python2-Jinja2 python2-PrettyTable python2-PyJWT \
    python2-Routes python2-Werkzeug python2-bcrypt python2-pecan \
    python2-pip python2-pyOpenSSL python2-pylint python2-yapf \
    python3-CherryPy python3-Cython python3-Jinja2 python3-PrettyTable \
    python3-PyJWT python3-Routes python3-Werkzeug python3-bcrypt \
    python3-devel python3-pecan python3-pip python3-pyOpenSSL \
    python3-pylint python3-rados python3-requests python3-yapf susepaste \
    the_silver_searcher tmux vim wget zsh
RUN zypper -n install \
	python2-virtualenv python3-virtualenv

# SSO dependencies
RUN zypper -n install \ 
    libxmlsec1-1 libxmlsec1-nss1 libxmlsec1-openssl1 xmlsec1-devel \
    xmlsec1-openssl-devel
# RUN pip2 install python-saml
# RUN pip3 install python3-saml

RUN useradd -r -m -u ${USER_UID} user

# Install tools
RUN zypper -n install vim zsh inotify-tools wget ack sudo && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    groupadd wheel && \
    gpasswd -a user wheel

# Install debugging tools
RUN pip2 install --upgrade pip
RUN pip2 install rpdb remote_pdb ipdb ipython

RUN pip3 install --upgrade pip
RUN pip3 install rpdb remote_pdb ipdb ipython

# Install dependencies for `api-requests.sh`
RUN pip3 install requests docopt ansicolors
# other dependencies
RUN sudo pip3 install prettytable

# `restful` module
RUN pip2 install pecan werkzeug && \
    zypper -n in python2-pyOpenSSL python3-pyOpenSSL

# Ceph dependencies
WORKDIR /tmp
RUN wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/ceph.spec.in && \
    wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/install-deps.sh && \
    chmod +x install-deps.sh && \
    bash install-deps.sh && \
    zypper -n in ccache aaa_base

RUN chsh -s /usr/bin/zsh root

# Frontend dependencies
RUN zypper -n in npm8 fontconfig

# Temporary (?) dependecy for RGW-proxy
RUN pip2 install requests-aws

# Adds PyCharm debugging eggs
RUN mkdir /tmp/debug-eggs
ADD debug-eggs/ /tmp/debug-eggs

# User configuration

USER user

# Install plugin manager for neovim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN sudo mkdir -p ~/.config/nvim/plugged
RUN sudo chown -R user ~/.config/nvim/plugged

RUN git config --global core.editor nvim

ADD aliases /home/user/.aliases
ADD bashrc /home/user/.bashrc
ADD funcs /home/user/.funcs
ADD pdbrc /home/user/.pdbrc
ADD tmux.conf /home/user/.tmux.conf
# Set a nice cache size to increase the cache hit ratio alongside optimization configurations
RUN mkdir /home/user/.ccache
ADD ccache.conf /home/user/.ccache/

RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
	&& source $NVM_DIR/nvm.sh \
	&& nvm install $NODE_VERSION \
	&& nvm alias default $NODE_VERSION \
	&& nvm use default \
	&& npm install -g "@angular/cli"

RUN git clone https://github.com/robbyrussell/oh-my-zsh /home/user/.oh-my-zsh
ADD zshrc /home/user/.zshrc
ADD vimrc /home/user/.vimrc
ADD init.vim /home/user/.config/nvim/init.vim

WORKDIR /ceph

# Doing this step last results in efficient usage of Dockers cache and incredibly fast rebuilds if only those scripts have been changed
USER root
ADD bin/* /usr/local/bin/
USER user
