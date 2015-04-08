# Configuration with environment variables

Some values need to be kept secret. The best option is to configure environment variables during deploymen.

## AWS Elastic Beanstalk

The use of environment variables on AWS EB is described at http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_Java.managing.html.

In version 0.3.0 of our application, we have modified index.js to display NODE_ENV:

```js
var express = require('express');

// Constants
var PORT = 8080;

// App
var app = express();
app.get('/', function (req, res) {
    res.send('Hello world with a great new feature and NODE_ENV=' + process.env.NODE_ENV + '\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
```

Accordingly Dockerrun.aws.json now targets v0.3.0:

```json
{
  "AWSEBDockerrunVersion": 1,
  "Image": {
    "Name": "jlchereau/docker-aws:v0.3.0"
  },
  "Ports" : [
    {
      "ContainerPort": "8080"
    }
  ]
}
```

Since dockerfile/nodejs-runtime has been [deprecated overnight](https://blog.docker.com/2015/03/updates-available-to-popular-repos-update-your-images/), we need to replace Dockerfile :

```
# FROM dockerfile/nodejs-runtime
FROM node:onbuild
```

As explained for the [integration with Github via Docker hub](https://github.com/jlchereau/Docker-AWS/blob/master/docs/GITHUB.md), we have tagged this new version v0.3.0 in Git, pushed to Github and created the corresponding tag in Docker hub.

After setting up a Docker single instance in AWS, EB, click configuration.

![Configuration](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/env1.png)

Then click the gear close to software configuration and add your environment variables including NODE_ENV.

![Environment variables](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/env2.png)

Finally run the application in your web browser to confirm:

![Application in browser](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/env3.png)


## AWS Elastic Container Service