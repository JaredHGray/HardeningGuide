s# Service Requirements

NOTE: Any instance of <T> represents your team number. For example, if you're on Team 1, 172.18.13.<T> translates to 172.18.13.1

## Router 

The router should return an ICMP request on the external WAN IP of `172.16.4.<T>`

## WWW

WWW will be regarded as functioning if a request can be made to your router and return the webpage with a 200 status code.


## WWW Content

Note that all Web checks are scored through the router.

- The website title correctly reads `Test Blog - Betterblog`
- A user can log in using the credentials `blackteam:External6-Gerbil-Kinship-Cavity` 
- There are no warnings or errors on the website
-  A user can create, update, read, and delete a blog post

## SSH

To score points for SSH all of the users in the table below must be able to access the server using their SSH key. You will be given the public keys that are needed for these users.

### Users

- amandataylor
- christopherlee
- davidbrown
- emilyjohnson
- jessicamiller
- josephmartin
- matthewyoung
- michaelclark
- robertharris
- sarahsmith
- andrewanderson
- danieldavis
- elizabethmoore
- jenniferwhite
- johndoe
- lisawilson
- meganroberts
- oliviahall
- samanthaallen
- williamjones 

## DNS

DNS should be available internally at `192.168.<T>.2`
DNS should be available externally at `172.16.4.<T>`
DNS Forward lookups for the following domain names point to the corresponding IP.
DNS Reverse lookups for the following IP Addresses point to the corresponding domain name

### Required Domains

|DNS Address |  IP |    Description |
| -- | ------- | ------ |
| ns1.team\<T>.cyberjousting.org | 172.16.4.\<T> | Public DNS Nameserver |
| www.team\<T>.cyberjousting.org | 172.16.4\<T> | Public Web Nameserver |
| shell.team\<T>.cyberjousting.org | 172.16.5.\<T> | Public SSH server |
| files.team\<T>.cyberjousting.org | 172.16.5.\<T> | Public File Share |
| ns1.team\<T>.net | 192.168.\<T>.2 | Internal Alias for DNS Server |
| www.team\<T>.net | 192.168.\<T>.3 | Internal Alias for Web server |
| db.team\<T>.net  | 192.168.\<T>.4 | Internal Alias for MySQL server |


The above addresses containing `.cyberjousting.org` should be publicly available and will be scored through the router, and checked for both forward and reverse lookups.

The above addresses containing `.team\<T>.net` will be scored from inside the internal network and checked for both forward and reverse lookups.


## FTP

All FTP scoring users must be able to log in, read, and write files. The files must keep the same file hash to be considered correct. The hash for the users is `$6$mWgVY9GDGccWAPPX$v7kDifzlJyTiqrHycaZyLw3u7NAmR.UZMG/x5ZuoiOC60sE6AyWuI3gEzA8zAjvqCOcLADGqXSFjyTyRGLlls0`.

FTP - Users must be able to log in using their password.
FTP Write - Users must be able to write/upload files to the FTP server in the `/FTP` directory.
FTP Read - The user must be able to read/download files from the server with the correct content.

### Users 

- amandataylor
- christopherlee
- davidbrown
- emilyjohnson
- jessicamiller
- josephmartin
- matthewyoung
- michaelclark
- robertharris
- sarahsmith
- andrewanderson
- danieldavis
- elizabethmoore
- jenniferwhite
- johndoe
- lisawilson
- meganroberts
- oliviahall
- samanthaallen
- williamjones 

### FTP Files:

- file_1.txt
- file_2.txt
- file_3.txt
- file_4.txt
- file_5.txt
- file_6.txt
- file_7.txt
- file_8.txt
- file_9.txt
- file_10.txt

Backup copies of these files can be found in the zip folder `FTPFiles.zip`


## MySQL

- The MySQL Scoring user can log into MySQL
- The MySQL Scoring user can log in, read, and write to the database betterblog
- The MySQL Scoring user can log in, read, and write to the table posts
- A user can log in using the credentials `blackteam:kilometer-comrade-zit-cognitive`

MySQL services are scored from the internal team network.