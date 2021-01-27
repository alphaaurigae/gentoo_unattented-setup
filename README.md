# Automated, modular - 1 file - setup for GENTOO linux.
- 1 file configurable setup script for a automated - unattended & modular gentoo linux system installation. 
> all infos in the script file!
![Reboot from CHROOT - default sample setup - XFCE4](img/scrnshts/REBOOT_DONE_1.png)

## EX: Virtualbox (> v6.*).
> have plenty of RAM, compensate for lack of RAM with SWAP (CHROOT).
![Virtualbox RAM .](img/scrnshts/VIRTB_1.png)

> enable processor "true cores" .
![Virtualbox Pocessor](img/scrnshts/VIRTB_2.png)

> KVM as virt in order to make the hardware available in the virtual-machine.
![Virtualbox Acceleration.](img/scrnshts/VIRTB_3.png)

> add screen memory.
![Virtualbox screen memory settings](img/scrnshts/VIRTB_4.png)

> mount CD rom img as IDE, set SSD mark if ... (add space for swap CHROOT if req.) 
![Virtualbox disk.](img/scrnshts/VIRTB_5.png)

> samplenetwork -> ssh host to guest: HOST bridged to br0 ipv4 only. (wrong adapter type may prevent coonnect) | ssh ...
![Virtualbox network.](img/scrnshts/VIRTB_6.png)


## GET STARTED

### Prepare the guest

> virtualbox main window after boot of the minimal image. 
![virtualbox main window... ](img/scrnshts/intitial.png)

> set variables functions in the setup script. define which functions to run ... here we only run the PRE function.... always find the wrapped up function run on the bottom of the function stack.
![set variables functions in the setup script.](img/scrnshts/sample_funct_onoff_0.png)

> virtbualbox net.
![virtbualbox net.](img/scrnshts/get_network.png)

> transfer the configured script with the functions to run enabled to the guest.
![transfer the configured script.](img/scrnshts/initial0.png)

> make the script exec.
![make the script exec. ](img/scrnshts/exec.png)

> run PRE ... continue with a ready partitioned and configured chroot.
![run PRE ... continue...](img/scrnshts/setup_chroot_pr_crypt0.png)

> there are (possible) 3 interruptions during the script ... the first is for the drive encryption (if turned on) (screenshot), 2nd for the kernel config and the 3rd for the user passwoord setup.

> it might be fortunate to run every section on its own and safe progress with virtualbox clones .. most of config parsing etc is automatically overwritten if a function is run twice.

> work in progress....
