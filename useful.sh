#!/bin/bash
#
# Some of the commands below have been generated with ChatGPT. For reference, see 
#
# https://chat.openai.com/c/b4861bd9-4bfc-4f1b-8405-78191525e529
#


# =======================
# Find word replace, find folder delete 
# =======================
find *.json -print0 | xargs -0 sed -i 's/OldString/NewString/g'     # (non-recursive) files with whitespace delimited filenames
find . -type f -name "*.txt" -exec sed -i 's/foo/bar/g' {} +        # (recursive) word replacement by filetype
find ./ -type f -name "*.txt" -exec sed -i '' -e "s/foo/bar/" {} \; # (recursive) because Mac OX does things differently

# Recursively walk all files in my current working directory that have the executable 
# permission set
# 
# `find .`: This command starts the search from the current directory and its subdirectories.
#
# `-type f`: This option specifies that only regular files should be considered in the
# search (excluding directories and other file types).
#
# `-perm +111`: This option filters the files and selects only those that have the executable
# permission set. The +111 parameter indicates the executable permission for user, group, and
# others. The value 111 represents the octal permission mode.
find . -type f -perm +111

# Remove every file and folder except README.md
#
# `! -name 'README.md'`: This part specifies that the README.md file should be excluded
# from the search.
#
# `-mindepth 1`: This option ensures that the search starts from a minimum depth of 1, which 
# means it excludes the current directory (.) itself from deletion.
#
# `-delete`: This option deletes the files and directories that match the specified criteria.
find . ! -name 'README.md' -mindepth 1 -delete

# Recursively delete all __pycache__ subdirs
#
# `-type d`: This option specifies that only directories should be considered in the search.
#
# `-name "__pycache__"`: This option filters the directories and selects only those named
# `__pycache__`.
#
# `-exec rm -r {} +`: This part executes the rm -r command on each selected directory. `-r`
# ensures that directories are deleted recursively. {} is a placeholder that represents each
# directory found, and + signifies the end of the -exec command.
find . -type d -name "__pycache__" -exec rm -r {} +



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

# grep expression for 'this and (that1 or that2)' pattern
grep -E 'this.*(that1|that2|that3)'  

# grep for keyword only in dir/ with file extension .ext 
grep -r --include \*.ext key_word dir/

# turn off color
grep -color=never



# =======================
# Disk info commands
# =======================
du -ksh *

# List folders in macOS Darwin Terminal and pipe the output to du to get the size of each
# folder. Solution and explanation from ChatGPT ():
#
# `ls -d */`: This command lists only the directories (folders) in the current directory. 
# The -d option ensures that only directories are listed, and the */ filters out files.
#
# `xargs -I{}`: This command takes the output from the previous command and passes it as 
# arguments to the next command. -I{} specifies that {} will be replaced by the directory name.
#
# `du -sh "{}"`: This command uses du to calculate the size of each directory (`{}`). 
#The -s option summarizes the size of each directory, and the -h option prints the sizes 
# in human-readable format (e.g., "1.5G" for gigabytes).
ls -d */ | xargs -I{} du -sh "{}"



# =======================
# Networking commands
# =======================
sudo ss -tp | grep <port>
sudo netstat -tup

sudo conntrack -L | awk '{print $5,$4}' | grep src | \
  cut -d '=' -f 2 | sort | uniq -c | sort -nr | \
  perl -MSocket -nle 'm{\s((\d+\.){3}\d+)} && do{ ($hostname)=qx(host $1 10.233.0.3) =~ m{domain name pointer (.*)}; print "$_ ($hostname)"}' | head



# =======================
# Process info
# =======================
ps aux --sort -rss          # rank in order of RSS memory consumption
vmstat                      # another way of viewing context switching (http://letitcrash.com/post/17607272336/scalability-of-fork-join-pool)
pidstat -w -I -t -p <pid> 3 # view context switches


   
# =======================
# git commands
# =======================
git log --format='%aN' | sort -u       # list all authors 
git shortlog -s -n --all --no-merges   # number of commits per author
git shortlog -sne                      # number of commits per author with emails
git rev-parse --short HEAD             # commit hash shortened

# count commits since date
git rev-list --count --since="YYYY-MM-DD" --all

# count additions/removals since date
git log --since="YYYY-MM-DD" --numstat --pretty=format:'-' | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("Total additions: %s\nTotal removals: %s\n", plus, minus)}'



# =======================
# docker commands
# =======================
sudo usermod -aG docker $USER

# build on macOS with M1 (arm64) but need to run on amd64/linux
docker build --platform linux/amd64 ...

# typical docker clean up
docker container prune
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls -qf dangling=true)
docker volume prune

# more specialized clean up
sudo docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm
docker rmi $(docker images | grep "<none>" | awk '{print $3}') 

docker build . -f Dockerfile -t orientdb
docker run -ti -v `pwd`/databases:/orientdb/databases -p 2424:2424 -p 2480:2480 orientdb



# =======================
# openssl
# =======================
openssl rand -base64 8                     # generate password
openssl req -in mycsr.csr -noout -text     # read contents of cert request
openssl x509 -noout -subject -in cert.pem  # read subject of cert
openssl x509 -noout -text -in              # read full text of cert

# secure client example
openssl s_client -CAfile ca.pem -cert cert.pem -key key.pem -connect host:port 

# verify server-side certs are properly configured for domain
echo | openssl s_client -showcerts \
  -servname $DOMAIN -connect $IP_ADDRESS:443 \
  -verify 99 -verify_return_error



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
# misc
# =======================

# generate random 4 byte hex string
x=$(dd if=/dev/random bs=4 count=1 2>/dev/null | od -An -tx1 | tr -d ' \t\n')

# perl command for randomly picking from string array
perl -le 'print(("foo","bar","baz")[int rand 3])'

# use colon separator in PATH declaration to expand path names one line at a time
echo $PATH | awk -v RS=: 1
