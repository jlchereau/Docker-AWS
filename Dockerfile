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