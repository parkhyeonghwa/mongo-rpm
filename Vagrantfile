# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "centos63"
  config.vm.box_url = "/Users/dbarlow/src/el-cid/out/centos63.box"
  config.ssh.private_key_path="#{ENV['HOME']}/.ssh/vagrant_ssh_key"

  # Forward ports from the guest to the host
  # We can't bind ports < 1024 on the host unless we are running VirtualBox
  # as root, which we'd rather not.  But you could do e.g.
  #  $ sudo socat tcp-listen:80,fork tcp:localhost:8008
  #  $ sudo socat tcp-listen:443,fork tcp:localhost:8443
  # to use a browser on the host with standard port numbers
#  config.vm.forward_port 8080, 8080
#  config.vm.forward_port 80, 8008
#  config.vm.forward_port 443,8443

  config.vm.share_folder "home", "/mnt/home", ENV['HOME']

end
