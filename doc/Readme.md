# Documenting the setup
## THIS PAGE NEEDS AN UPDATE 03.09.2022

TODO: https://github.com/alphaaurigae/gentoo_unattented-setup/tree/master/doc/TODO

 > configurable setup script for a automated - unattended & modular gentoo linux system installation. 

 > https://github.com/alphaaurigae/gentoo_unattented-setup


> quick virt setup for testing:


## SAMPLE (THIS PART NEEDS AN UPDATE 03.09.2022

- find the CHROOT.sh for the chroot setup in /src ... paste to run.sh in / repo.

- find the configs in "config/required/default-testing/" , eventually edit and paste to the main script "run.sh" --> in place of " [ !PASTE_DEF_CONFIG ... ] "
> there are 3 places for default configs / variables to be copy pasted.
1. !PASTE_DEF_CONFIG copy paste content of "config/required/default-testing/1_ variables_pre.default-testing.sh" --> TO: "run.sh --> EDITOR [ !PASTE_DEF_CONFIG VARIABLES_1 ...]
- variables for the pre setup.
2. !PASTE_DEF_CONFIG copy paste content of "2_variables_chroot_default-testing.sh" --> TO: "run.sh" --> EDITOR [ !PASTE_DEF_CONFIG VARIABLES_2 ...]
- combined with the variables for the pre setup .. these setup everything for the chroot.
3. !PASTE_DEF_CONFIG copy paste content of "kernel_.config_default-testing.sh (template of /usr/src/linux/.config" to be pasted during setup) --> TO: "run.sh" --> EDITOR [ !PASTE_DEF_CONFIG the linux kernel configuration file (there are options to work off default configs - see var)
- you still get a menuconfig by default, but based on the premade config. there are more optiosn for kernel setup.

- work in progress! 24.01.2021# Automated, modular - 1 file - setup for GENTOO linux.


![Reboot from CHROOT - default sample setup - XFCE4](img/scrnshts/REBOOT_DONE.png)


### I:
1. config variables - default settings should do for a testrun.
2. IF VIRT GUEST may w sufficient RAM (test system has 32G RAM, where 25 are for the guest) and possibly KVM to avoid flag conflics (!NOTE: ex firefox avx2 err).

### II:
#### sample 1:
1. deploy virtualbox gentoo minimal ISO
2. wget -O awesome.sh https://....
3. tr -d '\015' < awesome.sh > deploy-gentoo.sh # convert to unix file format, in case the host deploys it differently.

#### sample 2:
1. deploy virtualbox gentoo minimal ISO
2. depending on the network change virtualbox network adapter settings - sample here has host with bridge and guest with bridged adapter,
3. passwd root
4. run ssh serv
5. scp gentoo_unattented_modular-setup.sh root@x.x.x.x:run.sh

### III:
1. chmod +x run.sh
2. prepare to be prompted for cryptsetup password setup, youll need this a little later to unlock the luks container for the CHROOT!. see relevant sections for details.
3. have dinner, this may take a long while.
4. kernel setup will require interaction! w the default setup the included config (cryptsetup settings included) will be parsed and updated with menuconfig. make changes and save ,(!NOTE: youll also be prompted for kernel updates not included in the config yet - hit yes ffor default values)
5. this may take another while, desktop and apps will be installed before the next stop. may have another dinner - firefox alone takes 40 minutes on a ryzen threadripper 1920x to build.
6. user password will be asked for the future root and admin (user) account.

> !IMPORTANT
1.0 SECTIONS: depending on variables set all kinds of bad things can happen which may lead to a failure of the entire installation - thats a true pity if you waited a couple of hours. ... ->
1.1 ... for this reason its highly suggested to not run the script all at once, unless you know the STACK will work together, use the script sections at the bottom of each section to comment /uncomment:
2.0 SAVE SESSION: virtualbox has a neat function to save the session, to debug it may be fortunate to simply always have a clone of the guest.
3.0 IO: having decent IO capacity (fast, redundant drives) will greatly aid the build speed.
4.0 SWAP: theres a function for a swap file to solve RAM problems. add this to the disk size calc.
5.0 RAM: dev sys 32 gb where 25 for guest.

## Screenshot ex

### EX: Virtualbox (> v6.1).


#### HOST: 
- network: bridged br0 ipv4
#### GUEST: 
> <p> 1_virtualbox_general_basic</p>
![<p>1_virtualbox_general_basic</p>](img/screenshots/virtual_machine/virtualbox/1_virtualbox_general_basic.png)

> <p> 2_virtualbox_motherboard</p>
![<p>2_virtualbox_motherboard</p>](img/screenshots/virtual_machine/virtualbox/2_virtualbox_motherboard.png)

> <p> 3_virtualbox_system_processor</p>
![<p>3_virtualbox_system_processor</p>](img/screenshots/virtual_machine/virtualbox/3_virtualbox_system_processor.png)

> <p> 4_virtualbox_system_acceleration</p>
![<p>4_virtualbox_system_acceleration</p>](img/screenshots/virtual_machine/virtualbox/4_virtualbox_system_acceleration.png)

> <p> 5_virtualbox_display_screen </p>
![<p>5_virtualbox_display_screen</p>](img/screenshots/virtual_machine/virtualbox/5_virtualbox_display_screen.png)

> <p> 6_virtualbox_storage_storage</p>
![<p>6_virtualbox_storage_storage</p>](img/screenshots/virtual_machine/virtualbox/6_virtualbox_storage_storage.png)

> <p> 7_virtualbox_network_adapter1</p>
![<p>7_virtualbox_network_adapter1</p>](img/screenshots/virtual_machine/virtualbox/7_virtualbox_network_adapter1.png)


#### MORE INFO:
- https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation
- https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation
- https://wiki.gentoo.org/wiki/Security_Handbook/Full


### THIS PART NEEDS AN UPDATE 03.09.2022
## GET STARTED

### Prepare the guest
