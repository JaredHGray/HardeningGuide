# General Guide to System Hardening 

## Users 
### /etc/passwd

Check that the users that have a shell login. Make sure that there are no system users on this list and any usernames that look suspicious.

> sudo cat /etc/passwd | grep -E
> <span style="color:green;">"bin/bashlbin/sh/l/bin/cshl/bin/tcshl/bin/kshl/bin/dashl/bin/zshl/usr/bin/fish"</span>

File permissions on the <span style="color:green;">/etc/passwd</span> file should be <span style="color:green;">-rw-r--r--</span> or <span style="color:green;">644.</span>

### /etc/shadow 

Check the <span style="color:green;">/etc/shadow</span> file to see which users have passwords. All system users should be formatted <span style="color:green;">username:*:</span> etc. If you see username:: then place a <span style="color:green;">\*</span> or <span style="color:green;">!</span> there to stop that user from logging in without a password.

The root account should also be disabled so no one can log into it. The root account should start <span style="color:green;">root:*:</span> or <span style="color:green;">root:!:</span>.

> sudo cat /etc/shadow | grep root

Check for users without a password

> sudo cat /etc/shadow | grep awk -F: '($2==""){print $1}'

File permissions on the <span style="color:green;">/etc/shadow</span> file should be <span style="color:green;">-rw-r--1---</span> or <span style="color:green;">644</span>.

### /etc/group

The main thing to check is who the sudo users are.

> cat /etc/group | grep sudo

If you are using centos, there is a group called <span style="color:green;">wheel</span>, and the member of this group are granted sudo permissions, so check this group too.

File permissions on the <span style="color:green;">/etc/group</span> file should be <span style="color:green;">-rw-r--1---</span> or <span style="color:green;">644</span>.

### sudoers 

It's also worth checking the <span style="color:green;">sudoers</span> file to make sure no groups or users have been given sudo permissions.

> sudo visudo 

Generally, the only three you should see are:
> root	ALL=(ALL:ALL) ALL <br>
> %admin ALL=(ALL) ALL <br>
> %sudo	ALL=(ALL:ALL) ALL

There will also be a few <span style="color:green;">Defaults</span> at the top of the file but checking the bottom is the most important.

### Deleting Users

The <span style="color:green;">-r</span> flag will also remove their home directory.

> sudo userdel -r  "username"

### Removing Sudo User


