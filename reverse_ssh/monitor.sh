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

echo "Starting monitor"

#
LOGFILE="remote_monitor.log"
DATETIME=$(date +"%Y_%m_%d__%H_%M_%S")
echo "==========================================================" >> ${LOGFILE}
echo "${DATETIME}" >> ${LOGFILE}
#
TMPFILE=".tmp.tmp"
TMPCONFIG=".config.tmp"

MONITORID="URVBSALDIVAR"
GIT_REPO="https://github.com/bsaldivaremc2/bash_scripts.git"
#RAW_CONFIG_FILE="remote_ssh/central.config"
RAW_CONFIG_FILE="reverse_ssh/central.config.blurr"
CONFIG_FILE="central.config.deblurr"
PRIVATEKEY="ssh_reverse_private.pem"

#
DIR=$(echo "${GIT_REPO}" | awk -F '/' '{print $NF}' | awk -F '.git' '{print $1}')
RAW_CONFIG_FILE="${DIR}/${RAW_CONFIG_FILE}"
echo "${RAW_CONFIG_FILE}"

#Check if repo exist
DEL_GIT_DIR=0
CLONE_GIT_DIR=0
if [ -d ${DIR} ]
then
	GIT_DIR_VALID=$(cd ${DIR} && ls -la | grep "\.git" | wc -l)
	if [ ${GIT_DIR_VALID} == 1 ]
	then
		func_echo_and_log "Git repo Directory Found. Pulling" "${LOGFILE}"
		cd ${DIR} && git pull && cd ..
		if [ $? != 0 ]
		then
			DEL_GIT_DIR=1
			CLONE_GIT_DIR=1
		fi
	else
		DEL_GIT_DIR=1
		CLONE_GIT_DIR=1
	fi
	if [ ${DEL_GIT_DIR} == 1 ]
	then
		func_echo_and_log "Git repo Directory Found. But not valid. deleting directory" "${LOGFILE}"
		rm -rf ${DIR}
	fi
else
	CLONE_GIT_DIR=1
fi
if [ ${CLONE_GIT_DIR} == 1 ]
then
	git clone ${GIT_REPO}
	func_validate_different_exit ${?} 0 "Error cloning repo ${GIT_REPO}. Exit program." "SUCCESS cloning repo ${GIT_REPO}" "${LOGFILE}"
fi
#####
exit 0

ls ${RAW_CONFIG_FILE}
func_validate_different_exit ${?} 0 "Error getting configuration file ${RAW_CONFIG_FILE}. Exit program." "SUCCESS finding config file ${RAW_CONFIG_FILE}" "${LOGFILE}"
#func_validate_different_exit ${?} 0 "Error getting configuration file. Exit program." "SUCCESS finding config file" "${LOGFILE}"
#Check if config file exist


#Decrypt
echo "Decrypting config file"
openssl rsautl -decrypt -inkey ${PRIVATEKEY} -in ${RAW_CONFIG_FILE} -out ${CONFIG_FILE}
#Check if previous command successful
func_validate_different_exit ${?} 0 "Error extracting configuration. Exit program." "Extracting configuration. SUCCESS" "${LOGFILE}"


#Check if config file has data for this ID
VALID_ID=$(cat ${CONFIG_FILE} | grep ${MONITORID} | wc -l)
func_validate_different_exit ${VALID_ID} 1 "ID not present or ducplicate. Exit program." "ID FOUND" "${LOGFILE}"

#Check how many lines are meant for this monitor

#Clean file
cat "${CONFIG_FILE}" | tr '\t' ' ' | tr -s ' ' | sed 's/^ //g' | sed 's/ $//g' > "${TMPCONFIG}"

#
LINESN=$(cat ${TMPCONFIG} | grep ${MONITORID} |  awk -F " " '{print $2}')
cat ${CONFIG_FILE} | grep ${MONITORID} -A${LINESN} > ${TMPFILE}

echo "=="
#Check for status
FIELD="STATUS"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -l)
func_validate_different_exit "${VALID_FIELD}" 1 "${FIELD} not present or ducplicate. Exit program." "${FIELD} FOUND" "${LOGFILE}"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -w)
func_validate_different_exit ${VALID_FIELD} 2 "${FIELD} Wrong format. Not 2 values. Exit program." "${FIELD} FOUND and 2 values" "${LOGFILE}"
VALUE=$(cat ${TMPFILE} | grep "${FIELD}" |  awk -F " " '{print $2}' )
func_validate_different_exit ${VALUE} "ONLINE" "${FIELD} Offline or not ONLINE. Exit program." "${FIELD} ONLINE" "${LOGFILE}"

