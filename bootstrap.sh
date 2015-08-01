#!/bin/sh
function error_exit {
    echo
    echo "$@"
    exit 1
}
shopt -s expand_aliases
alias die='error_exit "Error at ${0}:`echo $(( $LINENO - 1 ))`:"'
rpm --import https://bitbucket.org/lewispeckover/repo.lew.io/raw/master/RPM-GPG-KEY-LEW || die failed to fetch gpg key
rpm -ihv https://bitbucket.org/lewispeckover/repo.lew.io/raw/master/el/6/noarch/lew-repo-1.1.0-1.noarch.rpm
yum -y install puppetlabs-release || die "Failed to install required packages"
yum -y install puppet git || die "Failed to install required packages"
cd /etc/puppet || die "Can't get to puppet directory /etc/puppet"
git init
git remote add origin https://bitbucket.org/lewispeckover/puppet.git
git fetch origin minimal
git reset --hard origin/minimal
git submodule update --init
puppet apply --modulepath ./modules manifests/bootstrap.pp
