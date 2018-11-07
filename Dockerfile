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

# Faster mirror
RUN zypper rr OSS
RUN zypper rr NON\ OSS
RUN zypper ar ftp://mirror.23media.de/opensuse/tumbleweed/repo/non-oss/ NON\ OSS
RUN zypper ar ftp://mirror.23media.de/opensuse/tumbleweed/repo/oss/ OSS
RUN zypper ref

# Update os
RUN zypper ref
RUN zypper -n dup

# Install required tools
RUN zypper -n install \
        iproute2 net-tools-deprecated python2-pip python3-pip \
        python lttng-ust-devel babeltrace-devel \
        librados2 python2-pylint python3-pylint \
        python python2-pip python3-pip gcc git \
        python-devel python2-Cython python2-PrettyTable psmisc \
        python2-CherryPy python2-pecan python2-Jinja2 \
		the_silver_searcher curl tmux glibc-locale

# Install tools
RUN useradd -r -m -u ${USER_UID} user
RUN zypper -n install vim zsh inotify-tools wget ack sudo && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    groupadd wheel && \
    gpasswd -a user wheel

# Debugging
RUN pip2 install --upgrade pip
RUN pip2 install rpdb remote_pdb ipdb ipython

RUN pip3 install --upgrade pip
RUN pip3 install rpdb remote_pdb ipdb ipython

# api-requests.sh
RUN pip3 install requests docopt ansicolors

# `restful` module
RUN pip2 install pecan werkzeug && \
    zypper -n in python2-pyOpenSSL

# Ceph dependencies
WORKDIR /tmp
RUN wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/ceph.spec.in && \
    wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/install-deps.sh && \
    chmod +x install-deps.sh && \
    bash install-deps.sh && \
    zypper -n in ccache aaa_base

RUN chsh -s /usr/bin/zsh root

RUN zypper -n rm python2-bcrypt && \
    pip2 install bcrypt

# Frontend dependencies
RUN zypper -n in npm8 fontconfig

# Temporary (?) dependecy for RGW-proxy
RUN pip2 install requests-aws

ADD bin/* /usr/local/bin/

RUN mkdir /tmp/py2-eggs
ADD py2-eggs/* /tmp/py2-eggs/

USER user

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

WORKDIR /ceph/build

# temporary to be added at the end of the layers
RUN sudo pip3 install prettytable
