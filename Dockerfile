FROM opensuse:tumbleweed

ENV REMOTE_BRANCH wip-mgr-dashboard_v2
ENV GITHUB_REPO openattic/ceph
ENV MGR_MODULE dashboard_v2
ENV RGW 1
ENV DASHBOARD_PORT 9865

# Update os
RUN zypper ref
RUN zypper -n dup

# Install required tools
RUN zypper -n install \
        iproute2 net-tools-deprecated python2-pip python3-pip \
        python lttng-ust-devel babeltrace-devel \
        librados2 python2-pylint python3-pylint \
        vim zsh inotify-tools wget \
        python python2-pip python3-pip gcc git \
        python-devel python2-Cython python2-PrettyTable psmisc

# `restful` module
RUN pip2 install pecan werkzeug && \
    zypper -n in python2-pyOpenSSL

# Ceph dependencies
WORKDIR /tmp
RUN wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/ceph.spec.in && \
    wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/install-deps.sh && \
    chmod +x install-deps.sh && \
    bash install-deps.sh

# `dashboard_v2` module
RUN wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/src/pybind/mgr/${MGR_MODULE}/requirements.txt && \
    pip2 install -r requirements.txt && \
    pip3 install -r requirements.txt && \
    chsh -s /usr/bin/zsh root && \
    zypper -n in ccache aaa_base

RUN zypper -n rm python2-bcrypt && \
    pip2 install bcrypt

# Frontend dependencies
RUN zypper -n in npm8 fontconfig

ADD bash.bashrc /etc/bash.bashrc
ADD aliases /root/.aliases
ADD bin/* /root/bin/
ADD zshrc /root/.zshrc

RUN mkdir /tmp/py2-eggs
ADD py2-eggs/* /tmp/py2-eggs
RUN ["/bin/bash", "-c", "ls /tmp/py2-eggs/*"]
RUN ["/bin/bash", "-c", "easy_install-2.7 /tmp/py2-eggs/*"]

VOLUME ["/ceph"]

WORKDIR /ceph/build