STATUS=${VALUE}
func_echo_and_log "${FIELD}: ${VALUE}" "${LOGFILE}"


#Check for user
FIELD="REMOTE_USER"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -l)
func_validate_different_exit ${VALID_FIELD} 1 "${FIELD} not present or ducplicate. Exit program." "${FIELD} FOUND" "${LOGFILE}"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -w)
func_validate_different_exit ${VALID_FIELD} 2 "${FIELD} Wrong format. Not 2 values. Exit program." "${FIELD} FOUND and 2 values" "${LOGFILE}"
VALUE=$(cat ${TMPFILE} | grep "${FIELD}" |  awk -F " " '{print $2}' )

REMOTE_USER=${VALUE}
func_echo_and_log "${FIELD}: ${VALUE}" "${LOGFILE}"


#Check for remote ip
FIELD="REMOTE_IP"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -l)
func_validate_different_exit ${VALID_FIELD} 1 "${FIELD} not present or ducplicate. Exit program." "${FIELD} FOUND" "${LOGFILE}"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -w)
func_validate_different_exit ${VALID_FIELD} 2 "${FIELD} Wrong format. Not 2 values. Exit program." "${FIELD} FOUND and 2 values" "${LOGFILE}"
VALUE=$(cat ${TMPFILE} | grep "${FIELD}" |  awk -F " " '{print $2}' )

REMOTE_IP=${VALUE}
func_echo_and_log "${FIELD}: ${VALUE}" "${LOGFILE}"


#Check for remote port
FIELD="REMOTE_PORT"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -l)
func_validate_different_exit ${VALID_FIELD} 1 "${FIELD} not present or ducplicate. Exit program." "${FIELD} FOUND" "${LOGFILE}"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -w)
func_validate_different_exit ${VALID_FIELD} 2 "${FIELD} Wrong format. Not 2 values. Exit program." "${FIELD} FOUND and 2 values" "${LOGFILE}"
VALUE=$(cat ${TMPFILE} | grep "${FIELD}" |  awk -F " " '{print $2}' )

REMOTE_PORT=${VALUE}
func_echo_and_log "${FIELD}: ${VALUE}" "${LOGFILE}"

#Check for reverse port
FIELD="REVERSE_PORT"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -l)
func_validate_different_exit ${VALID_FIELD} 1 "${FIELD} not present or ducplicate. Exit program." "${FIELD} FOUND" "${LOGFILE}"
VALID_FIELD=$(cat ${TMPFILE} | grep "${FIELD}" | wc -w)
func_validate_different_exit ${VALID_FIELD} 2 "${FIELD} Wrong format. Not 2 values. Exit program." "${FIELD} FOUND and 2 values" "${LOGFILE}"
VALUE=$(cat ${TMPFILE} | grep "${FIELD}" |  awk -F " " '{print $2}' )

REVERSE_PORT=${VALUE}
func_echo_and_log "${FIELD}: ${VALUE}" "${LOGFILE}"

echo "END of checkup"

#Testing connectivity

nmap ${REMOTE_IP} -p ${REMOTE_PORT} | grep "open"
func_validate_different_exit ${?} 0 "Error connecting to remote server ${REMOTE_IP}. Port ${REMOTE_PORT} closed. Exit program." "Connection to: ${REMOTE_IP} Port: ${REMOTE_PORT} SUCCESS" "${LOGFILE}"

#CONNECTION_STATUS=$(netstat -an | grep "${REMOTE_IP}:${REMOTE_PORT}" | grep ESTABLISHED | wc -l)
CONNECTIONS=$(netstat -an | grep "${REMOTE_IP}:${REMOTE_PORT}")
func_echo_and_log "Connections:" "${LOGFILE}"
func_echo_and_log "${CONNECTIONS}" "${LOGFILE}"
func_echo_and_log "" "${LOGFILE}"



echo "$(netstat -an | grep "${REMOTE_IP}:${REMOTE_PORT}")"
netstat -an | grep "${REMOTE_IP}:${REMOTE_PORT}" | grep "ESTABLISHED"
if [ ${?} == 0 ]
then
	echo "Connection running"
	echo "Connection running. Closing monitor." >> ${LOGFILE}
	exit 0
else
	echo "connecting to server"
	echo "Connection NOT running. connecting to server." >> ${LOGFILE}
	ssh -R ${REVERSE_PORT}:localhost:22 ${REMOTE_USER}@${REMOTE_IP} -p ${REMOTE_PORT} 

fi

echo "End of monitor"
echo "End of monitor." >> ${LOGFILE}
echo "" >> ${LOGFILE}
