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

The below command is a better option that also removes all related files and user groups. (This is a bonus, especially if a faulty user has hidden backdoors in their files and it automatically removed with the user)

> sudo deluser "username"

### Removing User from Group

This will remove a username from any group, this will be great for auditing the sudo group for unnecessary users. One of the following commands will suffice, dpeending on which system you are operating.

> sudo deluser "username" "group" <br>
> sudo userdel -G "group" "username"

example:
> sudo userdel gary sudo

### Creating Users

> sudo adduser "username"

- Note: Difference between adduser and useradd is adduser adds a home directory as well as login information Useradd just adds a user without anything by default

### Create Sudo User

> sudo usermod -aG sudo "username"

- Note: same syntax applies to adding a user to any group 

### Disable User Account 

Disable user privileges to all users except those who are authorized in the system. This is a useful command to disable someone if deleting is not an option.

> sudo usermod -L -e 1 "username"

### Change User Password

You should always change the password from the default given password.

> sudo passwd username

Make it strong and write it down somewhere (such as an excel sheet or Slack)

## Pam Files 


