#!/bin/bash

# =======================
# Word replacement
# =======================
find *.json -print0 | xargs -0 sed -i 's/OldString/NewString/g'     # (non-recursive) files with whitespace delimited filenames
find . -type f -name "*.txt" -exec sed -i 's/foo/bar/g' {} +        # (recursive) word replacement by filetype
find ./ -type f -name "*.txt" -exec sed -i '' -e "s/foo/bar/" {} \; # (recursive) because Mac OX does things differently


# =======================
# Users and Groups
# =======================
sudo -u <user> -EH bash  # switch user and start a new bash session
id -u $USER              # get user's UID


# =======================
# .bashrc
# =======================
# See http://askubuntu.com/questions/145618/how-can-i-shorten-my-command-line-bash-prompt
if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u:\W\$ '
fi


# =======================
# Neat grep stuff
# =======================
# count and print all unique IP addresses in auth log
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /var/log/auth.log | sort | uniq -c
grep -E 'this.*(that1|that2|that3)'  # grep expression for 'this and (that1 or that2)' pattern
grep -r --include \*.ext key_word dir/


# =======================
# Disk info commands
# =======================
du -ksh *


# =======================
# Networking commands
# =======================
sudo ss -tp | grep <port>
sudo netstat -tup


# =======================
# Process info
# =======================
ps aux --sort -rss          # rank in order of RSS memory consumption
vmstat                      # another way of viewing context switching (http://letitcrash.com/post/17607272336/scalability-of-fork-join-pool)
pidstat -w -I -t -p <pid> 3 # view context switches


# =======================
# Some nice Java commands
# =======================
sudo jcmd <pid> GC.run       # force a GC
sudo jmap -histo:live <pid>  # view heap
JVM_OPTIONS="-J-server -J-verbose:gc \
   -J-Xms${JVM_HEAP_MIN:-32M}               \
   -J-Xmx${JVM_HEAP_MAX:-1024M}             \
   -J-XX:+AggressiveOpts                    \
   -J-XX:+UseConcMarkSweepGC                \
   -J-XX:+CMSParallelRemarkEnabled          \
   -J-XX:+CMSClassUnloadingEnabled          \
   -J-XX:+ScavengeBeforeFullGC              \
   -J-XX:+CMSScavengeBeforeRemark           \
   -J-XX:+UseCMSInitiatingOccupancyOnly     \
   -J-XX:CMSInitiatingOccupancyFraction=70  \
   -J-XX:-TieredCompilation                 \
   -J-XX:+UseStringDeduplication            \
   -J-XX:+PrintGC                           \
   -J-XX:+PrintGCTimeStamps                 \
   -J-Xloggc:logs/app-gc.log                \
   -J-XX:+UseGCLogFileRotation              \
   -J-XX:NumberOfGCLogFiles=10              \
   -J-XX:GCLogFileSize=100M                 \
   -J-XX:+HeapDumpOnOutOfMemoryError        \
   -J-XX:HeapDumpPath=\"logs/\"             "
   
   
# =======================
# docker commands
# =======================
sudo usermod -aG docker $USER

# typical docker clean up
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls -qf dangling=true)

# more specialized clean up
sudo docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm
docker rmi $(docker images | grep "<none>" | awk '{print $3}') 

docker build . -f Dockerfile -t orientdb
docker run -ti -v `pwd`/databases:/orientdb/databases -p 2424:2424 -p 2480:2480 orientdb


# =======================
# misc
# =======================
# generate random 4 byte hex string
x=$(dd if=/dev/random bs=4 count=1 2>/dev/null | od -An -tx1 | tr -d ' \t\n')
