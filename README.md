# Emulate HPC VM cluster for testing
One deployment model for Laserchicken and the lcMacroPipe is
on a self-managed cluster of (virtual) machines. Spinning up
such a system for development purposes may not always because
of allocation usage (likely finite) or accessibility.
In order to independently test some functionalities it would
thus be desirable to emulate the architecture of the cluster.

This repo provides a docker image for this purpose.

## Provisioning

The container uses an `Ubunbtu 16.04` base image and runs
an sshd instance. This instance is set up to use key based
authentication
A `root` user and an `ubuntu` user with limited privileges
are set up. Public keys for both users are added on build.

Python3.5.2 and Python3-pip are installed and can be accessed
as `python3` and `pip3`, respectively.

A full installation of `Dask` including `distributed`
and `dask-jobqueue` is included

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
- The container should now be running on `localhost`. Identify the
  port (`<port>`) the containers port 22 (standard ssh) has been mapped to.
  This can done using either `docker ps -a` or `docker inspect <ContainerName>`
- This step can be repeated to emulate cluster of multiple independent VMs.

## Accessing the container(s)
- Running containers can now be accessed by ssh:
  `ssh <user>@localhost -p <port> -i <path_to_private_key>`
- This works both for the `root` and `ubuntu` users.
