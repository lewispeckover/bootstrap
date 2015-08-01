#!/bin/sh
function error_exit {
    echo
    echo "$@"
    exit 1
}
shopt -s expand_aliases
alias die='error_exit "Error at ${0}:`echo $(( $LINENO - 1 ))`:"'
rpm -ihv https://bitbucket.org/lewispeckover/repo.lew.io/raw/master/el/6/noarch/lew-repo-1.0.0-1.noarch.rpm
yum -y install puppet-release || die "Failed to install required packages"
yum -y install puppet || die "Failed to install required packages"
cd /etc/puppet || die "Can't get to puppet directory /etc/puppet"
git init
git remote add origin https://bitbucket.org/lewispeckover/puppet.git
git fetch origin minimal
git reset --hard origin/minimal
git submodule update --init
puppet apply --modulepath ./modules manifests/bootstrap.pp
