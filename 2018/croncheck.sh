#!/bin/bash

#For: During the crontab command whether there is ultra vires among users
#Author: qiushujun 280590
#Version: v1.0
#Data: 2016-09-13
#Version: v2.0
#Data: 2017-09-05

cd `dirname $0`
. ../until.sh
result_tag=PASS

cmdList=temp/cmd_list
usersList=temp/users_list
fileList=temp/file_list

egrep -v "^#|^$|^SHELL|^PATH|^MAILTO" /etc/crontab > $cmdList
awk -F':' '{print $1,$3}' /etc/passwd > $usersList

logical()
{
        power=511
        echo "$1"  | awk -F '/' '{ for (j=NF; j>=2; j--) {for (i=2 ; i<=j; i++)  printf "/"$i ;print "" }}'  > $fileList
        while read line
        do
            power=$((  $(( 0`stat -c %a  $line`)) & $power ))
        done < $fileList
}

isLogin()
{
    pass=$(grep "$1" /etc/shadow|awk -F':' '{print $2}')
    if [[ ${pass:0:1} == "!" ]];then
        return 1
    else
        return 0
    fi

}

while read line
do
    uid=$(echo "$line"|awk '{print $6}')
    cmdArr=()
    cmdArr=(${cmdArr[*]} $(echo "$line"|awk '{for(i=7;i<=NF;i++) print $i}'|awk -F'=|:' '{print $NF}'))
    if [ "$uid" -gt 0 ] 2>/dev/null ;then
        uid=$(grep "$uid" $usersList|awk '{print $1}')
    fi
    for cmd in ${cmdArr[*]}
    do
        cmd=$(echo $cmd|sed 's/^\"\|\"*$\|^\[\|\]*$\|^\-//g'|sed "s/'$//g")
        if [[ -L $cmd ]];then
            cmd=$( ls -l $cmd|awk '{print $NF}' )
        fi
        if [[ -f $cmd ]];then
            owner=$(ls -l $cmd|awk '{print $3}')
            power=$(stat -c %a  "$cmd")
            logical  "$cmd"
            if [[ $(( $(( $power)) | 493 )) != "493" ]]; then
                addLogger"FAIL,$cmd's should no more than 755, But it is $power!"
                result_tag="FAIL"
            fi
            if [[ $uid != $owner && $owner != "root" ]];then
                usertype=$(grep "$owner" /etc/passwd|awk -F ':' '{print $7}')
                if [[ $usertype == "/bin/false" ]];then
                    addLogger "WARNING,$cmd executed by $uid, But it belong to $owner,$owner is pseudo user, $usertype."
                else
                    if isLogin "$owner";then
                        addLogger "FAIL,$cmd executed by $uid, But it belong to $owner,$owner can login, $usertype."
                        result_tag="FAIL"
                    else
                        addLogger "WARNING,$cmd executed by $uid, But it belong to $owner,$owner can't login, $usertype."
                    fi
                fi
            fi
#	else
#			addLogger "FAIL,-$cmd- executed by $uid, But it is not exist！"
#				result_tag="FAIL"
        fi
    done
done < $cmdList

submit
