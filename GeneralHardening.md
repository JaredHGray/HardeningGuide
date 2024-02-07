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

The <span style="color:green;">/etc/pam.d</span> directory contains the files the system will run to authenticate users but also steal passwords and do a host of other malicious things. Check all the files in the directory but especially the <span style="color:green;">common-auth</span> file.

<b>WARNING:</b> If you accidentally remove something that should be there you can brick the entire system so be sure of what you are changing and if you have any doubt ask someone to look at it before you make any changes.


## File and Directory Permissions

Linux has 3 parts:

Read (r) = 4 Write (w) = 2 Execute (x) =1

The number used is calculated by adding up the individual number of the desired file permissions. If I wanted only read and execute then it would be 4+ 1 which is 5.

The first number is for the file owner, the next for others in the owner's group and the last is for everyone else.

<b>File Permissions</b>

> sudo chmod (0-7)(0-7)(0-7) filename

<b>Directory Permissions</b>

> chmod (0-7)(0-7)(0-7) directoryName

When in doubt, google what the default file(or directory) permissions should be. One way they will mess with us is changing these permissions so we can't be scored. 

Command to view permissions:

> sudo ls -la

### Changing File and Directory Ownership

Sometimes we need to correct who owns a file or directory, whether that be person or group. You can see who owns a file with the previously listed command. To change ownership, use the following command:

> sudo chown newuser:newgroup file/directory

If you only want to change the owner without modifying the group, you can omit the ":newgroup" part

## Logs

Check which logs are being logged.

> sudo cat /etc/rsyslog.d/50-default.conf

Log file locations:

> /var/log/message - Whole system logs or current activity logs are available <br>
> /var/log/auth.log - Authentication logs <br>
> /var/log/kern.log - Kernel logs <br>
> /var/log/cron.log - Cron job logs <br>
> /var/log/boot.log - System boot log <br>
> /var/log/apt - Apt package manager logs <br>

Log files can be very long so limiting how much to view is a good idea.

Tail will show the last 10 lines by default.

> tail filename

Or you can add a <span style="color:green;">-n</span>flag to show more or less

> tail -20 filename

## Aliases 

Sometimes a system is already made to have commands that do malicious executions. This will print all the <span style="color:green;">./bashrc</span> files for all the users.

You can either manually examine the <span style="color:green;">.bashrc</span> files for each user in their home directory 

> sudo nano .bashrc

Or run a script that prints out the bashrc files for each user, an example would be:

> for user in $(cut -fl -d: /etc/passwd); do echo $user; sudo cat /home/$user/.bashrc; done

After changing a <span style="color:green;">.bashrc</span> file run:

> sudo source ~/.bashrc

- Note: You will have to be logged in as that user to run the <span style="color:green;">source </span>command or use <span style="color:green;">sudo</span>.

## Firewall

Warning: If you are using an ssh connection to access the machine, allow port 22 before you enable the firewall.

Anything that is not allowed by the firewall will be denied by default unless the setting has been changed. Also, note that this only applies to traffic originating from outside the machine. If the traffic originates from the machine it will be allowed out.

Check the firewall status

> sudo ufw status

Turn on the firewall

> sudo ufw <span style="color:yellow;">enable</span>

To find current services/applications that would be allowed

> sudo ufw app list 

Allow a port or service through the firewall

> sudo ufw allow \<port> <br>
> sudo ufw allow \<service>

Deny a port or service

> sudo ufw deny \<port> <br>
> sudo ufw deny \<service>

Add rules to block traffic by IP address

> sudo ufw deny from \<VM IP address> to \<Attack Machine IP> <br>
> sudo ufw deny from \<Attack Machine IP> to \<VM IP address>

Block all traffic in and out

> sudo ufw default deny incoming <br>
> sudo ufw default deny outgoing

- <b>WARNING:</b> Running these commands will block all traffic in and out of the machine. Only run these commands if you have physical access to the machine or the VM console.

> sudo iptables -P INPUT DROP <br>
> sudo iptables -P OUTPUT DROP

## SSH 

### Check SSH keys

Check the <span style="color:green;">/etc/ssh/sshd_config</span> file to see where ssh keys are being stored.

