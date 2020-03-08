# Emulate HPC VM cluster for testing
One deployment model for Laserchicken and the lcMacroPipe is
on a self-managed cluster of (virtual) machines. Spinning up
such a system for development purposes may not always be
desirable because of allocation usage (likely finite) or
accessibility.
In order to independently test some functionalities it would
thus be desirable to emulate the architecture of the cluster.

This repo provides a docker image and instructions for this purpose.

## Provisioning

The container uses an `Ubunbtu 16.04` base image and runs
an sshd instance. This instance is set up to use key based
authentication
A `root` user and an `ubuntu` user with limited privileges
are set up. Public keys for both users are added on build.

Python3.7 and Python3-pip are installed and can be accessed
as `python3.7` and `pip3.7`, respectively. A system version
of `python3.5` is also available as `python3` but is not
fully compatible with `Dask`.

A full installation of `Dask` including `distributed`
and `dask-jobqueue` is included

`JupyterLab` and `jupyter-proxy-server` are also installed.

## Container creation

### Pre-setup
- clone the repository to your local system
- generate ssh keys for the `root` and `ubuntu` user using ssh-keygen
  e.g. `ssh-keygen -t rsa -b 4096`
- replace the keys in `./ssh/root/` and `./ssh/mock_ubuntu` with
  those you have generated.
- after completing these steps the container can be built.

### Docker flow
- build image from Dockerfile using
  `sudo docker build  . -f Dockerfile -t <ImageName>`
- create and start container using `docker run` as
  `sudo docker run --name <ContainerName> -it -d -P <ImageName>`
  The `-P` option publishes all exposed ports to randomly assigned ports on
  the host. This is desirable for the `22` default `ssh` port, but for other
  ports a user defined mapping may be preferable. This can be realized by adding
  `-p <localhostPortNumber>:<containerPortNumber>` for each port to be mapped
  (this does not require the port to be exposed).      
- The container should now be running on `localhost`. Identify the
  port (`<port>`) the containers port 22 (standard ssh) has been mapped to.
  This can done using either `docker ps -a` or `docker inspect <ContainerName>`
- The `docker inspect <ContainerName>` command can also be used to identify the
  container'a IP (`<containerIP>`) address on the local network.
  This is required in the following steps.
- These steps can be repeated to emulate a cluster of multiple independent VMs.


## Accessing the container(s)
All containers can, of course, be accessed using the normal docker
functionalities. However, for the purposes of emulating a cluster (e.g. a SURF
HPC cloud set of VMs), ssh access is crucial. This however differs depending on
the OS of the localhost, as a result of behaviour of Docker.

### Linux
On linux systems
- Running containers can now be accessed by ssh:
  `ssh -p <port> -i <path_to_private_key> <user>@localhost`
  or
  `ssh -i <path_to_private_key> ssh://<user>@0.0.0.0:<port>`
  or
  `ssh -i <path_to_private_key> <user>@<containerIP>`
  - This works both for the `root` and `ubuntu` users.

### Mac OS
On systems running Mac OS X the behaviour of Docker for Mac results in
container's only being reachable from the local host via ssh using either
`ssh -p <port> -i <path_to_private_key> <user>@localhost`
or
`ssh -i <path_to_private_key> ssh://<user>@0.0.0.0:<port>`
In contrast to linux systems a connection using the containers IP is not
supported.
This also affects file copying from the localhost to the container using
`scp`. For example
`scp -i <path_to_private_key> -P <port> <localfilepath> <user>@localhost:<containerfilepath>`
