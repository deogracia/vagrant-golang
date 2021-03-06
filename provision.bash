#!/usr/bin/env bash

####
#
# variables
#
####

_DATE=$(/bin/date +%Y-%m-%d-%T)
export LogFile="/vagrant/provision_$_DATE.log"
export DEBIAN_FRONTEND=noninteractive
_GO_VERSION="1.2.2"
_GO_SRC_PREFFIX="/opt/src"
_GO_PREFFIX="/home"

####
#
# fonctions
#
####

function logAndPrint()
{
 echo "$(/bin/date +%Y-%m-%d-%T) : $1" 2>&1 | tee -a $LogFile
}

####
#
# Début exécution
#
####

logAndPrint "Debut provisionning..."

logAndPrint "###"
logAndPrint "###"
logAndPrint "###"
logAndPrint "01. On fait le ménage et on met à jour notre systeme."
apt-get clean   -y 2>&1 | tee -a $LogFile
apt-get update  -y 2>&1 | tee -a $LogFile
apt-get upgrade -y 2>&1 | tee -a $LogFile

sudo -H -i -u vagrant /bin/bash -c "echo \"silent\" > ~/.curlrc" 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "###"
logAndPrint "###"
logAndPrint "02. On install go."
logAndPrint "###"
logAndPrint "02.01 On installe la version les pré-requis."
apt-get install git -y 2>&1 | tee -a $LogFile
apt-get install mercurial -y 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "02.02 On récupère la version ${_GO_VERSION}."
mkdir -p ${_GO_SRC_PREFFIX} 2>&1 | tee -a $LogFile
/usr/bin/wget -nv -O ${_GO_SRC_PREFFIX}/go${_GO_VERSION}.linux-amd64.tar.gz https://storage.googleapis.com/golang/go${_GO_VERSION}.linux-amd64.tar.gz 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "02.03 On supprime l'éventuelle version précédente."
/bin/rm ${_GO_PREFFIX}/go -rf 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "02.04 On décompresse dans ${_GO_PREFFIX}."
/bin/tar -C ${_GO_PREFFIX} -xzf ${_GO_SRC_PREFFIX}/go${_GO_VERSION}.linux-amd64.tar.gz 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "02.05 On ajoute ${_GO_PREFFIX}/go/bin  \$PATH."
/usr/bin/sudo -H -i -u vagrant /bin/bash -c "/bin/echo \"export PATH='${_GO_PREFFIX}/go/bin:\$PATH'\" >> /home/vagrant/.profile" 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "02.06 On set \$GOROOT ."
/bin/echo "export GOROOT='${_GO_PREFFIX}/go'" >> /home/vagrant/.profile 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "02.07 On set \$GOPATH ."
/bin/echo "export GOPATH='/vagrant'" >> /home/vagrant/.profile 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "02.08 On met à jour \$PATH ."
/bin/echo "export PATH='\$GOPATH/bin:\$PATH'" >> /home/vagrant/.bashrc 2>&1 | tee -a $LogFile
/usr/bin/sudo -H -i -u vagrant /bin/bash -c "/bin/echo \"export PATH='\$GOPATH/bin:\$PATH'\" >> /home/vagrant/.profile" 2>&1 | tee -a $LogFile

logAndPrint "###"
logAndPrint "###"
logAndPrint "###"
logAndPrint "Fin provisionning!"
