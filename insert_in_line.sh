#!/bin/bash
#Version 201812062023
#by: bsaldivar.emc2@gmail.com
#https://twitter.com/bsaldivaremc2

function file_exists()
{
  if [ ! -f ${1} ]
  then
    echo "No such file: "${1}". Terminating script."
    exit
  fi
}
function var_exists_exit()
{
	if [ -z ${1} ] 
	then
  		echo "${2}"
  		exit
	fi
}
function var_exists_assign()
{
	if [ -z ${1} ] 
	then
		echo "${2}"
	fi
}
function var_exists_assign_validate()
{
	VAR=$(echo ${1} | sed 's/^ //g' | sed 's/ $//g' ) 
	VALID_VALUES=${2}
	DEFAULT_VALUE=${3}
	#(echo "${VAR}" | grep -i "true\|false" | wc -l )
	VAR_VALID=$(echo "${VAR}" | grep -i "${VALID_VALUES}" | wc -l )
	if [ -z ${VAR} ] | [ ${VAR_VALID} -ne 1 ]
	then
		echo "${DEFAULT_VALUE}"
	else
		echo "${VAR}"
	fi
}

USAGE=$(cat <<-END
 PURPOSE:\n
 	\tFind a line in a file which contains a given text and insert in that line\n
	\tthe text that is in another file.\n
GENERAL USAGE (you have to write = explicitly):\n
    \t-f=, --file=\n
		\t\tThe file where you wish to locate a text.\n
	\t-t=,--text=\n
		\t\tThe text that has to be searched in the file. The first coincidence will be taken only.\n
	\t-i=,--insert=\n
		\t\tThe file, which contents will be inserted into the first file where the text was found.\n
	\t-rl=,--replace-line=\n
		\t\t(optiontal) Accepts true or false as values, default is true.\n
		\t\tThe line that contains the text that is searched will be erased if true. \n
		\t\tElse, the new content will be inserted below this line.\n
	\t-rf=,--replace-file=\n
		\t\t(optiontal) Accepts true or false as values, default is true.\n
		\t\tWill put the output of the process in a file with the same name (overwrite)\n
		\t\tas the main file where the text was searched. \n
		\t\tIf false, a new file with the prefix output_ will be generated.\n
	\t-kb=,--keep-backup=\n
		\t\t(optiontal) Accepts true or false as values, default is true.\n
		\t\tworks if -rf=true. Save a backup of the original file with the prefix bk_\n
END
)

for i in "$@"
do
case $i in
    -f=*|--file=*)
    	ifile="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--text=*)
    	text_to_find="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--insert=*)
    	file_to_insert="${i#*=}"
    shift # past argument=value
    ;;
    -rl=*|--replace-line=*)
    	replace_line="${i#*=}"
    shift # past argument=value
    ;;
    r--insertf=*|--replace-file=*)
    	replace_file="${i#*=}"
    shift # past argument=value
    ;;
	k--insertb=*|--keep-backup=*)
    	keep_bk="${i#*=}"
    shift # past argument=value
    ;;
	-h|--help)
    	echo -e ${USAGE}
    	exit
    shift # past argument=value
    ;;
	#--default)
    #DEFAULT=YES
    #shift # past argument with no value
    #;;
    *)
		echo "No valid option, type -h or --help to see usage"; exit;
    ;;
esac
done

#while getopts f:d:p:f: option
#do
	#case "${option}" in
	#f | -file ) input_file=${OPTARG};;
	#t) text_to_find=${OPTARG};;
	#i) text_to_insert=${OPTARG};;
	#*) echo "No valid argument";;
	#esac
#done



#input_file

var_exists_exit "${ifile}" "No file specified use with -h or --help to see usage."
file_exists "${ifile}"
var_exists_exit "${text_to_find}" "No text to find specified"
var_exists_exit "${file_to_insert}" "No file to insert specified"
file_exists "${file_to_insert}"
replace_line=$(var_exists_assign_validate "${replace_line}" "true\|false" "true")
replace_file=$(var_exists_assign_validate "${replace_file}" "true\|false" "true")
keep_bk=$(var_exists_assign_validate "${keep_bk}" "true\|false" "true")


echo "file:${ifile} text:${text_to_find} insert:${file_to_insert} replace_line:${replace_line} replace_file:${replace_file} keep_bk:${keep_bk}"

line_pos=$(cat -n "${ifile}" | grep "${text_to_find}" | tr -s ' ' | sed 's/[\t]/ /g' | sed 's/^ //g' | cut -d " " -f1 | sed -n 1p)
var_exists_exit "${line_pos}" "Text ${text_to_find} is not in file ${ifile}"

total_lines=$(wc -l ${ifile} | cut -d " " -f1)
line_caught=$(cat "${ifile}" | grep ${text_to_find} | sed -n 1p)

lines_before_n=$(( ${line_pos} - 1 ))
lines_before=$(head -n  ${lines_before_n} ${ifile})

lines_after_n=$(( ${total_lines} - ${line_pos} ))
lines_after_n_with=$(( ${lines_after_n} - 1 ))
lines_after=$(tail -n  ${lines_after_n} ${ifile})


inserted_lines_n=$(wc -l ${file_to_insert} | cut -d " " -f1)
total_new_lines=$(( ${total_lines} + ${inserted_lines_n}))

echo "line_pos:${line_pos} | total_lines:${total_lines} | inserted_lines_n:${inserted_lines_n}"


check_lines=$(( ${total_new_lines} - ${line_pos} ))


function print_output()
{
	OUTPUTFILE=${1}
	echo "${lines_before}" > "${OUTPUTFILE}"
	if [ ${replace_line} == "false" ]
	then
		echo "${line_caught}" >> "${OUTPUTFILE}"
		check_lines=$(( ${check_lines} + 1 ))
	fi
	cat "${file_to_insert}" >> "${OUTPUTFILE}"
	echo "${lines_after}" >> "${OUTPUTFILE}"
	echo "Done. ${ifile} updated. Check with:"
	echo "tail -n ${check_lines} ${OUTPUTFILE} | head -n ${inserted_lines_n}"	
}


if [ ${replace_file} == 'true' ]
then
	mv "${ifile}" "tmp_${ifile}"
	print_output "${ifile}"
	if [ "${keep_bk}" == 'false' ]
	then
		if [ -f "tmp_${ifile}" ]
		then
			rm "tmp_${ifile}"
		fi
	fi
else
	print_output "output_${ifile}"
fi



#Some references:
#https://www.lifewire.com/pass-arguments-to-bash-script-2200571
#http://linuxcommand.org/lc3_wss0120.php
#https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#https://stackoverflow.com/questions/2059794/what-is-the-meaning-of-the-0-syntax-with-variable-braces-and-hash-chara
#https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and