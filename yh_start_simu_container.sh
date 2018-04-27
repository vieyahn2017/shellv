#!/bin/bash
#"$1": PORT
#"$2": NAME


docker pull 10.183.118.211:5000/dj_simu:oceanstor_v3_001
addr=`ifconfig | grep  "inet addr" | grep -v "0.0.0"| cut -f 2 -d ":" | cut -f 1 -d " " | xargs | tr ' ' ','`


if [ $2 ]; then
  docker run -d -p $1:$1 --name $2 10.183.118.211:5000/dj_simu:oceanstor_v3_001 sh /home/start.sh -i $addr -p $1 &
  echo docker run -d -p $1:$1 --name $2 10.183.118.211:5000/dj_simu:oceanstor_v3_001 sh /home/start.sh -i $addr -p $1 &
else
  docker run -d -p $1:$1 10.183.118.211:5000/dj_simu:oceanstor_v3_001 sh /home/start.sh -i $addr -p $1 &
  echo docker run -d -p $1:$1 10.183.118.211:5000/dj_simu:oceanstor_v3_001 sh /home/start.sh -i $addr -p $1 &
fi




