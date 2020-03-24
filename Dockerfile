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
    wget \
    curl \
    git \
    mc \
    ssh \
    htop \
    locales \
    apt-utils \
    debconf-utils \
    iputils-ping ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    locale-gen en_US.UTF-8; update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8; \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
    chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys; \
    chmod 700 /home/ubuntu/.ssh; chmod 600 /home/ubuntu/.ssh/authorized_keys; \
    chown ubuntu:ubuntuuser /home/ubuntu/.ssh; chown ubuntu:ubuntuuser /home/ubuntu/.ssh/authorized_keys; \
    sed -i 's/^exit 0/service ssh start\nexit 0/' /etc/rc.local

USER ubuntu
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh ; \
    bash /tmp/miniconda.sh -b -p $HOME/miniconda ; \
    rm /tmp/miniconda.sh ; \
    export PATH="$HOME/miniconda/bin:$PATH" ; \
    conda init ; \
    conda config --env --set always_yes true ; \
    conda install pip pdal python-pdal gdal -c conda-forge ; \
    pip install "dask[complete]" ; \
    pip install distributed ; \
    pip install dask-jobqueue --upgrade ; \
    pip install asyncssh ; \
    pip install jupyterlab ; \
    pip install jupyter-server-proxy ; \
    pip install git+git://github.com/eEcoLiDAR/lcMacroPipeline@development#egg=lc_macro_pipeline

USER root
EXPOSE 22
EXPOSE 8787
EXPOSE 8888
#map 8888 manually if desired


CMD /etc/rc.local; bash
