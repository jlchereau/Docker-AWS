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

This is well described at https://www.youtube.com/watch?v=OzLXj2W2Rss and http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_image.html.
We are not considering https://docs.docker.com/installation/amazon/.

## Prerequisite

The integration of ElasticBeanstalk and Docker uses the EC2 Container Service.
Accordingly you need to create the ```BeanstalkECSAccess``` policy and the ```aws-elasticbeanstalk-ec2-role``` role as described at http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_ecstutorial.html.

## Upload Dockerrun.aws.json to Amazon AWS (Single Instance)

Assuming you have followed the steps to [build an image from a Github project onto Docker Hub](./GITHUB.md), you only need to upload a very simple ```Dockerrun.aws.json``` to AWS in order to use that image in a single instance environment:

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

Then go to the Elastic Beanstalk service in the AWS Console:

1. Create a new application with a convenient name and description
2. Choose to **Create Web Server Environment**
3. Use the ```aws-elasticbeanstalk-ec2-role``` role created as explained in the prerequisites
4. Select the Docker configuration and the single instance environment

![Docker configuration](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/aws1.png)

5. Upload ```Dockerrun.aws.json```

![Upload file](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/aws2.png)

6. Accept default options until you get to click **Launch**
7. Wait until the dashboard displays your deployment as healthy

![Healthy deployment](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/aws3.png)

8. Run your app at ```http://<appname>.elasticbeanstalk.com```

![Upload file](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/aws4.png)

This is further described at https://www.youtube.com/watch?v=QvXMCjTKNbc.

## Upload a Dockerfile (Single Instance)





## Upload a Zip




## Using EB CLI

### Installing EB CLI

Follow instructions at http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-getting-set-up.html#eb_cli3-install-with-pip

Make sure Python and PIP are installed, otherwise download version 2.7.9 or above from python.org.

Especially on windows, make sure ```<pythonDir>``` and ```<pythonDir>\Scripts``` are in the PATH environment variable. If ```<pythonDir>``` contains spaces, ```pip install awsebcli```.
Instead run ```python -m pip install awsebcli``` from an administrator console.

Test your installation by running ```eb --version```. You should see something like ```EB CLI 3.2.1 (Python 2.7.9)```

## Other Sources

- http://www.incrediblemolk.com/running-a-docker-container-on-aws-elastic-beanstalk/
- http://victorlin.me/posts/2014/11/26/running-docker-with-aws-elastic-beanstalk


- https://www.youtube.com/watch?v=q4MVVL6rmd4
- https://www.youtube.com/watch?v=pLw6MLqwmew
- https://www.youtube.com/watch?v=lBu7Ov3Rt-M