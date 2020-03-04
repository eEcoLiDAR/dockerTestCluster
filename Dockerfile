FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

ADD ./ssh/root/id_rsa.pub /root/.ssh/authorized_keys

RUN groupadd --gid 1000 ubuntuuser \
    && useradd --uid 1000 --gid ubuntuuser --shell /bin/bash --create-home ubuntu

ADD ./ssh/mock_ubuntu/mock_ubuntu_rsa.pub /home/ubuntu/.ssh/authorized_keys


RUN apt-get update; \
    apt-get install -y locales apt-utils debconf-utils iputils-ping wget curl mc htop ssh; \
    apt-get install -y python3 python3-pip python3-dev ;\
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    locale-gen en_US.UTF-8; update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8; \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
    chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys; \
    chmod 700 /home/ubuntu/.ssh; chmod 600 /home/ubuntu/.ssh/authorized_keys; \
    chown ubuntu:ubuntuuser /home/ubuntu/.ssh; chown ubuntu:ubuntuuser /home/ubuntu/.ssh/authorized_keys; \
    sed -i 's/^exit 0/service ssh start\nexit 0/' /etc/rc.local

RUN pip3 install --upgrade pip ; \
    pip3 install "dask[complete]"


EXPOSE 22
CMD /etc/rc.local; bash
