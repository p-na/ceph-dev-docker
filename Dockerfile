FROM opensuse:tumbleweed
MAINTAINER Patrick Nawracay "pnawracay@suse.com"

RUN zypper ref && \
    zypper -n dup && \
    zypper -n install \
        iproute2 net-tools-deprecated python2-pip python3-pip \
        python lttng-ust-devel babeltrace-devel \
        librados2 python-rados python2-pylint python3-pylint \
        bash vim tmux git zsh inotify-tools
RUN chsh -s /usr/bin/zsh root

ADD setup-ceph.sh /root/bin/setup-ceph
ADD bash.bashrc /etc/bash.bashrc
ADD shell_aliases /root/.shell_aliases
ADD bin/* /root/bin/

VOLUME ["/ceph"]
CMD /usr/bin/zsh