> sudo cat /etc/ssh/sshd_config | grep AuthorizedKeysFile

Note: this command relies on all keys being found in the <span style="color:green;">authorized_keys</span> file which is where they are stored for each user by default. If the above command shows another file path modify the following command accordingly.

Here is an example script to obtain all keys stored in the  <span style="color:green;">authorized_keys</span> file:

> for user in $(cut -fl -d: /etc/passwd); do echo $user; sudo cat /home/$user/.ssh/authorized_keys; done

### SSH Configuration

In the <span style="color:green;">/etc/ssh/sshd_config</span> file make the following changes

```
Port 1337 
PasswordAuthentication no PermitEmptyPasswords no 
PermitRootLogin no 
MaxAuthTries 3
MaxSessions 1
AllowUsers Usernamel, Username2, etc DenyUsers Usernamel, Username2, etc
```

- <b>WARNING:</b> When you set the <span style="color:green;">AllowUsers</span> property make sure to add your user to it and test it before you end your current ssh session.

After making any changes to the <span style="color:green;">/etc/ssh/sshd_config</span> file, restart the ssh service

> sudo service ssh restart

The above command may vary, depending on your assigned machine; adjust accordingly 

Change the file permissions and file owner to help increase the integrity of the file

```
sudo chown root:root /etc/ssh/sshd_config 
sudo chmod 600 /etc/ssh/sshd_config
```

Use ssh with a non standard port number
> ssh user@ip -p \<port_number>

(remember we changed the port number to <b>1337</b>?)

example:
> ssh gary@10.10.142.21 -p 1337

### Kill Specific SSH Session

The terminal id should look something like <span style="color:green;">pts/1</span>

> pkill -9 -t \<terminal id>

Another option is to kill an SSH session by username

> sudo pkill -9 -u USERNAME ssh

### Kill all SSH Sessions

> sudo pkill -9 sshd

### Disable SSH

> sudo systemctl stop ssh

### Generating SSH keys

<b>Warning:</b> Do NOT generate the key on the system you want to use that key to log into. Generate it on the computer you will initiate the ssh connection from

> ssh-keygen

After the key has been generated use the scp command to copy the PUBLIC key to the remote machine.

