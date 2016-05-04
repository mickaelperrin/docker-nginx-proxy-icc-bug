# Unable to get nginx-proxy working with icc=false

> This repo provides a generic sample configuration to be used as a test example of the issue [#210](https://github.com/jwilder/nginx-proxy/issues/210) of the nginx-proxy project.

## How to replicate

### With Vagrant

1. clone this repo
2. install vagrant plugin: `vagrant plugin install vagrant-hostsupdater`
3. start the virtual machine with `vagrant up `
4. try to download the file at the address: http://www.test.docker/test.txt

### Manually

1. clone this repo
2. set an entry in your `/etc/hosts` file `IP.OF.YOUR.SERVER test.docker`
3. start docker on your server with the option `--icc=false`
4. start the nginx-proxy service with `docker-compose -f docker-compose.proxy.yml up -d`
5. start the web app service with `docker-compose up`
6. try to download the file at the address: `http://www.test.docker/test.txt`

