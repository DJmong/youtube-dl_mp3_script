#!/bin/bash
list=list.txt
dir=$HOME
log=log.txt
retry="Y"

echo "youtue_mp3 donwloader ver. 0.1"

if [ ! -e $list ]; then
	echo "$list is not exist."
	exit 1
fi

if [ -e $log ]; then
	rm $log
fi

cat $list | while read line
do
	if [ -z "$line" ]; then
		echo "list is empty!"
		continue
	elif [[ "$line" == "#"* ]]; then
		echo "$line" >> ".$list"
		continue
	fi
	url=${line%%,*}
	name=${line#*,}
	echo  -n "url :$url"
	echo "  name :$name"
	if [ -z "$name" ]; then
		youtube-dl -x --audio-format mp3 --audio-quality 0 $url
	else
		youtube-dl -x --output "$dir/$name.mp3" --audio-format mp3 --audio-quality 0 $url
	fi
# make pass/fail log to $log 
	if [ 0 -eq $? ]; then
		echo "$name download success" >> $log
	else
		echo "$name is not downloaded. (url : $url)" >> $log
		if [ "$retry" == "Y" ]; then
			echo "$url,$name" >> .$list
		fi
	fi
done

# remove list
rm $list

# update list
if [ -e .$list ]; then
	mv .$list $list
else
	touch $list
fi

