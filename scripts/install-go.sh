#!/bin/bash

#Install pre-requisites
sudo apt-get update -y && sudo apt-get -y upgrade
sudo apt install tar curl unzip vim nano wget jq awscli -y
unalias go

#Install Go 1.15.2
wget https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz
sudo tar -xvf go1.15.*.linux-amd64.tar.gz
sudo mv go /usr/local

#Setup Go Enviroment - GOROOT is the location where Go package is installed on your system.
export GOROOT=/usr/local/go

#GOPATH is the location of your work directory.
export GOPATH=$HOME/Projects/Proj1

#Now set the PATH variable to access go binary system wide.
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
alias go=/usr/local/go/bin/go
export alias go=/usr/local/go/bin/go
/bin/bash -c 'source ~/.bashrc'

#Verify Installation
go version
go env