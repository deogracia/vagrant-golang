#!/usr/bin/env bash

####
#
# variables
#
####

_DATE=$(/bin/date +%Y-%m-%d-%T)
export LogFile="/vagrant/provision_$_DATE.log"
export DEBIAN_FRONTEND=noninteractive

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
logAndPrint "01. on fait le ménage et on met à jour notre systeme."
apt-get clean   -y 2>&1 | tee -a $LogFile
apt-get update  -y 2>&1 | tee -a $LogFile
apt-get upgrade -y 2>&1 | tee -a $LogFile


logAndPrint "###"
logAndPrint "###"
logAndPrint "###"
logAndPrint "Fin provisionning!"
