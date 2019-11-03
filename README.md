# Automated 1 file setup GENTOO linux

> ## BETA or much rather prototype :)

-  Intended as fully or "mostly fully ;)" unattended modular gentoo initial setup blueprint. 


## Deployment Instructions

- lorem ipsum

### EXAMPLE:
1. Deploy virtualbox gentoo minimal
2. Configure the script or run the default as study sandbox.
2. For sake of simplicity - use some paste host.
3. Fire up gentoo vm
4. wget -O awesome.sh https://....
5. tr -d '\015' < awesome.sh > deploy-gentoo.sh # convert to unix file format in case the host deploys it differently.
6. chmod +x deploy-gentoo.sh
7. ,/deploy-gentoo.sh
> Depending on variables set there will be prompted for luks & root + user passwords
> Depending on variables set kernel may requires semi manual configuration.
> Depending on variables set all kinds of bad things can happen which may lead to a failure of the entire installation - thats a true pity if you waited a couple of hours. For this reason its highly suggested to not runthe script all at once unless you know the STACK will work together, running the bottom script functions one by one may help debugging.


## OTher INFO:
- the script holds script notes and indexes (chroot index nr 391)
https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation