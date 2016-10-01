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

# install lew.io gpg key
cat > /etc/pki/rpm-gpg/RPM-GPG-KEY-LEW <<KEYCONTENT
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

mQENBFRIPIABCAC9HDfhvtKV/lqB36C5p6otGw6svU0qgc7t67i8ozBI7qRkmdO5
h9W+hUa6ptXAAMnnt+qOK8GA9dHjRxaEqFuRWbtbo5Y+dEX0RkZnGL70rG521mjU
tnUopFRINEycoe+Nd6yPghEXotaVsuJPafpkrBLrCHR79WobijODv6e1G/IjeOhC
N3JTbuIQsNa5DcVRK4Mdx0nPk2xZuf1oZwMv9/YTRqpzcbDAOuO+aHSG/v1rQaMj
tc85qcq3xuCEyMANXtOaYTaZtlUjWz6tsGJd3fRJRFkpp7PzNTWN/ifZ/MpXmAe9
OLNEZIJC9kia6IfHDa0/Po8UpgHWyPKWxEDjABEBAAG0GGxldy5pbyBSUE1zIDxy
cG1AbGV3LmlvPokBPQQTAQoAJwUCVEg8gAIbAwUJEswDAAULCQgHAwUVCgkICwUW
AgMBAAIeAQIXgAAKCRDqPP4lO24/os/9B/4sZMoZ6hD9BiFPJREBkjDsqbKnMST3
ywHqX8xZ4QZZSy/OFHWiVK1Al8HiCkBqPyCzbEceRpYxfXrjmIOvwcJy80lJpivp
Z6G+T5c/nNm64B/xBgEhGNFwfc9qDYL9QXliADAaT1ede7tCTouvDFHVf/Lr8d/C
bbBQiMw+d49/9rFVj4zMV7vLyIGxXw3FYkbepCxJo+lXOT0Ic1frmpaC66v/NBos
KnvdUez/Z16WAOK7vpzexJEgnlII5hWIXXtKMf2gMC7wMf9opEAoiGry+xcywp8U
tZtFecPbNcw5gpkBWl2Q1JmmgsQ4jmRDBbW2d2OywUisL0tYTsNR+xXv
=dyY4
-----END PGP PUBLIC KEY BLOCK-----
KEYCONTENT
chmod 644 /etc/pki/rpm-gpg/RPM-GPG-KEY-LEW

# install lew.io rpm repo
cat > /etc/yum.repos.d/lew.repo <<REPOCONTENT
[lew]
name=lew
baseurl=https://dl.bintray.com/lew/rpm/el$RELEASEVER/x86_64
gpgcheck=1
enabled=1
REPOCONTENT

yum -y install puppet git || die "Failed to install required packages"
<<<<<<< HEAD
rm -rf /etc/puppet
git clone -b refresh https://bitbucket.org/lewispeckover/puppet.git /etc/puppet
pushd /etc/puppet > /dev/null
puppet apply --modulepath ./modules manifests/bootstrap.pp
