# Test VM (Vrtualbox)

1. Boot VM
2. ssh to VM (For direct terminal)
3. Make changes as needed ... rsync repo e.g script/copy_files_rsync.sh
4. cd gentoo_unattented-setup && run.sh -m

## General:
Type: Linux
Version: Gentoo 64bit

## System:
Base mem: 10000 MB
Chipset: PIIX3
TPM: none

Enable I/O apic - yes
Enable hardware clock  - yes

Processor 12 core

Enable PAE /NX - yes
Enable nested VT-x/amd-v

Paravirtualization interface KVM
Hardware virtualization - enable nested paging - yes


## Display
Video memory 128 MB

Graphics controller VMSCGA
Enable 3d acceleration - no

Storage 
Gentoo minimal cd

Disk
92 GB

VMDK

Solid state drive - yes

## Network

Bridged adapter

intel pro/1000 MT server