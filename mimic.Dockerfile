FROM opensuse/leap:15.0

RUN zypper --gpg-auto-import-keys ref
RUN zypper -n dup
RUN zypper -n install \
    aaa_base \
    babeltrace-devel \
    bash \
    bzip2 \
    ccache \
    git \
    google-opensans-fonts \
    iproute2 \
    jq \
    lttng-ust-devel \
    net-tools-deprecated \
    psmisc \
    python \
    python-devel \
    python2-CherryPy \
    python2-Cython \
    python2-PrettyTable \
    python2-Routes \
    python2-Werkzeug \
    python2-bcrypt \
    python2-pecan \
    python2-pip \
    python2-pyOpenSSL \
    python2-pylint \
    python2-requests \
    python3-CherryPy \
    python3-Cython \
    python3-PrettyTable \
    python3-Routes \
    python3-Werkzeug
    python3-bcrypt \
    python3-devel \
    python3-pecan \
    python3-pip \
    python3-pyOpenSSL \
    python3-pylint \
    python3-requests \
    tar \
    tmux \
    vim \
    wget \
    zsh

ENV CEPH_ROOT /ceph
CMD ["zsh"]

