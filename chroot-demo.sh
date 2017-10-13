#!/bin/sh

# Note: this example is for the standard command language interpreter (sh)
# not Bourne Again Shel (bash) as repo name implies
# Instructions based on https://www.cyberciti.biz/faq/unix-linux-chroot-command-examples-usage-syntax/
# Run comands on FreeBSD using Vagrant

############################
# Start in `/home/vagrant` #
############################

pwd 


####################################
# Create `newroot` dir and subdirs #
####################################

mkdir newroot
mkdir -p newroot/{bin,dev,lib,libexec,sbin}


################################
# Copy some binaries           #
################################

cp -v /bin/{sh,ls,ps,sleep} newroot/bin
cp -v /sbin/{ifconfig} newroot/sbin


####################################
# Copy library dependencies #
####################################

ldd /bin/sh
# /bin/sh:
#	 libedit.so.7 => /lib/libedit.so.7 (0x800846000)
#	 libc.so.7 => /lib/libc.so.7 (0x800a7f000)
#	 libncursesw.so.8 => /lib/libncursesw.so.8 (0x800e33000)

cp -v /lib/{libedit.so.7,libc.so.7,libncursesw.so.8} newroot/lib

# Need this to avoid ELF interpreter error
cp -v /libexec/ld-elf.so.1 newroot/libexec

ldd /bin/ls
# /bin/ls:
# 	libxo.so.0 => /lib/libxo.so.0 (0x800828000)
# 	libutil.so.9 => /lib/libutil.so.9 (0x800a43000)
# 	libncursesw.so.8 => /lib/libncursesw.so.8 (0x800c56000)
# 	libc.so.7 => /lib/libc.so.7 (0x800eb2000)

cp -v /lib/{libxo.so.0,libutil.so.9} newroot/lib

ldd /bin/ps
# /bin/ps:
# 	libm.so.5 => /lib/libm.so.5 (0x800829000)
# 	libkvm.so.7 => /lib/libkvm.so.7 (0x800a53000)
# 	libjail.so.1 => /lib/libjail.so.1 (0x800c61000)
# 	libxo.so.0 => /lib/libxo.so.0 (0x800e66000)
# 	libc.so.7 => /lib/libc.so.7 (0x801081000)
# 	libelf.so.2 => /lib/libelf.so.2 (0x801435000)
# 	libutil.so.9 => /lib/libutil.so.9 (0x80164c000)

cp -v /lib/{libm.so.5,libkvm.so.7,libelf.so.2} newroot/lib

ldd /sbin/ifconfig
# /sbin/ifconfig:
# 	libm.so.5 => /lib/libm.so.5 (0x800848000)
# 	lib80211.so.1 => /lib/lib80211.so.1 (0x800a72000)
# 	libjail.so.1 => /lib/libjail.so.1 (0x800c76000)
# 	libc.so.7 => /lib/libc.so.7 (0x800e7b000)
# 	libsbuf.so.6 => /lib/libsbuf.so.6 (0x80122f000)
# 	libbsdxml.so.4 => /lib/libbsdxml.so.4 (0x801432000)

cp -v /lib/{lib80211.so.1,libjail.so.1,libsbuf.so.6,libbsdxml.so.4} newroot/lib


###############################################
# Ok, lets go ahead and change root into new  #
# dir and try out the commands we copied      #
###############################################

sudo chroot newroot/ /bin/sh
