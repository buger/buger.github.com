# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  
  config.vm.provision :shell, :inline => "
  if which vim >/dev/null; then
    echo 'second run'
  else
    apt-get install -y curl vim git build-essential
    curl -L https://get.rvm.io | bash -s stable -ruby=1.9.3 --autolibs=enabled
    source /home/vagrant/.rvm/scripts/rvm
  fi
  "
  config.vm.network :forwarded_port, guest: 8080, host: 8080
end
