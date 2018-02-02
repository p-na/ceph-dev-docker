FROM opensuse:tumbleweed
MAINTAINER Patrick Nawracay "pnawracay@suse.com"

RUN zypper ref && \
    zypper -n dup && \
    zypper -n install \
        iproute2 net-tools-deprecated python2-pip python3-pip \
        python lttng-ust-devel babeltrace-devel \
        librados2 python-rados python2-pylint python3-pylint \
        bash vim tmux git zsh
RUN chsh -s /usr/bin/zsh root

ADD setup-ceph.sh /root/bin/setup-ceph
ADD bash.bashrc /etc/bash.bashrc

VOLUME ["/ceph"]
CMD /usr/bin/zsh
