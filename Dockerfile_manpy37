FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

ADD ./ssh/root/id_rsa.pub /root/.ssh/authorized_keys

RUN groupadd --gid 1000 ubuntuuser \
    && useradd --uid 1000 --gid ubuntuuser --shell /bin/bash --create-home ubuntu

ADD ./ssh/mock_ubuntu/mock_ubuntu_rsa.pub /home/ubuntu/.ssh/authorized_keys

RUN apt-get update ; \
    apt-get install -y build-essential \
    checkinstall \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    zlib1g-dev \
    openssl \
    libffi-dev \
    lzma \
    liblzma-dev \
    python3-dev \
    python3-setuptools \
    wget \
    curl \
    mc \
    ssh \
    htop \
    locales \
    apt-utils \
    debconf-utils \
    iputils-ping ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    mkdir /tmp/Python37 ; \
    cd /tmp/Python37 ; \
    wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz ; \
    tar xvf Python-3.7.0.tar.xz ; \
    cd /tmp/Python37/Python-3.7.0 ; \
    ./configure ; \
    make altinstall ; \
    locale-gen en_US.UTF-8; update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8; \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
    chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys; \
    chmod 700 /home/ubuntu/.ssh; chmod 600 /home/ubuntu/.ssh/authorized_keys; \
    chown ubuntu:ubuntuuser /home/ubuntu/.ssh; chown ubuntu:ubuntuuser /home/ubuntu/.ssh/authorized_keys; \
    sed -i 's/^exit 0/service ssh start\nexit 0/' /etc/rc.local


RUN pip3.7 install --upgrade pip ; \
    pip3.7 install "dask[complete]" ; \
    pip3.7 install distributed ; \
    pip3.7 install dask-jobqueue --upgrade ; \
    pip3.7 install asyncssh ; \
    pip3.7 install jupyterlab ; \
    pip3.7 install jupyter-server-proxy

EXPOSE 22
EXPOSE 8787
EXPOSE 8888
#map 8888 manually if desired


CMD /etc/rc.local; bash
