# Continuous deployment integrating GitHub

>Following the [first tutorial](https://github.com/jlchereau/Docker-AWS/blob/master/README.md) about dockerizing a nodeJS + expressJS application, we are exploring here below how to integrate Github.

## Setup an automated build

The main steps to setup and automated build are described at https://docs.docker.com/userguide/dockerrepos/

1. Create a [Docker Hub account](https://hub.docker.com/) and login.
2. Link your GitHub or BitBucket account through the ["Link Accounts"](https://registry.hub.docker.com/account/accounts/) menu.
3. [Configure an Automated Build](https://registry.hub.docker.com/builds/add/).

![Select an Automated Build from a Github repository](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github1.png)

4. Pick a GitHub or BitBucket project that has a Dockerfile that you want to build.

![Pick a GitHub project](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github2.png)

5. Pick the branch you want to build (the default is the master branch).
6. Give the Automated Build a name.
7. Assign an optional Docker tag to the Build.
8. Specify where the Dockerfile is located. The default is /.

![Configure miscellaneous parameters](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github3.png)

![Configure miscellaneous parameters](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github4.png)

Follow the progress of your build:

![Follow build progress](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github5.png)

## Install an automated build

Once your build has completed, you should be able to find it from your boot2docker console:

```shell
$ docker search <username>/docker-aws
```

You can install the image and check:

```shell
$ docker pull <username>/docker-aws
$ docker images
```

You can run the image in a container and check:

```shell
$ docker run -p 49160:8080 -d <username>/docker-aws
$ docker ps
```

You can finally run a browser in windows to connect to port 49160 at your VM's IP location which you can get by running ```boot2docker ip``` in a windows console or ```$ ifconfig``` in the boot2docker console:

![Hellow World](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/readme2.png)

## Updates

We will now replace Dockerfile with the following using https://github.com/dockerfile/nodejs-runtime as reproduced here below.

```
FROM dockerfile/nodejs-runtime
```

*Note: This second Dockerfile can be found at https://github.com/jlchereau/Docker-AWS/blob/master/Dockerfile.*






## Setup triggers

TODO

https://registry.hub.docker.com/u/jlchereau/docker-aws/settings/triggers/