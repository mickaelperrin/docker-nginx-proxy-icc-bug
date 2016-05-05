# Unable to get nginx-proxy working with icc=false

> This repo provides a generic sample configuration to be used as a test example of the issue [#210](https://github.com/jwilder/nginx-proxy/issues/210) of the nginx-proxy project.

## Result > FAIL

- The result is an **Error 502 Bag Gateway**
- Looking at the `default.conf`file, the server IP is not populated in the upstream directive. This seems to be related to [#304](https://github.com/jwilder/nginx-proxy/issues/304) 

```
# If we receive X-Forwarded-Proto, pass it through; otherwise, pass along the
# scheme used to connect to this server
map $http_x_forwarded_proto $proxy_x_forwarded_proto {
  default $http_x_forwarded_proto;
  ''      $scheme;
}
# If we receive Upgrade, set Connection to "upgrade"; otherwise, delete any
# Connection header that may have been passed to this server
map $http_upgrade $proxy_connection {
  default upgrade;
  '' close;
}
gzip_types text/plain text/css application/javascript application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
log_format vhost '$host $remote_addr - $remote_user [$time_local] '
                 '"$request" $status $body_bytes_sent '
                 '"$http_referer" "$http_user_agent"';
access_log off;
# HTTP 1.1 support
proxy_http_version 1.1;
proxy_buffering off;
proxy_set_header Host $http_host;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $proxy_connection;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $proxy_x_forwarded_proto;
server {
	server_name _; # This is just an invalid value which will never trigger on a real hostname.
	listen 80;
	access_log /var/log/nginx/access.log vhost;
	return 503;
}
upstream www.test.docker {
			# test_webapp_1
			server :80;
}
server {
	server_name www.test.docker;
	listen 80 ;
	access_log /var/log/nginx/access.log vhost;
	location / {
		proxy_pass http://www.test.docker;
	}
}
```



## How to replicate

### With Vagrant

1. clone this repo
2. install vagrant plugin: `vagrant plugin install vagrant-hostsupdater`
3. start the virtual machine with `vagrant up `
4. update your `/etc/hosts` file by running `vagrant hostmanager`
5. try to download the file at the address: http://www.test.docker/test.txt

### Manually

1. clone this repo
2. set an entry in your `/etc/hosts` file `IP.OF.YOUR.SERVER test.docker`
3. start docker on your server with the option `--icc=false`
4. run `/bin/bash start.sh`
5. try to download the file at the address: `http://www.test.docker/test.txt`

