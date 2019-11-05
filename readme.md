# Quick Fedora Workstation setup

Just a small repo to allow me to quickly setup new workstations for myself. 
Created with the concept that it can be used at home or work and will keep my favourite configuration up to date whenever I need to setup a new machine.
Also modable to allow others to quickly fork it and use it for themselves without much issues if they want to.

## What it does

  * Installs my favourite productivity packages
  * Installs dev version of ansible
  * Removes ansible pkg
  * Sets up my bash profile for local and remote work

## Prerequisites

A recent fedora distro

## Use

The below three commands will perform most system setup

```
sudo dnf -y install ansible
wget https://raw.githubusercontent.com/db0/workstation_setup/master/workstation_setup.yml
ansible-playbook workstation_setup.yml -K
```

## Customize

Put your own custom files to source that you don't want to share with others into ~/.privIncludes and give them a .bash extention
Put files to source that you're OK with sharing with others into your ~/.bashIncludes and don't forget to commit and push ;)

Customize your bashrc as needed.
