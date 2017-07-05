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

Once we have finished editing that file, we run `vagrant up` command. We can test our configuration two different ways. The first one is using `ping` command:

{{< highlight shell >}}
❯ ping -c 6 192.168.15.200
PING 192.168.15.200 (192.168.15.200): 56 data bytes
64 bytes from 192.168.15.200: icmp_seq=0 ttl=64 time=0.265 ms
64 bytes from 192.168.15.200: icmp_seq=1 ttl=64 time=0.361 ms
64 bytes from 192.168.15.200: icmp_seq=2 ttl=64 time=0.474 ms
64 bytes from 192.168.15.200: icmp_seq=3 ttl=64 time=0.555 ms
64 bytes from 192.168.15.200: icmp_seq=4 ttl=64 time=0.380 ms
64 bytes from 192.168.15.200: icmp_seq=5 ttl=64 time=0.334 ms

--- 192.168.15.200 ping statistics ---
6 packets transmitted, 6 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.265/0.395/0.555/0.095 ms
{{< /highlight >}}


And the second one is using `vagrant ssh` and checking the interface:

{{< highlight shell >}}
❯ vagrant ssh
Last login: Wed Jul  5 04:07:21 2017 from 10.0.2.2
[vagrant@localhost ~]$ ip addr show eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:e5:b5:69 brd ff:ff:ff:ff:ff:ff
    inet 192.168.15.12/24 brd 192.168.15.255 scope global dynamic eth1
       valid_lft 86031sec preferred_lft 86031sec
    inet 192.168.15.200/32 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a9a0:340d:44ab:6ed1/64 scope link
       valid_lft forever preferred_lft forever
{{< /highlight >}}

With that in place, we are going to add our `public key` (if you don't know how create one you can check [this github post](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)). So, we edit our `Vagrant` file again, as follows:

{{< highlight shell >}}
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", auto_config: false
  config.vm.provision "shell", run: "always", inline: "ip addr add 192.168.15.200 dev eth1"

  config.ssh.insert_key = false # 1
  config.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa'] # 2
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys" # 3

  # 4
  config.vm.provision "shell", inline: <<-EOC
    sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
    sudo systemctl restart sshd.service
    echo "finished"
  EOC
end
{{< /highlight >}}

In line marked with `1` we tell to `Vagrant` that use Vagrant's default insecure key inside the machine. In the next line (`2`) we specify the paths to the private keys to use to SSH into the guest machine. In step number `3` we copy our `id_rsa.pub` into the `Vagrant` machine and rename as `authorized_keys`. And finally, in step `4` we change the configuration of `sshd`, for not asking a password and restart our service.

Finally we can access to our `Vagrant` machine with pure `ssh vagrant@192.168.15.200`.

{{< highlight shell >}}
❯ ssh vagrant@192.168.15.200
The authenticity of host '192.168.15.200 (192.168.15.200)' can't be established.
ECDSA key fingerprint is SHA256:d5Ak9sY7Gg1biVuQJ1Gdp6Axan3uq5+EkwMaoGSNQZw.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.15.200' (ECDSA) to the list of known hosts.
Last login: Wed Jul  5 04:37:17 2017 from 10.0.2.2
[vagrant@localhost ~]$
{{< /highlight >}}

And that's all, with this you can access to the machine without password. And in the next post we are going to talk about `distillery`.
