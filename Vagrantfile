# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "private_network", ip: "172.28.128.4"
  config.ssh.pty = true
  config.vm.provision "shell", inline: "echo 'cd /vagrant/' >> /home/vagrant/.bashrc"
  config.vm.hostname = "jumphost.172.28.128.4.xip.io"
  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end
end
