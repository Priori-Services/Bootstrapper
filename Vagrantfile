# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
dnf update -y && dnf install podman buildah cockpit cockpit-podman docker-compose -y 
systemctl enable --now cockpit.socket
sudo -u vagrant systemctl enable --now --user podman.socket

modprobe ip_tables
echo 'ip_tables' | tee -a /etc/modules
SCRIPT

Vagrant.configure("2") do |config|
    # https://docs.vagrantup.com.
    config.vm.define "PRIORI" do |p|
      p.vm.box = "rockylinux/9"
      p.vm.provider :libvirt
    end
    config.vm.disk :disk, size: "20GB", primary: true
    config.vm.provision "shell", inline: $script
    config.vm.provider "libvirt" do |lb|
      lb.memory = "2048"
      lb.driver = "kvm"
      lb.cpus = 2
    end
    config.vm.provider "virtualbox" do |v|
      v.name = "PRIORI_SERVICES_META"
      v.check_guest_additions = false
      v.memory = 2048
      v.cpus = 2
    end
    config.vm.network "forwarded_port", guest: 1433, host: 1433 # Database
    config.vm.network "forwarded_port", guest: 4173, host: 4173 # Web (prod)
    config.vm.network "forwarded_port", guest: 5173, host: 5173 # Web (dev)
    config.vm.network "forwarded_port", guest: 5000, host: 5000 # API (dev)
    config.vm.network "forwarded_port", guest: 8080, host: 8080 # Cockpit
    config.vm.network "forwarded_port", guest: 9090, host: 9090 # Cockpit
    
    # Maybe these could be useful at some point?
    # config.vm.network "private_network", ip: '192.168.40.10'
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
    # config.vm.network "private_network", ip: "192.168.33.10"
    # config.vm.network "public_network"
    # config.vm.synced_folder "../data", "/vagrant_data"
end
