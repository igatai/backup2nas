#!/bin/sh

### # # #  #  #  #    #    #    #        #                #                               #
###
### Script to backup macbook files to NAS.

### This script works at macbook with following flow.
###  1. It compares mac address found in a network segment with correct one to search NAS.
###  2. Let macbook mount to NAS.
###  3. Sync files to backup.

### This script Searches nas ip address with correct mac address of nas from mac book, mount to nas, and sync backup files.
### * Backup data : Documents, codes, Pictures, Music and Movies.
### * Backup destination : Directory to share with family on NAS.
### * NAS Product information : HDL-AAX2 / io-data.
###
### # # #  #  #  #    #    #    #        #                #                               #

### Store a value in variable.

# Set secret information from other file to environmental valiables.(nas_mac_address,nas_user,nas_password)
source ./secret.sh

## Shell directory.
SCRIPT_DIR=$(cd $(dirname $0); pwd)

## Network address.
seg_nw="192.168.0"

## Nas ip address.
ip_add_nas=""

## Directory to be mounted on nas.
mounted_dir="t_data"

## Home directory.
home_dir="/Users/Taiti"

## Mount directory on pc.
mount_dir="${home_dir}/mnt/nas_iodata_1"

## Backup source directory on pc.
src_dir1="Documents"
src_dir2="projects"
src_dir3="Pictures"
src_dir4="Music"
src_dir5="Movies"

## Destination directory to backup data on nas.
dst_dir="${mount_dir}/macbook_backup"

### Find nas IP Address from network segment.

## Try all ip address in network segment.
for ip_address in `seq 1 254`;do

  ## Try ping command, arp command, grep command with mac address of nas by every ip, and get mac address, if ever.
  mac_add=$(ping -c 1 -W 0.5 ${seg_nw}.${ip_address} > /dev/null && arp ${seg_nw}.${ip_address} | cut -d " " -f 4 2>&1)

  ## Compare mac address with one of nas, get ip address of nas.
  if [ "${mac_add}" = "${nas_mac_address}" ]; then
     ip_add_nas="${seg_nw}.${ip_address}"
     break
  fi;
done

### unmount nas
umount ${mount_dir}

### Mount to nas.
mount -t smbfs -w //${nas_user}:${nas_password}@${ip_add_nas}/${mounted_dir} ${mount_dir} || exit 1

### Sync data.

rsync -ahv --delete ${home_dir}/${src_dir1}/ ${dst_dir}/${src_dir1}/ > ${SCRIPT_DIR}/rsync_${src_dir1}.log &
rsync -ahv --delete ${home_dir}/${src_dir2}/ ${dst_dir}/${src_dir2}/ > ${SCRIPT_DIR}/rsync_${src_dir2}.log &
rsync -ahv --delete ${home_dir}/${src_dir3}/ ${dst_dir}/${src_dir3}/ > ${SCRIPT_DIR}/rsync_${src_dir3}.log &
rsync -ahv --delete ${home_dir}/${src_dir4}/ ${dst_dir}/${src_dir4}/ > ${SCRIPT_DIR}/rsync_${src_dir4}.log &
rsync -ahv --delete ${home_dir}/${src_dir5}/ ${dst_dir}/${src_dir5}/ > ${SCRIPT_DIR}/rsync_${src_dir5}.log &

