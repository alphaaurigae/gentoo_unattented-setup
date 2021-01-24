# Automated, modular - 1 file - setup for GENTOO linux.

### status alpha ... script runs through ... system boots with network and desktop.
> all infos in the script file!
![Reboot from CHROOT - default sample setup - XFCE4](img/scrnshts/REBOOT_DONE_1.png)
Format: ![Reboot from CHROOT - default sample setup - XFCE4](url)

## EX: Virtualbox
> have plenty of RAM, compensate for lack of RAM with SWAP (CHROOT).
![Virtualbox Motherboard RAM settings](img/scrnshts/VIRTB_1.png)
Format: ![Virtualbox Motherboard RAM settings](url)

> enable processor "true cores" .
![Virtualbox Pocessor core settings](img/scrnshts/VIRTB_1.png)
Format: ![Virtualbox Pocessor core settings](url)

> KVM as virt in order to make the hardware available in the virtual-machine.
![Virtualbox Acceleration (VIRT MODE) settings](img/scrnshts/VIRTB_1.png)
Format: ![Virtualbox Acceleration (VIRT MODE) settings](url)

> add screen memory
![Virtualbox screen memory settings](img/scrnshts/VIRTB_1.png)
Format: ![Virtualbox screen memory settings](url)

> mount CD rom img as IDE, set SSD mark if ... (add space for swap CHROOT if req) 
![Virtualbox disk settings](img/scrnshts/VIRTB_1.png)
Format: ![Virtualbox disk settings](url)

> samplenetwork -> ssh host to guest: HOST bridged to br0 ipv4 only. (wrong adapter type may prevent coonnect) | ssh ...
![Virtualbox network settings](img/scrnshts/VIRTB_1.png)
Format: ![Virtualbox network settings](url)


## GET STARTED

### Prepare the guest

> virtualbox main window after boot of the minimal image. 
![virtualbox main window after boot of the minimal image. ](img/scrnshts/intitial.png)
Format: ![virtualbox main window after boot of the minimal image. ](url)

> set variables functions in the setup script, define which functions to run ... here we only run the PRE function.... always find the wrapped up function run on the bottom of the function stack.
![set variables functions in the setup script ](img/scrnshts/sample_funct_onoff_0.png)
Format: ![set variables functions in the setup script ](url)

> virtbualbox net ... 
![virtbualbox net.  ](img/scrnshts/get_network.png)
Format: ![virtbualbox net. ](url)

> transfer the configured script with the functions to run enabled to the guest.
![transfer the configured script with the functions to run enabled to the guest. ](img/scrnshts/initial0.png)
Format: ![transfer the configured script with the functions to run enabled to the guest. ](url)

> make the script exec.
![make the script exec. ](img/scrnshts/exec.png)
Format: ![make the script exec. ](url)

> run PRE ... so we continue  with a ready partitioned and configured chroot.
![run PRE ... so we continue  with a ready partitioned and configured chroot. ](img/scrnshts/setup_chroot_pr_crypt1.png)
Format: ![run PRE ... so we continue  with a ready partitioned and configured chroot. ](url)

> there are (possible) 3 interruptions during the script ... the first is for the drive encryption (if turned on) (screenshot), 2nd for the kernel config and the 3rd for the user passwoord setup.
![there are (possible) 3 interruptions during the script .. ](img/scrnshts/VIRTB_1.png)
Format: ![rthere are (possible) 3 interruptions during the script .. ](url)

> it might be fortunate to run every section on its own and safe progress with virtualbox clones .. most of config parsing etc is automatically overwritten if a function is run twice.
> work in progress....