+++
css = []
date = "2017-07-04T22:06:52-05:00"

author = "Felipe Juarez"
description = ""
highlight = true
scripts = []
title = "Add public key to Vagrant"

comments = "true"
tags = ["operations","vagrant", "virtual box", "developer tools", "public key"]
categories=["operations","vagrant", "virtual box", "developer tools", "public key"]
+++

After copying a [file]({{<ref "post/2017-06-18-copying-files-to-vagrant.md">}}) to `Vagrant` and creating a basic [file structure]({{<ref "post/2017-06-01-creating-virtual-machines-with-vagrant.md">}}). We can continue with our series.

So, in this post, we are going to talk about the following topics:

1. Assign an IP address
1. Add your public key
1. Access to vagrant machine without `vagrant ssh`


For the first point and taking the [file structure]({{<ref "post/2017-06-01-creating-virtual-machines-with-vagrant.md">}}) previously mentioned, we modify as follow:

{{< highlight shell >}}
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", auto_config: false
  config.vm.provision "shell", run: "always", inline: "ip addr add 192.168.15.200 dev eth1"
end
{{< /highlight >}}