```
cat  ~/.ssh/id_rsa. pub I ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## Cronjobs

Cronjobs are a great way to hide and run scripts on a schedule, so make sure to check ALL the user's cronjob files. Remove anything that looks suspicious

Note: This needs to be run from the root account

```
for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l; done
```

In addition to each user having a crontab, there is also one for the system that is located in <span style="color:green;">/etc/crontab</span> and <span style="color:green;">/etc/cron.d</span>

```
sudo nano /etc/crontab 
sudo nano /etc/cron.d
```

### General Cron Commands

Edit the crontab of a user

> sudo crontab -u username -

List the crontab of a user

> sudo crontab -u username -l

Delete unnecessary files within local authorized users

> ls -R /home/\*

## Services

Check for potentially malicious packages

Top 10 malicious packages to check for

- Burp Suite
- Nmap
- Wireshark
- Metasploit Framework
- aircrack-ng
- Netcat
- John the Ripper
- sqlmap
- Autopsy

> dpkg --get-selections | grep package

### Removing a Service

```
sudo apt remove package 
sudo apt purge package 
sudo apt clean
sudo apt autoremove
```

### Other Service Things 

Also, check the <span style="color:green;">/opt</span> and <span style="color:green;">/tmp</span> directory for anything suspicious 

Make sure to install <span style="color:green;">nano</span> if you are missing it and are not comfortable using <span style="color:green;">vi</span> to edit files

> sudo apt install nano

## Patching

One of the first things you should always do is update and upgrade the installed packages. However, before doing that check where it is pulling updates from, the <span style="color:green;">/etc/apt/source.list</span> contains this list

> cat /etc/apt/sources.list

If your /etc/apt/sources.list file is corrupted, you can typically fix it by replacing it with a correct and valid configuration. Here are steps to help you restore your sources.list file:

<b>Backup Your Current File:</b>

Before making any changes, it's a good practice to create a backup of your existing sources.list file.

> sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

<b>Create a New sources.list File:</b>

You can manually create a new sources.list file using a text editor. Here's a basic example:

> sudo nano /etc/apt/sources.list

Inside the editor, you can add repository lines appropriate for your distribution. You can find example repository configurations for your specific distribution on the official distribution website.

For Debian, you might have something like:

```
deb http://deb.debian.org/debian/ buster main
deb-src http://deb.debian.org/debian/ buster main
```
For Ubuntu, you might have something like:

```
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
```

Ensure that you add the appropriate repository lines based on your distribution version.

<b>Update APT:</b>

After creating the new sources.list file, save the changes and exit the text editor. Then, update APT to refresh the package lists.

> sudo apt update

This command will read the new sources.list file and update the package information.

<b>Check for Errors:</b>

After running sudo apt update, check for any error messages. If there are errors related to your repository configuration, revisit the sources.list file and make sure the entries are correct.

If there are still issues, you might want to consider using a tool like apt-secure or checking the APT logs (/var/log/apt/) for more detailed information about the errors.

By following these steps, you should be able to fix a corrupted /etc/apt/sources.list file. Always be cautious when editing system configuration files and ensure that the repository URLs are accurate for your distribution and version.

Once verified your source files aren't corrupted, update and upgrade the system

> sudo apt  update -y && sudo apt upgrade -y

### Pinned Packages 

Pinned packages are those that have been marked as manually installed or held at a specific version, preventing them from being upgraded.

To check for manually installed packages:

> apt-mark showmanual

To check for held packages (those with a specific version):

> apt-mark showhold

This command will display a list of packages that have been held at a specific version.

If there are no pinned packages, these commands will not output anything.

Unpinning a Manually Installed Package:

> sudo apt-mark unmarkauto package_name

Unpinning a Held Package

> sudo apt-mark unhold package_name

## Vulnerability Scanning

One option to approaching this challenge is to scan your system for vulnerabilities using a tool such as <span style="color:green;">OpenVAS</span> or <span style="color:green;">Nessus</span>

This will take awhile to install, but might be worth it. Here is the code to install OpenVAS:

```
sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y
sudo apt install openvas gvm-setup
```

Check that the installation worked

> gvm-check-setup

## Backups

REMEMBER to back EVERYTHING up! Whenever you make changes to files, make sure to backup before AND after making changes. This way if the channges you implement mess up your system, you can revert back and if the changes you implement are messed up by the RED team, you can revert back.

Here are a few methods to do so:

### Snapshots

Take regular snapshots of your VM to ensure your changes are protected and you can revert back to a previous state if needed

Steps:
```
- Click on the "Snapshots" tab for the selected VM.
- Click the "Take Snapshot" button.
- Provide a name for the snapshot (e.g., "Snapshot-1").
    - make sure to timestamp your name so you know when it was taken!
- You can also add a description (highly recommended).
- Click the "Take Snapshot" button to create the snapshot.
```

- Once the snapshot is created, you will see it listed in the "Snapshots" tab.
- You can view details, restore, delete, or revert to the snapshot from this interface.

### Secure Copy

When making a change to a config file make a backup of the file to the backup server. Make sure to timestamp the file when you move it so we have a history of config files and don't just have the last version.

> scp  remoteuser@remoteIP:~/file/path/filename  ~/file/path/to/move/it/to

### Copies Within System

A quick and dirty method for making copies is to just makes copies of a file on your VM. This method isn't very secure because if Red team has access to the system then they can delete these backups or see when you make them via logs. However, this method is best utilitzed when editing files for a quickl revert, especially when you mess up. It is not recommended for perserving good copies of files, but rather as a backup for messing up during editing. 

An example would be editing /etc/passwd and accidentally deleting an authorized user. You use your dirty copy to fix the mistake

> cp ~/file/path/filename  ~/file/path/to/move/it/to

If you want to try to be sneaky, store the files in random places on the system. Make sure to write down where you stored them! Then restrict access to the <span style="color:green;">/logs</span> directory to a specific group you are in and no one else

> sudo chown :yourgroup /logs

Set the permissions to allow the group to access the directory but deny access to others.

> sudo chmod 770 /logs

Add users to the group that you've created. Replace "username" with the actual username and "yourgroup" with the group name.

> sudo usermod -aG yourgroup username

