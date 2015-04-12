# Using nginx as a reverse proxy to nodeJS

Proxying requests via nginx is well described at:
- https://www.digitalocean.com/community/tutorials/understanding-nginx-http-proxying-load-balancing-buffering-and-caching.
- https://www.digitalocean.com/community/tutorials/docker-explained-how-to-containerize-and-use-nginx-as-a-proxy

Although it is PHP, there is a good tutorial for what we want to achieve at http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_ecstutorial.html.

## Linking nginx with nodeJS applications

In a new directory, let's ceate ```Dockerrun.aws.json```:
 
```json
{
  "AWSEBDockerrunVersion": 2,
  "volumes": [
    {
      "name": "nginx-proxy-conf",
      "host": {
        "sourcePath": "/var/app/current/proxy/conf.d"
      }
    }
  ],
  "containerDefinitions": [
    {
      "name": "webapp",
      "image": "jlchereau/docker-aws",
      "essential": true,
      "memory": 128
    },
    {
      "name": "nginx-proxy",
      "image": "nginx",
      "essential": true,
      "memory": 128,
      "portMappings": [
        {
          "hostPort": 80,
          "containerPort": 80
        }
      ],
      "links": [
        "webapp"
      ],
      "mountPoints": [
        {
          "sourceVolume": "nginx-proxy-conf",
          "containerPath": "/etc/nginx/conf.d",
          "readOnly": true
        }
      ]
    }
  ]
}
```

and in a subdirectory, let's create ```proxy/conf.d/default.conf```:

```
# our nodejs app
upstream webapps {
    server webapp:8080;
}

# the nginx server instance
server {
    listen 80;

    # pass the request to the node.js server with the correct headers
    # and much more can be added, see nginx config options
    location / {
      proxy_pass http://webapps/;
      proxy_redirect     off;
      proxy_set_header   Host $host;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Host $server_name;
    }
}
```

Let's zip ```Dockerrun.aws.json``` and ```proxy/conf.d/default.conf``` together and let's create a new application in AWS Elastic Beanstalk for this zip.

Docker-AWS is now proxied through nginx. The configuration with one app server is available at https://github.com/jlchereau/Docker-AWS/tree/master/steps/7%20NGINX%20-%20one%20app%20server.

See also http://stackoverflow.com/questions/5009324/node-js-nginx-and-now and http://nginx.org/en/docs/http/ngx_http_core_module.html#location.

## Load balancing containers with nginx

For two app servers, these files need to be modified as follows:

```json
{
  "AWSEBDockerrunVersion": 2,
  "volumes": [
    {
      "name": "nginx-proxy-conf",
      "host": {
        "sourcePath": "/var/app/current/proxy/conf.d"
      }
    }
  ],
  "containerDefinitions": [
    {
      "name": "webapp1",
      "image": "jlchereau/docker-aws",
      "essential": true,
      "memory": 128
    },
    {
      "name": "webapp2",
      "image": "jlchereau/docker-aws",
      "essential": true,
      "memory": 128
    },
    {
      "name": "nginx-proxy",
      "image": "nginx",
      "essential": true,
      "memory": 128,
      "portMappings": [
        {
          "hostPort": 80,
          "containerPort": 80
        }
      ],
      "links": [
        "webapp1",
        "webapp2"
      ],
      "mountPoints": [
        {
          "sourceVolume": "nginx-proxy-conf",
          "containerPath": "/etc/nginx/conf.d",
          "readOnly": true
        }
      ]
    }
  ]
}
```

```
# our nodejs app
upstream webapps {
    server webapp1:8080;
    server webapp2:8080;
}

# the nginx server instance
server {
    listen 80;

    # pass the request to the node.js server with the correct headers
    # and much more can be added, see nginx config options
    location / {
      proxy_pass http://webapps;
      proxy_redirect     off;
      proxy_set_header   Host $host;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Host $server_name;
    }
}
```

Let's zip ```Dockerrun.aws.json``` and ```proxy/conf.d/default.conf``` together and let's create a new application in AWS Elastic Beanstalk for this zip.

Docker-AWS is now proxied through nginx. and two app servers are load balanced on the same EC2 instance. The configuration with two app servers is available at https://github.com/jlchereau/Docker-AWS/tree/master/steps/8%20NGINX%20-%20two%20app%20servers.

See http://stackoverflow.com/questions/28315706/how-to-load-balance-containers.

## Adding GZIP compression

GZip compression is documented at:
- http://nginx.com/resources/admin-guide/compression-and-decompression/
- http://nginx.org/en/docs/http/ngx_http_gzip_module.html.

In order to add GZIP compression to nginx, we only need to modify proxy/conf.d/default.conf as follows:

```
# our nodejs app
upstream webapps {
    server webapp1:8080;
    server webapp2:8080;
}

# the nginx server instance
server {
    listen 80;

    # gzip
    gzip on;
    gzip_proxied any;
    gzip_vary on;

    # pass the request to the node.js server with the correct headers
    # and much more can be added, see nginx config options
    location / {
      proxy_pass http://webapps;
      proxy_redirect     off;
      proxy_set_header   Host $host;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Host $server_name;
    }
}
```

Let's zip ```Dockerrun.aws.json``` and ```proxy/conf.d/default.conf``` together and let's create a new application in AWS Elastic Beanstalk for this zip.

Docker-AWS is now proxied through nginx with GZip compression. The configuration with Gzip compression is available at https://github.com/jlchereau/Docker-AWS/tree/master/steps/9%20NGINX%20GZIP%20Compression.

GZIP compression can be checked at http://www.giftofspeed.com/gzip-test/.

![GZip compression](https://raw.githubusercontent.com/jlchereau/Docker-AWS/master/graphics/nginx1.png)

## Adding volumes and Logs

- https://www.digitalocean.com/community/tutorials/how-to-centralize-your-docker-logs-with-fluentd-and-elasticsearch-on-ubuntu-14-04





## Adding Caching Control

https://www.digitalocean.com/community/tutorials/understanding-nginx-http-proxying-load-balancing-buffering-and-caching

## Adding SSL

- http://www.sitepoint.com/configuring-nginx-ssl-node-js/
- http://serverfault.com/questions/67316/in-nginx-how-can-i-rewrite-all-http-requests-to-https-while-maintaining-sub-dom


## Optimizations

See https://calomel.org/nginx.html
