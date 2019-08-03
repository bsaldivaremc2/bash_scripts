#/bin/bash
#alias destroy="/home/bpse/Scripts/./remove_script.sh"
trials=3
warning_messages=()
warning_prefix="Are you "
warning_suffix="about this? (Y/n)"
warning_rep_word="sure"
warning_rep="${warning_rep_word} "
proceed_counter=0
aborting_message="Well thought =)"
proceeding_message="Proceeding to destroying everything"

for((i=1;i<=trials;i++))
do
	warning_text="${warning_prefix} ${warning_rep} ${warning_suffix}"
	echo "${proceeding_message}. ${warning_text}"
	warning_rep+="${warning_rep_word} "	
	read proceed
	if [[ ${proceed} == "Y" ]]
	then
		proceed_counter=$(( ${proceed_counter} + 1 ))
	else
		echo ${aborting_message}
		exit 0
	fi
done
if [[ ${proceed_counter} == ${trials} ]]
then
	echo ${proceeding_message}
	rm "$@"
fi


#for((i=0;i<=trials;i++))
#do
	#echo "Are you su"
#done
#rm "$@"