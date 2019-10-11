#!/bin/bash

# Check if the script is executed as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi
# END Check if you are sudo

source /home/aiden/.scripts/vfio/config

echo "Unmounting VM Partition"
# umount /dev/sdb2

# Memory lock limit
echo "Expanding Memory"
[[ $ULIMIT != $ULIMIT_TARGET ]] && ulimit -l $ULIMIT_TARGET
sleep 1

## Kill X and related
echo "Stopping Display Manager"
systemctl stop lightdm > /dev/null 2>&1
killall i3 > /dev/null 2>&1
sleep 2

# defrag ram
#echo 1 > /proc/sys/vm/compact_memory
# assign hugepages
#sysctl -w vm.nr_hugepages=8704

# Kill the console to free the GPU
echo "Killing efi-framebuffer and virtual consoles"
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
#sleep 1

# Unload the Kernel Modules that use the GPU
echo "Unloading Kernal Modules"
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia
modprobe -r snd_hda_intel
#sleep 1

# Load the kernel module
echo "Loading VFIO"
modprobe vfio
modprobe vfio_iommu_type1
modprobe vfio-pci
#sleep 1

# Detach the GPU from drivers and attach to vfio. Also the usb.
echo "Detaching GPU"
echo $videoid > /sys/bus/pci/drivers/vfio-pci/new_id
echo $videobusid > /sys/bus/pci/devices/$videobusid/driver/unbind
echo $videobusid > /sys/bus/pci/drivers/vfio-pci/bind
echo $videoid > /sys/bus/pci/drivers/vfio-pci/remove_id
#sleep 1

echo "Detaching GPU Audio"
echo $audioid > /sys/bus/pci/drivers/vfio-pci/new_id
echo $audiobusid > /sys/bus/pci/devices/$audiobusid/driver/unbind
echo $audiobusid > /sys/bus/pci/drivers/vfio-pci/bind
echo $audioid > /sys/bus/pci/drivers/vfio-pci/remove_id
#sleep 1

echo "Detaching NVME"
echo $nvmeid > /sys/bus/pci/drivers/vfio-pci/new_id
echo $nvmebusid > /sys/bus/pci/devices/$nvmebusid/driver/unbind
echo $nvmebusid > /sys/bus/pci/drivers/vfio-pci/bind
echo $nvmeid > /sys/bus/pci/drivers/vfio-pci/remove_id
#sleep 1


# QEMU (VM) command
echo "Starting QEMU"
qemu-system-x86_64 -runas aiden -enable-kvm \
    -nographic -vga none -parallel none -serial none \
    -machine q35,accel=kvm,kernel_irqchip=on \
    -m $RAM \
    -cpu host,hv_time,hv_vpindex,hv_reset,hv_runtime,hv_crash,hv_synic,hv_stimer,hv_spinlocks=0x1fff,hv_vendor_id=0xDEADBEEFFF,kvm=off,l3-cache=on,host-cache-info=off \
    -rtc clock=host,base=localtime \
    -smp cores=6,threads=2 \
    -device vfio-pci,host=$IOMMU_GPU,multifunction=on,romfile=$VBIOS \
    -device vfio-pci,host=$IOMMU_GPU_AUDIO \
    -device vfio-pci,host=$IOMMU_NVME \
    -usb \
    -device usb-host,vendorid=0x1532,productid=0x0064 \
    -device usb-host,vendorid=0x1038,productid=0x1248 \
    -device usb-host,vendorid=0x1038,productid=0x1240 \
    -device usb-host,vendorid=0xb58e,productid=0x9e84 \
    -object input-linux,id=kbd,evdev=/dev/input/kbd,grab_all=on,repeat=on \
    -drive if=pflash,format=raw,readonly,file=$OVMF \
    -drive media=cdrom,file=$VIRTIO,id=cd1,if=none \
    -device ide-cd,bus=ide.1,drive=cd1 \
    -device virtio-scsi-pci,id=scsi0 \
    -device scsi-hd,bus=scsi0.0,drive=rootfs \
    -drive id=rootfs,file=/dev/sdb,media=disk,format=raw,if=none &
    #    -mem-path /dev/hugepages
    #    -device ioh3420,id=root_port1,chassis=0,slot=0,bus=pcie.0 \
    #    -device vfio-pci,host=$IOMMU_GPU,id=hostdev1,bus=root_port1,addr=0x00,multifunction=on,romfile=$VBIOS \
    #-device vfio-pci,host=$IOMMU_GPU_AUDIO,id=hostdev2,bus=root_port1,addr=0x00.1 \
    #-device scsi-hd,drive=ssd \
    #-drive id=ssd,file=/dev/sdb,media=disk,format=raw,if=none &
    #     -net user,smb=/mnt/hdd1/WindowsDrive \
    # -net nic,model=virtio \

# END QEMU (VM) command

# Wait for QEMU to finish before continue
wait
echo "QEMU has ended"
sleep 1

# Unload the vfio module. I am lazy, this leaves the GPU without drivers
echo "Unloading VFIO"
modprobe -r vfio-pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Reload the kernel modules. This loads the drivers for the GPU
echo "Reloading kernal modules"
modprobe snd_hda_intel
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe nvidia

# Re-Bind EFI-Framebuffer and Re-bind to virtual consoles
# [Source] [https://github.com/joeknock90/Single-GPU-Passthrough/blob/master/README.md#vm-stop-script]
echo "Rebinding virtual consoles"
echo 1 > /sys/class/vtconsole/vtcon0/bind
nvidia-xconfig --query-gpu-info > /dev/null 2>&1
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

#sysctl -w vm.nr_hugepages=0

# Reload the Display Manager to access X
echo "Starting SDDM"
systemctl start lightdm
sleep 2

# Restore ulimit
echo "Resetting memory"
ulimit -l $ULIMIT

echo "Mounting VM Partition"
# mount /dev/sdb2 /mnt/vms
