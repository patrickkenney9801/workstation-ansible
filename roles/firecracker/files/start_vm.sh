#!/bin/bash

lsmod | grep kvm_intel || lsmod | grep kvm_amd && echo "KVM module running" || echo "KVM module not running, verify BIOS support enabled via 'egrep '^flags.*(vmx|svm)' /proc/cpuinfo'"
[ -r /dev/kvm ] && [ -w /dev/kvm ] && echo "KVM configured" || echo "KVM permissions not configured properly, ensure user can RW /dev/kvm"

echo "in another terminal ensure the following is running"
echo 'rm -f $FIRECRACKER_SOCKET'
echo 'firecracker --api-sock "$FIRECRACKER_SOCKET"'

KERNEL="$HOME/firecracker/vmlinux.bin"
ROOTFS="$HOME/firecracker/ubuntu-18.04.ext4"
KERNEL_BOOT_ARGS="console=ttyS0 reboot=k panic=1 pci=off"
ARCH=$(uname -m)

# Set log file
curl -X PUT --unix-socket "${FIRECRACKER_SOCKET}" \
    --data "{
        \"log_path\": \"${FIRECRACKER_SOCKET}\",
        \"level\": \"Debug\",
        \"show_level\": true,
        \"show_log_origin\": true
    }" \
    "http://localhost/logger"

# Set boot source
curl -X PUT --unix-socket "${FIRECRACKER_SOCKET}" \
    --data "{
        \"kernel_image_path\": \"${KERNEL}\",
        \"boot_args\": \"${KERNEL_BOOT_ARGS}\"
    }" \
    "http://localhost/boot-source"

# Set rootfs
curl -X PUT --unix-socket "${FIRECRACKER_SOCKET}" \
    --data "{
        \"drive_id\": \"rootfs\",
        \"path_on_host\": \"${ROOTFS}\",
        \"is_root_device\": true,
        \"is_read_only\": false
    }" \
    "http://localhost/drives/rootfs"

# API requests are handled asynchronously, it is important the configuration is
# set, before `InstanceStart`.
sleep 0.015s

# Start microVM
curl -X PUT --unix-socket "${FIRECRACKER_SOCKET}" \
    --data "{
        \"action_type\": \"InstanceStart\"
    }" \
    "http://localhost/actions"

echo "Login to the microVM with"
echo 'User: root'
echo 'Pass: root'
