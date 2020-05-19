#!/bin/bash
KEYSIZE=${1}
OUTPUTNAME=${2}
if [ -z ${1} ]
then
	KEYSIZE=2048
fi
if [ -z ${2} ]
then
	OUTPUTNAME="ssh_reverse"
fi
PRIVKEY="${OUTPUTNAME}_private.pem"
PUBKEY="${OUTPUTNAME}_public.pem"
echo "Generating key of size ${KEYSIZE}. Public: ${PUBKEY}. Private: ${PRIVKEY}"
openssl genrsa -out ${PRIVKEY} ${KEYSIZE}
if [ $? != 0 ]
then
	echo "There was an error generating the private key"
	exit 1
fi

openssl rsa -in ${PRIVKEY} -out ${PUBKEY} -outform PEM -pubout
if [ $? != 0 ]
then
	echo "There was an error generating the Public key"
	exit 1
fi