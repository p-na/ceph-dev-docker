FROM opensuse:tumbleweed

ENV remote_branch wip-mgr-dashboard_v2
ENV github_repo openattic/ceph
ENV mgr_module_name dashboard_v2

RUN zypper ref && \
    zypper -n dup && \
    zypper -n install \
        iproute2 net-tools-deprecated python2-pip python3-pip \
        python lttng-ust-devel babeltrace-devel \
        librados2 python-rados python2-pylint python3-pylint \
        vim zsh inotify-tools wget \
        python python2-pip python3-pip gcc git && \
    wget https://raw.githubusercontent.com/${github_repo}/${remote_branch}/ceph.spec.in && \
    wget https://raw.githubusercontent.com/${github_repo}/${remote_branch}/install-deps.sh && \
    chmod +x install-deps.sh && \
    bash install-deps.sh && \
    wget https://raw.githubusercontent.com/${github_repo}/${remote_branch}/src/pybind/mgr/${mgr_module_name}/requirements.txt && \
    pip2 install -r requirements.txt && \
    pip3 install -r requirements.txt && \
    chsh -s /usr/bin/zsh root && \
    zypper -n in ccache

ADD setup-ceph.sh /root/bin/setup-ceph
ADD bash.bashrc /etc/bash.bashrc
ADD aliases /root/.aliases
ADD bin/* /root/bin/
ADD zshrc /root/.zshrc

VOLUME ["/ceph"]

CMD /usr/bin/zsh
