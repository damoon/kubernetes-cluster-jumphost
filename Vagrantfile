# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "private_network", type: "dhcp"
  config.vm.provision "shell", inline: "echo 'cd /vagrant/' >> /home/vagrant/.bashrc"
end
