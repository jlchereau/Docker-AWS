# Docker-AWS

> A prototype using Github and Docker for continuous deployment of a nodeJS + ExpressJS Hello World application on AWS.

## The application

The application is utterly basic:

```
var express = require('express');

// Constants
var PORT = 8080;

// App
var app = express();
app.get('/', function (req, res) {
    res.send('Hello world\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
```

It only requires nodeJS and expressJS.

![Hello World](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/helloworld.png)

## Installation of Docker

### on Windows

Follow instructions at https://docs.docker.com/installation/windows/

If you experience:

```
error in run: Failed to initialize machine "boot2docker-vm": exit status 1
```

Fix as follows (See https://github.com/boot2docker/boot2docker/issues/436):

1. Make sure HyperV is not enabled on Windows: HyperV and VirtualBox compete for VT-x.
2. Remove boot2docker-vm from "C:\Users\<username>\VirtualBox VMs".
3. Open a command prompt amd run ```bootdocker init``.

There is a nice tutorial how to run docker on Windows at http://blog.tutum.co/2014/11/05/how-to-use-docker-on-windows/.

To share a windows folder, first install CIFS in the boot2docker console:

```shell
$ wget http://distro.ibiblio.org/tinycorelinux/5.x/x86/tcz/cifs-utils.tcz
$ tce-load -i cifs-utils.tcz
```

Assuming the current project is located in a folder named ```Docker-AWS``` on the Windows Desktop, mount a shared folder in the boot2docker console:

```shell
$ sudo mkdir -p /mnt/shared
$ sudo mount -t cifs //<ip-address>/Users/<username>/Desktop/Docker-AWS /mnt/shared -o username=<login>
```

Enter your windows user password when requested. Then the following commands should display the list of project files including this README in the boot2docker console:

```shell
$ cd /mnt/shared
$ ls -la
```

To unmount the share:

```shell
$ sudo umount -l /mnt/shared
```

## Installing and running the application in Docker (aka Dockerizing)

The following is an excerpt from the tutorial at https://docs.docker.com/examples/nodejs_web_app/.

The first step to dockerize our application consists in adding a text file named Dockerfile to the root of our project.

```
FROM    centos:centos6

# Enable EPEL for Node.js
RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# Install Node.js and npm
RUN     yum install -y npm

# Bundle app source
COPY index.js /app/
COPY package.json /app/

# Install app dependencies
RUN cd /app; npm install

#Expose port 8080
EXPOSE  8080

#Run app
CMD ["node", "/app/index.js"]
```

The second step consists in building a container in the boot2docker console:

```shell
$ sudo docker build -t <username>/hello .
```

```$ docker images``` should display 2 new images named ```centos``` and ```<username>/hello```.

The third step consists in running the container

```
$ sudo docker run -p 49160:8080 -d <username>/hello
```

```$ docker ps``` should display your container running in the docker VM.

In order to test your app form a windows browser you need the IP address (the redirected port being 49160 as set above). To obtain it, you can either run ```boot2docker ip``` in the windows console if boot2docker is not running or run ```$ ifconfig``` in the boot2docker console.

![Hello World](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/helloworld2.png)

### Miscellaneous

Note the user of the docker VM is ```docker``` and the password is ```tcuser``` as seen at https://docs.docker.com/installation/windows/.

To remove untagged images (```<none>``` tag) from your Docker host, see http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html.

## TODO: adding nginx