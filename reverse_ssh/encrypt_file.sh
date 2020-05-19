#!/bin/bash
func_echo_and_log()
{
	MESSAGE=${1}
	INLOGFILE=${2}
	echo ${MESSAGE}
	echo ${MESSAGE} >> ${INLOGFILE}	
}

func_validate_different_exit()
{
	RESULT=${1}
	CONDITION=${2}
	MESSAGE_ERROR=${3}
	MESSAGE_SUCCESS=${4}
	INLOGFILE=${5}
	if [ ${RESULT} != ${CONDITION} ]
	then
		func_echo_and_log "${MESSAGE_ERROR}" "${INLOGFILE}"
		exit 0
	else
		func_echo_and_log "${MESSAGE_SUCCESS}" "${INLOGFILE}"
	fi	
}

PUBKEY=${1}
CONFIGFILE=${2}
OUTPUTFILE=${3}

if [ -z ${PUBKEY} ]
then
	echo "Please specify public key as the firtst argument."
	echo "./encrypt_file.sh <public_key_file>"
	exit 0
fi

ls ${PUBKEY}
if [ $? != 0 ]
then
	echo "Public key file not exits"
	exit 0
fi

if [ -z ${CONFIGFILE} ]
then
	echo "Please specify CONFIGFILE as the second argument."
	echo "./encrypt_file.sh <public_key_file> <configfile>"
	exit 0
fi
ls ${CONFIGFILE}
if [ $? != 0 ]
then
	echo "config file not exits"
	exit 0
fi


if [ -z ${OUTPUTFILE} ]
then
	OUTPUTFILE="${CONFIGFILE}.blurr"
	echo "OUTPUTFILE not specified. Using ${OUTPUTFILE}"
fi

#openssl genrsa -out ssh_reverse_private.pem 2048
#openssl rsa -in ssh_reverse_private.pem -out ssh_reverse_public.pem -outform PEM -pubout
openssl rsautl -encrypt -inkey ${PUBKEY} -pubin -in ${CONFIGFILE} -out ${OUTPUTFILE}
if [ $? != 0 ]
then
	echo "There was an error ecnrypting the file. Maybe key is not a key"
fi
