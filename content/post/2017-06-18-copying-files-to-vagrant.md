+++
css = []
date = "2017-06-18T10:13:05-05:00"
author = "Felipe Juarez"
description = ""
highlight = true
scripts = []
title = "Copying files to vagrant"

comments = "true"
tags = ["operations","vagrant", "virtual box", "developer tools"]
categories=["operations","vagrant", "virtual box", "developer tools"]

+++

Well, one of the common things to do in Vagrant is copying files. So for achieve that task we need to prepare a file like [this]({{<ref "post/2017-06-01-creating-virtual-machines-with-vagrant.md">}}).

Once we have that file, we change `config.vm.box = "ubuntu/trusty64"` for `config.vm.box = "centos/7"`. And modify it like follow:

{{< highlight shell >}}
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provision "file", source: "lorem_ipsum.txt", destination: "~/lorem_ipsum.txt"
end
{{< /highlight >}}

Alright we run the command for execute our file.

{{< highlight shell >}}
❯ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'centos/7'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'centos/7' is up to date...
==> default: A newer version of the box 'centos/7' is available! You currently
==> default: have version '1611.01'. The latest is version '1705.01'. Run
==> default: `vagrant box update` to update.
==> default: Setting the name of the VM: vagrant-blog_default_1497801835273_73320
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: No guest additions were detected on the base box for this VM! Guest
    default: additions are required for forwarded ports, shared folders, host only
    default: networking, and more. If SSH fails on this machine, please install
    default: the guest additions and repackage the box to continue.
    default:
    default: This is not an error message; everything may continue to work properly,
    default: in which case you may ignore this message.
==> default: Rsyncing folder: /Users/sohjiro/workspace/vagrant-blog/ => /vagrant
==> default: Running provisioner: file...
{{< /highlight >}}

After that is finished, we connect to the machine with `ssh` command and list the filesystem

{{< highlight shell >}}
❯ vagrant ssh
[vagrant@localhost ~]$ ls -lt
total 4
-rw-r--r--. 1 vagrant vagrant 16 Jun 19 03:02 lorem_ipsum.txt
[vagrant@localhost ~]$
{{< /highlight >}}

And that's all, We just copy a file into our `Vagrant` machine
