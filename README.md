# **Arch Linux Installation and Hyprland Setup Guide**

---

DISCLAMER! This is a guide for my personal setup for me to practice writing documentation and to recreate my setup when re-installing. DO NOT follow if you dont know what you're doing.

---

## **1. Install Arch Linux**

### **Set Keyboard Layout and Timezone**
```bash
loadkeys no
timedatectl set-timezone Europe/Oslo
```

### **Disk Partitioning**

```bash
fdisk /dev/nvme0n1
```
#### **Delete previous partitions**
THIS WILL DELETE ALL YOU DATA!
1. Press `d` to delete partitions.
2. Press `w` to write changes.

#### **Create `EFI System` partition**
1. Press `g` to create a new GPT partition table.
2. Press `n` for a new partition.
3. Partition number `1` or `default`.
4. First sector `2048` or `default`.
5. Last sector `+1G`.
6. Press `t` to change partition type.
7. Partition type `1` for `EFI System`.

#### **Create `Linux swap` partition**
1. Press `n` for a new partition.
2. Partition number `2` or `default`.
3. First sector `default`.
4. Last sector `+4G`.
5. Press `t` to change partition type.
6. Partition number `2` or `default`.
7. Partition type `19` for `Linux swap`.

#### **Create `Linux root (x86-64)` partition**
1. Press `n` for a new partition.
2. Partition number `3` or `default`.
3. First sector `default`.
4. Last sector `default`.
5. Press `t` to change partition type.
6. Partition number `3` or `default`.
7. Partition type `23` for `Linux root (x86-64)`.

##### **Press `w` to write all changes**

#### **Format the partitions**

Create a Ext4 file system on root partition.
```bash
mkfs.ext4 /dev/nvme0n1p3
```

Initialize swap.
```bash
mkswap /dev/nvme0n1p2
```

Format EFI System to FAT32.
```bash
mkfs.fat -F 32 /dev/nvme0n1p1
```

### **Mount the file systems**
Mount the root volume to /mnt.
```bash
mount /dev/nvme0n1p3 /mnt
```

Mount the EFI system partition.
```bash
mount --mkdir /dev/nvme0n1p1 /mnt/boot
```

Enable swap.
```bash
swapon /dev/nvme0n1p2
```

## **Install essential packages**
```bash
pacstrap -K /mnt base linux linux-headers linux-firmware grub amd-ucode sudo nano nvidia nvidia-utils networkmanager
```
## **Fstab**
Fstab

Generate an fstab file.

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

## **Chroot**

Change root into the new system:
```bash
arch-chroot /mnt
```
## **2. Bootloader**
Grub is installed now let's configure it.




