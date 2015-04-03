# Deploy a dockerized application on AWS

## Introduction

There are 3 types of AWS Deployments
- Load-balanced, auto-scaled
- Single instance
- Queue-driven worker

There are 3 ways to deploy:
- upload a Dockerfile and each instance builds the image
- Manifest that describes how to run a container (Dockerrun.aws.json)
- Zip with app context

## Upload Dockerrun.aws.json to Amazon AWS (Single Instance)

Assuming you have followed the steps of [dsaada](./GITHUB.md)



```json
{
  "AWSEBDockerrunVersion": 1,
  "Image": {
    "Name": "<username>/docker-aws"
  },
  "Ports" : [
    {
      "ContainerPort": "8080"
    }
  ]
}
```

https://www.youtube.com/watch?v=QvXMCjTKNbc


## Using EB CLI

### Installing EB CLI

Follow instructions at http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-getting-set-up.html#eb_cli3-install-with-pip

Make sure Python and PIP are installed, otherwise download version 2.7.9 or above from python.org.

Especially on windows, make sure ```<pythonDir>``` and ```<pythonDir>\Scripts``` are in the PATH environment variable. If ```<pythonDir>``` contains spaces, ```pip install awsebcli```.
Instead run ```python -m pip install awsebcli``` from an administrator console.

Test your installation by running ```eb --help```.

## Sources

Docs:
- http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_ecstutorial.html


- http://www.incrediblemolk.com/running-a-docker-container-on-aws-elastic-beanstalk/
- http://victorlin.me/posts/2014/11/26/running-docker-with-aws-elastic-beanstalk


Webinars:
- https://www.youtube.com/watch?v=OzLXj2W2Rss
- https://www.youtube.com/watch?v=q4MVVL6rmd4
- https://www.youtube.com/watch?v=pLw6MLqwmew
- https://www.youtube.com/watch?v=lBu7Ov3Rt-M