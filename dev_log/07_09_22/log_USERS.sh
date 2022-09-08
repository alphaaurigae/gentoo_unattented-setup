-_-_-_-_-_-_-_,------,
_-_-_-_-_-_-_-|   /\_/\
-_-_-_-_-_-_-~|__( ^ .^)
-_-_-_-_-_-_-""  ""
02:54:53 [a@a-System-Product-Name:~/Desktop]$ ssh root@192.168.178.198
Password: 
Welcome to the Gentoo Linux Minimal Installation CD!

The root password on this system has been auto-scrambled for security.

If any ethernet adapters were detected at boot, they should be auto-configured
if DHCP is available on your network.  Type "net-setup eth0" to specify eth0 IP
address settings by hand.

Check /etc/kernels/kernel-config-* for kernel configuration(s).
The latest version of the Handbook is always available from the Gentoo web
site by typing "links https://wiki.gentoo.org/wiki/Handbook".

To start an ssh server on this system, type "/etc/init.d/sshd start".  If you
need to log in remotely as root, type "passwd root" to reset root's password
to a known value.

Please report any bugs you find to https://bugs.gentoo.org. Be sure to include
detailed information about how to reproduce the bug you are reporting.
Thank you for using Gentoo Linux!

livecd ~ # cd gentoo_unattended-setup/
livecd ~/gentoo_unattended-setup # ./run.sh 
 source ... START ... 
 SOURCE_CHROOT ... START ... 
>>> Regenerating /etc/ld.so.cache...
SOURCE_CHROOT  ... END ... 
enter new root password

You can now choose the new password or passphrase.

A valid password should be a mix of upper and lower case letters, digits, and
other characters.  You can use a password containing at least 7 characters
from all of these classes, or a password containing at least 8 characters
from just 3 of these 4 classes.
An upper case letter that begins the password and a digit that ends it do not
count towards the number of character classes used.

A passphrase should be of at least 3 words, 11 to 72 characters long, and
contain enough different characters.

Alternatively, if no one else can see your terminal now, you can pick this as
your password: "Worse*Bulb-Flimsy".

Enter new password: 
Weak password: not enough different characters or classes for this length.
Try again.

You can now choose the new password or passphrase.

A valid password should be a mix of upper and lower case letters, digits, and
other characters.  You can use a password containing at least 7 characters
from all of these classes, or a password containing at least 8 characters
from just 3 of these 4 classes.
An upper case letter that begins the password and a digit that ends it do not
count towards the number of character classes used.

A passphrase should be of at least 3 words, 11 to 72 characters long, and
contain enough different characters.

Alternatively, if no one else can see your terminal now, you can pick this as
your password: "eight&pastel!viola".

Enter new password: 
Re-type new password: 
passwd: password updated successfully
groupadd: group 'plugdev' already exists
groupadd: group 'adm' already exists
groupadd: group 'audio' already exists
Creating mailbox file: No such file or directory
enter new admini password

You can now choose the new password or passphrase.

A valid password should be a mix of upper and lower case letters, digits, and
other characters.  You can use a password containing at least 7 characters
from all of these classes, or a password containing at least 8 characters
from just 3 of these 4 classes.
An upper case letter that begins the password and a digit that ends it do not
count towards the number of character classes used.

A passphrase should be of at least 3 words, 11 to 72 characters long, and
contain enough different characters.

Alternatively, if no one else can see your terminal now, you can pick this as
your password: "Atlas5hymn4champ".

Enter new password: 
Re-type new password: 
passwd: password updated successfully
groupadd: group 'vboxguest' already exists
Adding user admini to group vboxguest
end chroot
livecd ~/gentoo_unattended-setup # 
