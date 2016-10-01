#!/bin/sh
set -e
function error_exit {
    echo
    echo "$@"
    exit 1
}
shopt -s expand_aliases
alias die='error_exit "Error at ${0}:`echo $(( $LINENO - 1 ))`:"'

# figure out what el version we are
RELEASEVER=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release) | sed 's/\([0-9]*\).*/\1/')

rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
yum install -y https://yum.puppetlabs.com/puppetlabs-release-el-$RELEASEVER.noarch.rpm
yum -y install puppet git || die "Failed to install required packages"
rm -rf /etc/puppet
git clone -b refresh https://bitbucket.org/lewispeckover/puppet.git /etc/puppet
pushd /etc/puppet > /dev/null
puppet apply --modulepath ./modules manifests/bootstrap.pp
