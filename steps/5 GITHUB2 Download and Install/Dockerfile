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