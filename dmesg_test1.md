dmesg是一种程序，用于检测和控制内核环缓冲，程序用来助用户了解系统的启动信息。
dmesg命令用于打印Linux系统开机启动信息，kernel会将开机信息存储在ring buffer中。

# linux中的dmesg命令以及确定进程是否被系统主动kill
来源： http://3ms.huawei.com/km/blogs/details/5218641
作者： 刘家豪 00356970   

近期发现线上项目的进程莫名其妙的就不见了，也没有崩溃日志，就怀疑是被操作系统主动kill掉了，但是苦于没有确凿的证据，经过一番查询，发现dmesg命令可以看到操作系统内核的一些日志。

# 确定进程是否被Kill

执行dmesg命令
```sh
[bin]# dmesg
[882877.989319] Out of memory: Kill process 10212 (java) score 121 or sacrifice child
[882878.001160] Killed process 10212, UID 0, (java) total-vm:13098572kB, anon-rss:5027928kB, file-rss:208kB
[915713.862428] TCP: Peer 42.225.50.34:51564/8017 unexpectedly shrunk window 155723080:155723151 (repaired)
[915751.446054] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3428410295:3428410361 (repaired)
[916016.586020] TCP: Peer 223.245.136.70:26593/8017 unexpectedly shrunk window 2000807687:2000807751 (repaired)
[916787.644015] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3429952513:3429952529 (repaired)
[917496.356084] TCP: Peer 183.214.214.76:10836/8001 unexpectedly shrunk window 776640860:776640960 (repaired)
[917842.106120] TCP: Peer 183.214.214.76:10836/8001 unexpectedly shrunk window 776767925:776768001 (repaired)
[918184.273393] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3432537400:3432537416 (repaired)
[918354.099425] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3433043715:3433043731 (repaired)
[918458.735018] TCP: Peer 14.204.144.115:44067/8017 unexpectedly shrunk window 3982300320:3982300359 (repaired)
[918975.201329] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3434818386:3434818406 (repaired)
[919021.112801] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3434951074:3434951094 (repaired)
[919245.007146] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3435724834:3435724895 (repaired)
```

可以看到
``` Out of memory: Kill process 10212 (java) score 121 or sacrifice child ```

java进程被杀掉，关于dmesg的原始时间戳，是系统的产生mesg的系统uptime时间，故需要获取系统的启动时间。   

编写脚本ts_dmesg.sh
```sh

#!/bin/sh  
  
uptime_ts=`cat /proc/uptime | awk '{ print $1}'`  
#echo $uptime_ts  
dmesg | awk -v uptime_ts=$uptime_ts 'BEGIN {  
    now_ts = systime();  
    start_ts = now_ts - uptime_ts;  
    #print "system start time seconds:", start_ts;  
    #print "system start time:", strftime("[%Y/%m/%d %H:%M:%S]", start_ts);  
}  
{  
    print strftime("[%Y/%m/%d %H:%M:%S]", start_ts + substr($1, 2, length($1) - 2)), $0  
}'
 > 1.txt  # 最后这句是我加的，把dmesg显示结果写入文件
```

执行
```sh ts_dmesg```
输出，可以识别的时间
```
[2017/02/21 00:01:26] [882877.989319] Out of memory: Kill process 10212 (java) score 121 or sacrifice child
[2017/02/21 00:01:26] [882878.001160] Killed process 10212, UID 0, (java) total-vm:13098572kB, anon-rss:5027928kB, file-rss:208kB
[2017/02/21 09:08:42] [915713.862428] TCP: Peer 42.225.50.34:51564/8017 unexpectedly shrunk window 155723080:155723151 (repaired)
[2017/02/21 09:09:20] [915751.446054] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3428410295:3428410361 (repaired)
[2017/02/21 09:13:45] [916016.586020] TCP: Peer 223.245.136.70:26593/8017 unexpectedly shrunk window 2000807687:2000807751 (repaired)
[2017/02/21 09:26:36] [916787.644015] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3429952513:3429952529 (repaired)
[2017/02/21 09:38:25] [917496.356084] TCP: Peer 183.214.214.76:10836/8001 unexpectedly shrunk window 776640860:776640960 (repaired)
[2017/02/21 09:44:10] [917842.106120] TCP: Peer 183.214.214.76:10836/8001 unexpectedly shrunk window 776767925:776768001 (repaired)
[2017/02/21 09:49:52] [918184.273393] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3432537400:3432537416 (repaired)
[2017/02/21 09:52:42] [918354.099425] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3433043715:3433043731 (repaired)
[2017/02/21 09:54:27] [918458.735018] TCP: Peer 14.204.144.115:44067/8017 unexpectedly shrunk window 3982300320:3982300359 (repaired)
[2017/02/21 10:03:03] [918975.201329] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3434818386:3434818406 (repaired)
[2017/02/21 10:03:49] [919021.112801] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3434951074:3434951094 (repaired)
[2017/02/21 10:07:33] [919245.007146] TCP: Peer 1.61.9.67:1945/8017 unexpectedly shrunk window 3435724834:3435724895 (repaired)
```

# 关于系统/proc/uptime时间

在Linux中，我们常常会使用到uptime命令去看看系统的运行时间，它与一个文件有关，就是/proc/uptime，下面对其进行详细介绍。
