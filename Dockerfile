FROM ubuntu:bionic

ENV REMOTE_BRANCH master
ENV GITHUB_REPO ceph/ceph
ENV MGR_MODULE dashboard

ARG user_uid=1000

# Set package mirror to one near our location
RUN sed -ri 's|(http://)(archive.ubuntu.com)(.*)$|\1de.archive.ubuntu.com\3|g' /etc/apt/sources.list

# Update os
RUN apt update
RUN apt dist-upgrade -y

# Install required tools
RUN apt install -y iproute2 python-pip python3-pip python librados2 python gcc git python-dev cython cython3 python-prettytable python3-prettytable psmisc python-cherrypy python-pecan python-jinja2 python-routes python3-routes

# Install tools
RUN useradd -r -m -u ${user_uid} user
RUN apt install -y vim zsh inotify-tools wget ack sudo && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    groupadd wheel && \
    gpasswd -a user wheel

# Debugging remotely
RUN pip2 install rpdb
RUN pip3 install rpdb

# `restful` module
RUN pip2 install pecan werkzeug && \
	apt install -y python-openssl python3-openssl

# Ceph dependencies
WORKDIR /tmp
RUN wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/ceph.spec.in && \
    wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/install-deps.sh && \
	mkdir debian && \
	wget -P debian https://raw.githubusercontent.com/ceph/ceph/master/debian/control && \
    bash install-deps.sh && \
    apt install -y ccache

RUN chsh -s /usr/bin/zsh root

RUN apt install -y python-bcrypt python3-bcrypt && \
	apt install -y python-bcrypt python3-bcrypt

# Frontend dependencies
RUN apt install -y npm fontconfig

# Temporary (?) dependecy for RGW-proxy
RUN pip2 install requests-aws


ADD aliases /home/user/.aliases
ADD bin/* /home/user/bin/
ADD zshrc /home/user/.zshrc
ADD bashrc /home/user/.bashrc
RUN chown -R user /home/user/

RUN mkdir /tmp/py2-eggs
ADD py2-eggs/* /tmp/py2-eggs/

USER user
VOLUME ["/ceph"]
WORKDIR /ceph/build
