# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
dnf update -y && dnf install podman buildah npm just cockpit cockpit-podman dnf-automatic podman-compose -y 
systemctl enable --now cockpit.socket
systemctl enable --now podman.socket
systemctl enable --now dnf-automatic
systemctl enable --now dnf-automatic-install.timer

printf "[Timer]\nOnBootSec=\nOnCalendar=mon 06:00\n" | tee /etc/systemd/system/dnf-automatic-install.timer.d/time.conf
npm i -g yarn

modprobe ip_tables
echo 'ip_tables' | tee -a /etc/modules

chcon -Rt svirt_sandbox_file_t /vagrant/PRIORI_SERVICES_DB
SCRIPT

Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com.
  config.vm.define "PRIORI" do |p|
    p.vm.box = "fedora/37-cloud-base"
    p.vm.provider :libvirt
    p.vm.disk :disk, size: "20GB", primary: true
  end
  config.vm.provision "shell", inline: $script
  config.vm.provider "libvirt" do |lb|
    lb.memory = "2048"
    lb.driver = "kvm"
    lb.cpus = 2
  end
  config.vm.provider "virtualbox" do |v|
    v.name = "PRIORI_SERVICES_META"
    v.check_guest_additions = false
    v.memory = 1024
    v.cpus = 2
  end
  config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: 4, nfs_udp: false
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
