# Docker-AWS

> A prototype using Github and Docker for continuous deployment of a nodeJS + ExpressJS Hello World application on AWS

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

## Installation of Docker

### Windows

Follow instructions at https://docs.docker.com/installation/windows/

If you experience:

```
error in run: Failed to initialize machine "boot2docker-vm": exit status 1
```

Fix as follows (See https://github.com/boot2docker/boot2docker/issues/436):

1. Make sure HyperV is not enabled on Windows
2. Remove boot2docker-vm from "C:\Users\<username>\VirtualBox VMs"
3. Open a command prompt un run bootdocker init

There is a nice tutorial how to run docker on Windows at http://blog.tutum.co/2014/11/05/how-to-use-docker-on-windows/

To share a windows folder, first run in boot2docker:

```shell
$ wget http://distro.ibiblio.org/tinycorelinux/5.x/x86/tcz/cifs-utils.tcz
$ tce-load -i cifs-utils.tcz
``

Then run:

```shell
$ sudo mkdir /shared/src
$ sudo mount -t cifs //10.0.0.119/Users/Jacques-Louis/Desktop/Docker /shared/src -o username=jlchereau@msn.com
```


### Miscellaneous

IP Address et Virtual Box DHCP at https://docs.docker.com/installation/windows/

To remove untagged images (<none> tag) from Docker host, see http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html