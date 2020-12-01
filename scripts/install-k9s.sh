#!/bin/bash

#Install pre-requisites
sudo apt install git make gcc -y

#Export PATH and Persist configuration
export PATH=$PATH:/usr/local/go/bin
/bin/bash -c 'source ~/.bashrc'

#Build K9 from source you must Clone the repo first before proceeding.
git clone https://github.com/derailed/k9s.git
folder=k9s
cmd="cd"
$cmd $folder

#Build and run the executable
make build && ./execs/k9s

#Set K9S command
alias k9s=~/k9s/./execs/k9s
export alias k9s=~/k9s/./execs/k9s
/bin/bash -c 'source ~/.bashrc'