FROM opensuse:tumbleweed

ENV REMOTE_BRANCH wip-mgr-dashboard_v2
ENV GITHUB_REPO openattic/ceph
ENV MGR_MODULE dashboard_v2

RUN zypper ref
RUN zypper -n dup
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

# Ceph dependencies and `dashboard_v2` module
WORKDIR /tmp
RUN wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/ceph.spec.in && \
    wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/install-deps.sh && \
    chmod +x install-deps.sh && \
    bash install-deps.sh && \
    wget https://raw.githubusercontent.com/${GITHUB_REPO}/${REMOTE_BRANCH}/src/pybind/mgr/${MGR_MODULE}/requirements.txt && \
    pip2 install -r requirements.txt && \
    pip3 install -r requirements.txt && \
    chsh -s /usr/bin/zsh root && \
    zypper -n in ccache aaa_base


# Frontend dependencies
RUN zypper -n in npm8 fontconfig

ADD bash.bashrc /etc/bash.bashrc
ADD aliases /root/.aliases
ADD bin/* /root/bin/
ADD zshrc /root/.zshrc

VOLUME ["/ceph"]

WORKDIR /ceph
CMD /usr/bin/zsh
