#!/bin/sh
function error_exit {
    echo
    echo "$@"
    exit 1
}
shopt -s expand_aliases
alias die='error_exit "Error at ${0}:`echo $(( $LINENO - 1 ))`:"'
rpm -ihv https://bitbucket.org/lewispeckover/repo.lew.io/raw/master/el/6/noarch/lew-repo-1.0.0-1.noarch.rpm
yum -y install puppet git git-crypt || die "Failed to install required packages"
cd /etc/puppet || die "Can't get to puppet directory /etc/puppet"
git init
git remote add origin https://bitbucket.org/lewispeckover/puppet.git
git fetch origin master
git reset --hard origin/master
git submodule update --init
if [ ! -f ".git/git-crypt/keys/default" ]; then
	if [ ! -f "/root/secure.key" ]; then
		echo "#####################################"
		echo "   REMEMBER TO ADD THE SECURE KEY!"
		echo "#####################################"
	else
		git-crypt unlock /root/secure.key
	fi
fi
puppet apply --modulepath ./modules manifests/bootstrap.pp
