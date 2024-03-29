# FTP and SSH specific notes

## SSH

### SSH Config Files

#### /etc/ssh/sshd_config
Here are the proper settings for the ssh_config files.

1. Port <b>22</b>
2. PermitRootLogin: no
3. Max Sessions (limit sessions to you and scoring) - this will be all the authorized users, plus you
4. AuthorizedKeysFile  .ssh/authorized_keys .ssh/authorized_keys2
    - (specifies the file containing public keys for user authentication)
5. Permit Empty Passwords: no
6. PasswordAuthentication: no (if yes, then allows ssh with passwords)
7. UsePAM: yes
8. PubkeyAuthentication yes

### /etc/ssh/sshd_config.d/05-cloud-init.conf

1. PasswordAuthentication: no
**Note** SSH may be scored based on user SSHing in with password

## SSH Keys

For any user, keys are located at: ~/.ssh/authorized_keys
- public keys go here
- private keys are on your private machine
- check all authorized users for bad keys 
- backup good keys to a safe location (refer to backup section of general hardening guide)
**Note** remember to back up the /etc/shadow file as they may change passwords and if the users need to password authenticate for ssh, then this is vital (totally possible)
**NOTE** to see current ssh configs:
``
sudo sshd -T
``

### Setup SSH key
```
ssh-keygen -t rsa -b 2048 
ssh-copy-id blueteam@172.16.5.3
```


### File Permissions
- The .ssh directory should have 700 permissions 
    - (chmod 700 ~/.ssh)
- the authorized_keys file should have 600 permissions 
    - (chmod 600 ~/.ssh/authorized_keys)

## File Transfer Protocol
runs on these ports:
1. 20: data port
2. 21: command prot
make sure these are allowed through the firewall

### VSFTPD
we will be scored on read and write from this conf file

Conf file: /etc/vsftpd.conf

you will also need to install and enable FTP

```
Sudo apt install vsftpd
sudo systemctl start vsftpd 
sudo systemctl enable vsftpd
```

1. need to mount the drive in <b>/mnt</b>
2. enable read in conf 

### Conf File Config
1. connect_from_port_20=YES
2. anon_upload_enable=NO
3. anon_mkdir_write_enable=NO
4. write_enable=YES
5. anonymous_enable=NO

Make sure you back this file up to a safe location BEFORE modifying it and after getting it working. 

### Directory Permissions
certain directories will contain the files that need to be accessed via FTP, in order to do so, they must have the correct permission

```
sudo chown -R ftpuser:ftpuser /path/to/ftp/directory
sudo chmod -R 760 /path/to/ftp/directory
```

Replace ftpuser with the actual username and /path/to/ftp/directory with the path to the directory you want to share.

### Connecting with an FTP user
1. connect to the server
- sudo ftp [IP address]
- enter username andpassword
2. To add a file to remote host 
- Start FTP connection from dir where the file is
- put <file.name>
3. To copy a file to local host
- Start FTP connection from dir where the file is
- get <file.name>

https://phoenixnap.com/kb/install-ftp-server-on-ubuntu-vsftpd

1. need to add mounting files
2. switching to ftps
3. chroot allow list 
4. search red team site
7. files go in /FTP in root directory
- make ftp group
- assign all users to it 

### Static IP location
sudo nano /etc/netplan/01-netcfg.yaml
sudo netplan apply

## Firewalls and FTP
sudo su = change to root
ufw will mess up ftp in passive mode as the data port is randomly assigned and not the specific 21
- restrict by ip address
```
sudo ufw allow from 172.16.0.2 to any port 1024:65535
sudo ufw deny 1024:65535
check /var/log to get the ip address of the scorer
```