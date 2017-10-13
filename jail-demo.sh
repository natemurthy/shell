# make and copy dirs
mkdir jail1 jail2
cp -r newroot/* jail1/.
cp -r newroot/* jail2/.

# create/remove jail defined in /etc/jail.conf
sudo jail -c testjail
sudo jail -r testjail

# create jail using command line args
sudo jail -c path=/home/vagrant/jail1 mount.devfs interface=em0 ip4.addr=10.0.2.16 allow.raw_sockets=1 command=/bin/sh
sudo jail -c path=/home/vagrant/jail2 mount.devfs interface=em0 ip4.addr=10.0.2.17 allow.raw_sockets=1 command=/bin/sh

# view processes with Jail ID (jid) etc
ps -axo uid,pid,jid,args

# jail cleanup
sudo ifconfig em0 -alias 10.0.2.16
sudo umount jail1/dev
sudo rm -rf jail1
