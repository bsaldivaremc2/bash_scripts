#!/bin/bash


func_echo_and_log()
{
	MESSAGE=${1}
	INLOGFILE=${2}
	echo ${MESSAGE}
	echo ${MESSAGE} >> ${INLOGFILE}	
}

SECONDS=${1}

if [ -z ${1} ]
then
	SECONDS=300
fi

#SECONDS=$(( ${MINUTES} * 60 ))
LOGFILE="remote_monitor.log"
TMPGUARD=".tmp.guard"
echo "${SECONDS}" > "${TMPGUARD}"
#SECONDS=10
i=0
while [[ ${i} < 2 ]]
do
	DATETIME=$(date +"%Y_%m_%d__%H_%M_%S")
	func_echo_and_log "GUARD: Starting guard of monitor at ${DATETIME}" "${LOGFILE}"
	func_echo_and_log "GUARD: " "${LOGFILE}"
	./monitor.sh
	DATETIME=$(date +"%Y_%m_%d__%H_%M_%S")
	SECONDS=$(cat "${TMPGUARD}")
	func_echo_and_log "GUARD: Waiting ${SECONDS} seconds for next round at ${DATETIME}" "${LOGFILE}"
	func_echo_and_log "GUARD: " "${LOGFILE}"
	sleep ${SECONDS}
done

func_echo_and_log "GUARD: Finishing work." "${LOGFILE}"