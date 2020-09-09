#!/bin/sh

### # # #  #  #  #    #    #    #        #                #                               #
###      Script to backup macbook files to nas.
### # # #  #  #  #    #    #    #        #                #                               #

### This script Searches nas ip address with correct mac address of nas from mac book, mount to nas, and sync backup files.
### * nas product name is HDL-AAX2 producted by io-data.

#set -e

### store a value in variable.

## Shell directory
SCRIPT_DIR=$(cd $(dirname $0); pwd)
echo ${SCRIPT_DIR}

## network address.
seg_nw="192.168.0"

## nas mac address. 
mac_add_nas="34:76:c5:ee:8:3b"

## nas ip address.
ip_add_nas=""

## nas user.
nas_user="taichi"

## password for nas user.
password="xxxxxxxxxx"

## nas directory to be mounted on nas.
mounted_dir="t_data"

## home directory
home_dir="/Users/Taiti"

## mount directory path on pc.
mount_dir="${home_dir}/mnt/nas_iodata"

## backup source directory on pc.
src_dir1="Documents"
src_dir2="projects"
src_dir3="Pictures"
src_dir4="Music"
src_dir5="Movies"

## backup source directory path on pc.
#src_dir_path="/Users/Taiti"

## backup destination directory path on nas
dst_dir="${mount_dir}/macbook_backup"


### Find nas IP Address from network segment.

## Try all ip address in network segment.
for ip_address in `seq 1 254`;do

  ## Try ping command, arp command, grep command with mac address of nas by every ip, and get mac address, if ever.
  mac_add=$(ping -c 1 -W 0.5 ${seg_nw}.${ip_address} > /dev/null && arp ${seg_nw}.${ip_address} | cut -d " " -f 4 2>&1)

  ## Compare mac address with one of nas, get ip address of nas.
  if [ "${mac_add}" = "${mac_add_nas}" ]; then
     ip_add_nas="${seg_nw}.${ip_address}"
     #echo ${ip_add_nas}
     break
  fi;
done

### mount to nas.
mount -t smbfs -w //${nas_user}:${password}@${ip_add_nas}/${mounted_dir} ${mount_dir}
 # ex) mount -t smbfs //taichi:baggio1981id@192.168.0.105/t_data ~/mnt/nas_iodata

### sync data.

echo "rsync -ahv ${home_dir}/${src_dir3}/ ${dst_dir}/ > ${SCRIPT_DIR}/rsync_${src_dir3}.log &"
rsync -ahv --delete ${home_dir}/${src_dir1}/ ${dst_dir}/${src_dir1}/ > ${SCRIPT_DIR}/rsync_${src_dir1}.log &
rsync -ahv --delete ${home_dir}/${src_dir2}/ ${dst_dir}/${src_dir2}/ > ${SCRIPT_DIR}/rsync_${src_dir2}.log &
rsync -ahv --delete ${home_dir}/${src_dir3}/ ${dst_dir}/${src_dir3}/ > ${SCRIPT_DIR}/rsync_${src_dir3}.log &
rsync -ahv --delete ${home_dir}/${src_dir4}/ ${dst_dir}/${src_dir4}/ > ${SCRIPT_DIR}/rsync_${src_dir4}.log &
rsync -ahv --delete ${home_dir}/${src_dir5}/ ${dst_dir}/${src_dir5}/ > ${SCRIPT_DIR}/rsync_${src_dir5}.log &

### unmount nas
umount ${mount_dir}
 # ex)umount /Users/Taiti/mnt/nas_iodata
