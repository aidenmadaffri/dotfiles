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
if [ $(ulimit -a | grep "max locked memory" | awk '{print $6}') != $(( $(echo $RAM | tr -d 'G')*1048576+10 )) ]; then
 ulimit -l $(( $(echo $RAM | tr -d 'G')*1048576+10 ))
fi
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
echo "Detaching USB Controllers"
# echo $usbid1 > /sys/bus/pci/drivers/vfio-pci/new_id
# echo $usbbus1id > /sys/bus/pci/devices/$usbbus1id/driver/unbind
# echo $usbbus1id > /sys/bus/pci/drivers/vfio-pci/bind
# echo $usbid1 > /sys/bus/pci/drivers/vfio-pci/remove_id

# echo $usbid2 > /sys/bus/pci/drivers/vfio-pci/new_id
# echo $usbbus2id > /sys/bus/pci/devices/$usbbus2id/driver/unbind
# echo $usbbus2id > /sys/bus/pci/drivers/vfio-pci/bind
# echo $usbid2 > /sys/bus/pci/drivers/vfio-pci/remove_id

echo $usbid3 > /sys/bus/pci/drivers/vfio-pci/new_id
echo $usbbus3id > /sys/bus/pci/devices/$usbbus3id/driver/unbind
echo $usbbus3id > /sys/bus/pci/drivers/vfio-pci/bind
echo $usbid3 > /sys/bus/pci/drivers/vfio-pci/remove_id



# QEMU (VM) command
echo "Starting QEMU"
qemu-system-x86_64 -runas $USER -enable-kvm \
    -nographic -vga none -parallel none -serial none \
    -enable-kvm \
    -machine q35 \
    -m 16G \
    -cpu host,hv_time,hv_vpindex,hv_reset,hv_runtime,hv_crash,hv_synic,hv_stimer,hv_spinlocks=0x1fff,hv_vendor_id=0xDEADBEEFFF,kvm=off,l3-cache=on,host-cache-info=off \
    -rtc clock=host,base=localtime \
    -smp cores=6,threads=2 \
    -name guest=Windows \
    -global ICH9-LPC.disable_s3=1 \
    -global ICH9-LPC.disable_s4=1 \
    -global kvm-pit.lost_tick_policy=discard \
    -no-hpet \
    -device vfio-pci,host=$IOMMU_GPU,id=hostdev,multifunction=on,romfile=$VBIOS \
    -device vfio-pci,host=$IOMMU_GPU_AUDIO,id=hostdev2 \
    -device vfio-pci,host=$IOMMU_USB3 \
    -drive if=pflash,format=raw,readonly,file=$OVMF \
    -device virtio-scsi-pci,id=scsi0 \
    -device scsi-hd,bus=scsi0.0,drive=rootfs \
    -drive id=rootfs,file=/dev/sdb,media=disk,format=raw,if=none &
# qemu-system-x86_64 -runas $USER -enable-kvm \
#    
#    -device vfio-pci,host=$IOMMU_USB1 \
    #-device vfio-pci,host=$IOMMU_USB2 \
#     -nographic -vga none -parallel none -serial none \
#     -enable-kvm \
#     -machine q35 \
#     -m 16G \
#     -cpu host,hv_time,hv_vpindex,hv_reset,hv_runtime,hv_crash,hv_synic,hv_stimer,hv_spinlocks=0x1fff,hv_vendor_id=0xDEADBEEFFF,kvm=off,l3-cache=on,host-cache-info=off \
#     -rtc clock=host,base=localtime \
#     -smp cores=6,threads=2 \
#     -name guest=Windows \
#     -global ICH9-LPC.disable_s3=1 \
#     -global ICH9-LPC.disable_s4=1 \
#     -global kvm-pit.lost_tick_policy=discard \
#     -no-hpet \
#     -device vfio-pci,host=$IOMMU_GPU,id=hostdev,multifunction=on,romfile=$VBIOS \
#     -device vfio-pci,host=$IOMMU_GPU_AUDIO,id=hostdev2 \
#     -device qemu-xhci,p2=10,p3=9,id=xhci \
#     -device usb-host,vendorid=0x1532,productid=0x0064,bus=xhci.0 \
#     -device usb-host,vendorid=0x1038,productid=0x1240,bus=xhci.0 \
#     -device usb-host,vendorid=0x1038,productid=0x1248,bus=xhci.0 \
#     -device usb-host,vendorid=0x17ef,productid=0xb801,bus=xhci.0 \
#     -device usb-host,vendorid=0x04b4,productid=0x6506,bus=xhci.0 \
#     -device usb-host,vendorid=0x04b4,productid=0xb504,bus=xhci.0 \
#     -device usb-host,vendorid=0x045e,productid=0x0659,bus=xhci.0 \
#     -device usb-host,vendorid=0x0b05,productid=0x1872,bus=xhci.0 \
#     -device usb-host,vendorid=0x0b05,productid=0x185c,bus=xhci.0 \
#     -device usb-host,vendorid=0xb58e,productid=0x9e84,bus=xhci.0,port=10 \
#     -drive if=pflash,format=raw,readonly,file=$OVMF \
#     -object input-linux,id=kbd,evdev=/dev/input/by-id/usb-Corsair_Corsair_Gaming_K70_LUX_RGB_Keyboard_15007016AEFE8106583CB636F5001941-if01-event-kbd,grab_all=on,repeat=on \
#     -device virtio-scsi-pci,id=scsi0 \
#     -device scsi-hd,bus=scsi0.0,drive=rootfs \
#     -drive id=rootfs,file=/dev/sdb,media=disk,format=raw,if=none &
    #    -mem-path /dev/hugepages
    #    -device ioh3420,id=root_port1,chassis=0,slot=0,bus=pcie.0 \
    #    -device vfio-pci,host=$IOMMU_GPU,id=hostdev1,bus=root_port1,addr=0x00,multifunction=on,romfile=$VBIOS \
    #-device vfio-pci,host=$IOMMU_GPU_AUDIO,id=hostdev2,bus=root_port1,addr=0x00.1 \
    #-device scsi-hd,drive=ssd \
    #-drive id=ssd,file=/dev/sdb,media=disk,format=raw,if=none &

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

echo "Rebinding USB Controllers"
# echo $usbbus1id > /sys/bus/pci/devices/$usbbus1id/driver/unbind
# echo $usbbus1id > /sys/bus/pci/drivers/xhci_hcd/bind

# echo $usbbus2id > /sys/bus/pci/devices/$usbbus2id/driver/unbind
# echo $usbbus2id > /sys/bus/pci/drivers/xhci_hcd/bind

echo $usbbus3id > /sys/bus/pci/devices/$usbbus3id/driver/unbind
echo $usbbus3id > /sys/bus/pci/drivers/xhci_hcd/bind


# Re-Bind EFI-Framebuffer and Re-bind to virtual consoles
# [Source] [https://github.com/joeknock90/Single-GPU-Passthrough/blob/master/README.md#vm-stop-script]
echo "Rebinding virtual consoles"
echo 1 > /sys/class/vtconsole/vtcon0/bind
sleep 1
echo 1 > tee /sys/class/vtconsole/vtcon1/bind
sleep 1

#sysctl -w vm.nr_hugepages=0

# Reload the Display Manager to access X
echo "Starting SDDM"
systemctl start lightdm
sleep 2

# Restore the Frame Buffer
echo "Rebinding efi-framebuffer"
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind
sleep 1

# Restore ulimit
echo "Resetting memory"
ulimit -l $ULIMIT

echo "Mounting VM Partition"
# mount /dev/sdb2 /mnt/vms
