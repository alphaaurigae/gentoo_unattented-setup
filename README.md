# Automated, modular - 1 file - setup for GENTOO linux.
- 1 file configurable setup script for a automated - unattended & modular gentoo linux system installation. 

> all infos in the script file!
![Reboot from CHROOT - default sample setup - XFCE4](img/scrnshts/REBOOT_DONE.png)

## EX: Virtualbox (> v6.*).
### Host VB settings for the guest

> <p> RAM, compensate for lack of RAM with SWAP 'CHROOT'.</p>
![<p>RAM.</p>](img/scrnshts/VIRTB_1.png)

> <p> enable processor "true cores".</p>
![<p>Pocessor.</p>](img/scrnshts/VIRTB_2.png)

> <p> KVM acceleration for the virt.</p>
![<p>Acceleration.</p>](img/scrnshts/VIRTB_3.png)

> <p> add screen memory.</p>
![<p>Screen mem.</p>](img/scrnshts/VIRTB_4.png)

> <p> mount CD rom img as IDE. </p>
![<p>Disk.</p>](img/scrnshts/VIRTB_5.png)

> <p> samplenetwork ->  HOST bridged to br0 ipv4 only.</p>
![<p>Network.</p>](img/scrnshts/VIRTB_6.png)


## GET STARTED

### Prepare the guest

> <p>virtualbox main window after boot of the minimal image.</p>
![<p>Main window...</p> ](img/scrnshts/intitial.png)

> <p>set variables / functions in the setup script. define which functions to run.</p>
![<p>Variables  / functions</p>](img/scrnshts/sample_funct_onoff_0.png)

> <p>virtbualbox net.</p>
![<p>Net.</p>](img/scrnshts/get_network.png)

> <p>transfer the configured script with the functions to run enabled to the guest.</p>
![<p>Transfer script.</p>](img/scrnshts/initial0.png)

> <p>make the script exec.</p>
![<p>Make the script exec. </p>](img/scrnshts/exec.png)

> <p>run PRE ... continue with a ready partitioned and configured chroot.</p>
![<p>Run "PRE"</p></p>](img/scrnshts/setup_chroot_pr_crypt0.png)

> <p>there are (possible) 3 interruptions during the script ... the first is for the drive encryption (if turned on) (screenshot), 2nd for the kernel config and the 3rd for the user passwoord setup.</p>

> <p>it might be fortunate to run every section on its own and safe progress with virtualbox clones .. most of config parsing etc is automatically overwritten if a function is run twice.</p>

> <p>work in progress....</p>
