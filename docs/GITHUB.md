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

## Versioning

We will now replace Dockerfile with the following using https://github.com/dockerfile/nodejs-runtime as reproduced here below.

```
FROM dockerfile/nodejs-runtime
```

*Note: This second Dockerfile can be found at https://github.com/jlchereau/Docker-AWS/blob/master/steps/2%20EB%20Single%20Instance%20from%20NodeJS/Dockerfile.*

To create version 0.1.0, let's commit, tag with ```v0.1.0``` then push to Github:
 
```
git commit -m "Updated Dockerfile"
git tag -a v0.1.0 -m 'Version 0.1.0'
git push --tags
```

Now, let's modify index.js as follows to create a new feature:

```js
var express = require('express');

// Constants
var PORT = 8080;

// App
var app = express();
app.get('/', function (req, res) {
    res.send('Hello world with a great new feature\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
```

To create version 0.2.0, let's commit, tag with ```v0.2.0``` then push to Github:
 
```
git commit -m "Updated index.js"
git tag -a v0.2.0 -m 'Version 0.2.0'
git push --tags
```

You should see releases v0.1.0 and v0.2.0 in Github.

![Version 0.1.0 and Version 0.2.0 in Github](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github6.png)

Let's configure these releases in Docker hub to build an image per release. On the build details tab of the <username>/docker-aws repository, click edit build details and add two tags as follows:

![Version 0.1.0 and Version 0.2.0 in Docker hub](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github7.png)

This is further explained in a [support case](https://support.docker.com/hc/en-us/requests/3591).

The docker image for v0.1.0 can be loaded in the following dockerrun.aws.json:

```json
{
  "AWSEBDockerrunVersion": 1,
  "Image": {
    "Name": "jlchereau/docker-aws:v0.1.0"
  },
  "Ports" : [
    {
      "ContainerPort": "8080"
    }
  ]
}
```

This file is located at https://github.com/jlchereau/Docker-AWS/blob/master/steps/3%20GITHUB%20Version%200.1.0/Dockerrun.aws.json

A similar Dockerrun.aws.json for v0.2.0 is located at https://github.com/jlchereau/Docker-AWS/blob/master/steps/4%20GITHUB%20Version%200.2.0/Dockerrun.aws.json

Upload either Dockerrun.aws.json in AWS Elastic Beanstalk console depending on the version you want to deploy and test that you either get "Hello World" or "Hello World with a great new feature" in your browser.

![Load Dockerrun.aws.json in AWS EB](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/github8.png)
