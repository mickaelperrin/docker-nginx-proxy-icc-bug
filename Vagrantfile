# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

required_plugins = %w(
	vagrant-hostmanager
)

required_plugins.each do |plugin|
	unless Vagrant.has_plugin?(plugin)
		raise '[ERROR] Missing plugin: ' + plugin
	end
end

$provision_script = <<SCRIPT
echo Installing Docker..
apt-get update
apt-get install -y --no-install-recommends apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo ""
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get purge lxc-docker
apt-get install -y --no-install-recommends linux-image-extra-$(uname -r) apparmor
apt-get install -y --no-install-recommends  docker-engine
docker run hello-world
docker --version
echo ""
echo "Installing docker-compose..."
apt-get install -y --no-install-recommends curl
curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
echo ""
echo "Updating Docker configuration setting --icc=false"
echo "DOCKER_OPTS=\"--icc=false\"" > /etc/default/docker
service docker restart
echo ""
echo "Starting nginx-proxy..."
docker-compose -p proxy -f /home/vagrant/test/docker-compose.proxy.yml up -d
echo "Starting web app..."
docker-compose -f /home/vagrant/test/docker-compose.yml up -d
echo ""
echo "Now launch vagrant hostmanager"
echo "Now try to reach http://www.test.docker/test.txt"
echo ""
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.box = "ubuntu/trusty64"
	config.vm.network "private_network", type: "dhcp"
	config.vm.hostname = 'test.docker'
	config.hostmanager.aliases = %w(www.test.docker)

	config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false

    config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

 	config.vm.provider "virtualbox" do |vb|
 		vb.gui = false
 		vb.name = "test.docker"
 		vb.cpus = 1
 		vb.memory = 512
 	end

 	config.vm.synced_folder "./", "/home/vagrant/test"

	config.vm.provision :shell, :inline => $provision_script
end
