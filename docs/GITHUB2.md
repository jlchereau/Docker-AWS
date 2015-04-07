# Download and install a GIT repository from a Dockerfile

In the following instructions, we simply bypass docker hub to load our dockerimage with our code from github.

## Using GIT

Some people seem to [deploy git to clone github projects in docker images](http://stackoverflow.com/questions/23391839/clone-private-git-repo-with-dockerfile).
We do not want to deploy git on production environments. 

## Using WGET and UNZIP

Instead, the following Dockerfile uses WGET and UNZIP to download and install a release from Github.

```
FROM dockerfile/nodejs

# install OS prerequisites
RUN apt-get update && apt-get install wget unzip -y

#Set version
ENV VERSION 0.1.0

# download Docker-AWS
RUN wget https://github.com/jlchereau/Docker-AWS/archive/v$VERSION.zip

# unzip Docker-AWS into /app
RUN unzip v$VERSION.zip -d /app

# set working directory
WORKDIR /app/Docker-AWS-$VERSION

# install node dependencies
RUN npm install

# Define default command.
CMD ["npm", "start"]

# Expose ports.
EXPOSE 8080
```

This file can be uploaded into AWS Elastic Beanstalk in place of Dockerrun.aws.json to deploy version 0.1.0.