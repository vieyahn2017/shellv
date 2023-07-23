#!/bin/sh  
  
#统计出/tmp目录下所有脚本文件(.sh)的行数
find /tmp -name "*.sh" -print0 | xargs -0 wc -l


# 统计一个源代码目录中所有py文件的行数：
find . -type f -name "*.py" -print0 | xargs -0 wc -l


# 复制所有图片文件到 /data/images 目录下：
ls *.jpg | xargs -n1 -I {} cp {} /data/images


#查找系统中不属于任何用户的文件及目录
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser -ls
