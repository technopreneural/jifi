#!/usr/bin/env bash

# Process return values and evaluate errors
function check_error() {
RESULT=${1} && MESSAGE=${2}
if [ $RESULT -ne 0 ]; then
	echo "${MESSAGE}. Aborting."
	exit $RESULT
fi
}

# Cleanup before closing
function cleanup() {
for i in /tmp/mnt/*/; do
	sudo umount $i
	check_error $? "Cannot unmount $i."
	sudo rm -rf $i
	check_error $? "Cannot remove temporary mount folder $i"
done
sudo losetup -d "${DEV_TARGET}"
check_error $? "Cannot unregister ${DEV_TARGET} loopback device."
sudo losetup -d "${DEV_SOURCE}"
check_error $? "Cannot unregister ${DEV_SORUCE} loopback device."
}

function fix_fstab() {
sudo mkdir -p /tmp/mnt/reco
check_error $? "Cannot create temporary folder /tmp/mnt/reco."
sudo mount "${DEV_TARGET}p2" /tmp/mnt/reco
check_error $? "Cannot mount ${DEV_TARGET}p1 to /tmp/mnt/reco."
sudo sh -c 'cat > /tmp/mnt/reco/etc/fstab << EOF
proc /proc proc defaults 0 0
UUID="${UUID_BOOT}" /boot vfat defaults 0 2
UUID="${UUID_RECO}" / ext4 defaults,noatime 0 1
EOF'
check_error $? "Cannot modify /tmp/mnt/reco/etc/fstab"
sudo mkdir -p /tmp/mnt/root
check_error $? "Cannot create temporary folder /tmp/mnt/root."
sudo mount "${DEV_TARGET}p2" /tmp/mnt/root
check_error $? "Cannot mount ${DEV_TARGET}p1 to /tmp/mnt/root."
sudo sh -c 'cat > /tmp/mnt/root/etc/fstab << EOF
proc /proc proc defaults 0 0
UUID="${UUID_BOOT}" /boot vfat defaults 0 2
UUID="${UUID_ROOT}" / ext4 defaults,noatime 0 1
EOF'
check_error $? "Cannot modify /tmp/mnt/root/etc/fstab"
}

# Set target image to boot from root partition by default
function set_boot_to_root() {
sudo mkdir -p /tmp/mnt/boot
check_error $? "Cannot create temporary folder /tmp/mnt/boot."
sudo mount "${DEV_TARGET}p1" /tmp/mnt/boot
check_error $? "Cannot mount ${DEV_TARGET}p1 to /tmp/mnt/boot."
sudo sed -i "/root=/ s/PARTUUID=[0-9A-F]\{8\}-[0-9]\{2\}/PARTUUID=${UUID_DISK}-03/" /tmp/mnt/boot/cmdline.txt
check_error $? "Cannot modify kernel boot parameters on target image boot partition."
sudo cat /tmp/mnt/boot/cmdline.txt | grep -q "root=PARTUUID=${UUID_DISK}-03"
check_error $? "PARTUUID does not match."
}

# Set new partition UUIDs for device identification
function set_partition_uuids() {
sudo tune2fs "${DEV_TARGET}p2" -U "${UUID_RECO}" > /dev/null
check_error $? "Cannot set UUID for ${DEV_TARGET}p2"
sudo tune2fs "${DEV_TARGET}p3" -U "${UUID_ROOT}" > /dev/null
check_error $? "Cannot set UUID for ${DEV_TARGET}p3"
sudo blkid
}

# Copy source image boot and root partitions to target image
function copy_partitions() {
sudo dd bs=4M conv=sparse,fsync if="${DEV_SOURCE}p1" of="${DEV_TARGET}p1" status=progress
check_error $? "Cannot copy boot partition."
sudo dd bs=4M conv=sparse,fsync if="${DEV_SOURCE}p2" of="${DEV_TARGET}p2" status=progress
check_error $? "Cannot copy recovery partition."
sudo dd bs=4M conv=sparse,fsync if="${DEV_SOURCE}p2" of="${DEV_TARGET}p3" status=progress
check_error $? "Cannot copy root partition."
}

# Create the boot, recovery, and root partitions
function partition_blank_image() {
sudo sfdisk "${IMG_TARGET}" <<EOL
label: dos
label-id: 0x${UUID_DISK}

name=boot, start="${BOOT_START}", size="${BOOT_SIZE}", type=c
name=reco, start="${ROOT_START}", size="${ROOT_SIZE}", type=83
name=root, start="$(( ${ROOT_START} + ${ROOT_SIZE} ))", size="${ROOT_SIZE}", type=83
EOL
check_error $? "Cannot create partitions."
}

# Register source and target image as loopback devices
function create_loopback_devices() {
DEV_SOURCE=$(sudo losetup -v -f "${IMG_SOURCE}" -P --show)
check_error $? "Cannot register ${IMG_SOURCE} as ${DEV_SOURCE}."
DEV_TARGET=$(sudo losetup -v -f "${IMG_TARGET}" -P --show)
check_error $? "Cannot register ${IMG_TARGET} as ${DEV_TARGET}."
}

# Create blank disk image of sufficient size
function create_blank_image() {
BLCK_COUNT=$(( $DISK_SIZE * 512 / 4096 / 1024 ))
sudo dd bs=4M conv=sparse,fsync count="${BLCK_COUNT}" if=/dev/zero of="${IMG_TARGET}" status=progress
check_error $? "Cannot create blank image."
}

# Calculate size of root, recovery, and boot partitions as well as total disk size
function calculate_partition_sizes() {
BOOT_START=$(sudo fdisk -lu "${IMG_SOURCE}" | sed -n "/W95 FAT32 (LBA)/p" | sed 's/[ ]\+/\t/g' | cut -f2)
BOOT_SIZE=$(sudo fdisk -lu "${IMG_SOURCE}" | sed -n "/W95 FAT32 (LBA)/p" | sed 's/[ ]\+/\t/g' | cut -f4)
ROOT_START=$(sudo fdisk -lu "${IMG_SOURCE}" | sed -n "/Linux/p" | sed 's/[ ]\+/\t/g' | cut -f2)
ROOT_SIZE=$(sudo fdisk -lu "${IMG_SOURCE}" | sed -n "/Linux/p" | sed 's/[ ]\+/\t/g' | cut -f4)
DISK_SIZE=$(( ${ROOT_START} + 2 * ${ROOT_SIZE} ))
}

# Generate unique disk and partition identifiers
function generate_uuids() {
UUID_DISK=$(tr -dc '0-7' < /dev/urandom | head -c1)$(tr -dc '0-9A-F' < /dev/urandom | head -c7) &&
UUID_BOOT=$(uuidgen) &&
UUID_RECO=$(uuidgen) &&
UUID_ROOT=$(uuidgen)
check_error $? "Cannot generate new UUIDs."
echo """
UUID_DISK=${UUID_DISK}
UUID_BOOT=${UUID_BOOT}
UUID_RECO=${UUID_RECO}
UUID_ROOT=${UUID_ROOT}
"""
}

# Main function: check parameters and proceed accordingly
function main() {
if [ ${#} -lt 1 ] || [ ${#} -gt 2 ]
then
	echo "Usage: recoverable.sh <source> <target>"
	exit 1
elif [ ! -f "${1}" ]
then
	echo "Source image does not exist."
	exit 2
elif [ -f "${2}" ]
then
	read -p "Target image exists. Overwrite? (Y/N): "
	if [[ $REPLY =~ ^[Nn]$ ]]
	then
		echo "Aborting."
		exit 0
	fi
fi
IMG_SOURCE="${1}"
[[ "${2}" ]] && IMG_TARGET="${2}" || IMG_TARGET="recoverable.img"
calculate_partition_sizes
create_blank_image
generate_uuids
partition_blank_image
create_loopback_devices
copy_partitions
set_partition_uuids
set_boot_to_root
fix_fstab
cleanup
}

# Execute only when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
