#!/bin/sh

### store a value in variable.

## Shell directory
CURRENT=$(cd $(dirname $0;pwd))

## network address.
seg_nw="192.168.0"

## nas mac address. 
mac_add_nas="34:76:c5:ee:8:3b"

## nas ip address.
ip_add_nas=""

## nas user.
nas_user="taichi"

## password for nas user.
password="baggio1981id"

## mounted directory path on nas.
mounted_dir="t_data"

## mount directory path on pc.
mount_dir="/Users/Taiti/mnt/nas_iodata"

## backup source directory on pc.
src_dir1="Documents"
src_dir2="projects"
src_dir3="Pictures"
src_dir4="Music"
src_dir5="Movies"

## backup destination directory path on nas
dst_dir="/Users/Taiti/mnt/nas_iodata/macbook_backup"


### Find nas IP Address from network segment.

## try all ip address in network segment.
for ip_address in `seq 1 254`;do
 ## try ping command, arp command, grep command with mac address of nas to every number, and get mac address, if ever.
   #mac_add=$(ping -c 1 -W 0.5 192.168.0.$a > /dev/null && arp 192.168.0.$a | cut -d " " -f 4 2>&1)
  mac_add=$(ping -c 1 -W 0.5 ${seg_nw}.${ip_address} > /dev/null && arp ${seg_nw}.${ip_address} | cut -d " " -f 4 2>&1)

  ## Finding correct mac address, get ip address of nas.
  if [ "${mac_add}" = "${mac_add_nas}" ]; then
     ip_add_nas="${seg_nw}.${ip_address}"
     #echo ${ip_add_nas}
     break
  fi;
done

### mount do nas.
mount -t smbfs //${nas_user}:${password}@${ip_add_nas}/${mounted_dir} ${mount_dir}
 #mount -t smbfs //taichi:baggio1981id@192.168.0.105/t_data ~/mnt/nas_iodata


### sync data.
#rsync -az --delete ~/${src_dir1}/* ${dst_dir}/${src_dir1}/
rsync -ahv --delete ~/${src_dir2}/* ${dst_dir}/${src_dir2}/ 2>&1 CURRENT/backup2nas.log
#rsync -az --delete ~/${src_dir3}/* ${dst_dir}/${src_dir3}/
#rsync -az --delete ~/${src_dir4}/* ${dst_dir}/${src_dir4}/
#rsync -az --delete ~/${src_dir5}/* ${dst_dir}/${src_dir5}/
 #rsync -az --delete ~/Documents/* /Users/Taiti/mnt/nas_iodata/macbook_backup/Documents/

umount ${mount_dir}
 #umount /Users/Taiti/mnt/nas_iodata

