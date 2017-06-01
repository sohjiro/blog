+++
date = "2017-06-01T15:28:00-05:00"
author: Felipe Juarez
title = "Creating virtual machines with Vagrant"
comments = "true"

tags = ["operations","vagrant", "virtual box", "developer tools"]
categories=["operations","vagrant", "virtual box", "developer tools"]
+++

It's been awhile since I wrote a post, but in compensation I would make a series of post talking about deploying applications with edeliver. But for this, we need to prepare the path. So, in this first post I will talk about Vagrant and how to use to setup an environment.

First of all, we're going to install _Vagrant_ and _Virtual Box_. We'll download _Vagrant_ from this [link](https://www.vagrantup.com/downloads.html) and follow the instructions(i.e. next, next, next, agree, install) When that is complete, we can verify the correct installation using the command `vagrant -v`

{{< highlight shell >}}
❯ vagrant -v
Vagrant 1.9.3
{{< /highlight >}}

We can download _Virtual Box_ from this [link](https://www.virtualbox.org). This step is required because _Vagrant_ use images for running in a virtual machine. You can configure _Vagrant_ to be use with other providers, but that is out of this scope.

After that is finished, we can start with our first command which is `vagrant init`. Once that you run the command you will see a message like this

{{< highlight shell >}}
❯ vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
{{< /highlight >}}

And a file called `Vagrant` is created with the following content (without comments)

{{< highlight shell >}}
Vagrant.configure("2") do |config|
  config.vm.box = "base"
end
{{< /highlight >}}

Change the `config.vm.box = "base"` for `config.vm.box = "ubuntu/trusty64"` and then run `vagrant up` you will see something like this:

{{< highlight shell >}}
❯ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'ubuntu/trusty64' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'ubuntu/trusty64'
    default: URL: https://atlas.hashicorp.com/ubuntu/trusty64
==> default: Adding box 'ubuntu/trusty64' (v20170526.4.0) for provider: virtualbox
    default: Downloading: https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20170526.4.0/providers/virtualbox.box
==> default: Successfully added box 'ubuntu/trusty64' (v20170526.4.0) for 'virtualbox'!
==> default: Importing base box 'ubuntu/trusty64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'ubuntu/trusty64' is up to date...
==> default: Setting the name of the VM: vagrant_default_1496339776983_29558
==> default: Clearing any previously set forwarded ports...
==> default: Fixed port collision for 22 => 2222. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2200 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Remote connection disconnect. Retrying...
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default:
    default: Guest Additions Version: 4.3.36
    default: VirtualBox Version: 5.1
==> default: Mounting shared folders...
    default: /vagrant => /Users/makingdevs/Documents/vagrant
{{< /highlight >}}

This shows you the basic setup for an ubuntu image. If you open your _Virtual Box_, you will see a new image created and ready to use. You can enter to that machine via SSH with `vagrant ssh`

{{< highlight shell >}}
❯ vagrant ssh
Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 3.13.0-119-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

 System information disabled due to load higher than 1.0

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

New release '16.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

vagrant@vagrant-ubuntu-trusty-64:~$
{{< /highlight >}}

In order to stop the machine you will use `vagrant halt`

{{< highlight shell >}}
❯ vagrant halt
==> default: Attempting graceful shutdown of VM...
{{< /highlight >}}

In case that you won't need it anymore you can destroy it with `vagrant destroy`

{{< highlight shell >}}
❯ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...
{{< /highlight >}}


As complementary note, if you want to know which images you have downloaded you can always use `vagrant box list` to show them.

{{< highlight shell >}}
❯ vagrant box list
centos/7        (virtualbox, 1702.01)
ubuntu/trusty64 (virtualbox, 20170526.4.0)
{{< /highlight >}}
