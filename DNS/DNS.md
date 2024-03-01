# DNS Specific Notes

[Here's a pretty good guide in case you get lost](https://www.cherryservers.com/blog/how-to-install-and-configure-a-private-bind-dns-server-on-ubuntu-22-04#create-a-directory-for-your-zone-files)
## DNS

Config files: 
 - `named.conf`
 - `named.conf.options`
 - `named.conf.local`

### named.conf.default-zones

```
zone "localhost" {
    type master;
    file "/etc/bind/db.local";
};

zone "ncaecybergames.org" IN {
    type master;
    file "/etc/bind/zones/forward.ncaecybergames.org";
    allow-update { none; };
};

zone "8.168.192.in-addr.arpa" IN {
    type master;
    file "/etc/bind/zones/reverse.ncaecybergames.org";
    allow-update { none; };
};

zone "16.172.in-addr.arpa IN {
    type master;
    file "/etc/bind/zones/reverse.team3.net";
    allow-update { none; };
};
```

### Zone files
Put them in `/etc/bind/zones`, copy template from `/etc/bind/db.empty` to make sure permissions are correct

forward dns config file:
```
@   IN  SOA     example.com root ()
                        1  ; serial, update everytime you do a change
                        #  ; I don't know what these are, don't change them
                        #
                        #
@   IN  NS  ns1
ns1 IN  A   192.168.3.x
www IN  A   192.168.3.x
db  IN  A   192.168.3.x
```

reverse:
```
@   IN  SOA example.com. root.example.com. (
                        1  ; serial, update everytime you do a change
                        #  ; I don't know what these are, don't change them
                        #
                        #
)

@   IN  NS  device-name.
2   IN  PTR sub1.example.com.
3   IN  PTR sub2.example.com.
1.0 IN  PTR external.example.com. ; this is for an external ip, which is on a /16 subnet, so we specific 2 sections in reverse order

```

### Config check commands

Use `named-checkconf 'path-to-config'` to check the setup of config files

Use `named-checkzone example.com 'path-to-zone-file'` to check the setup of your zones  (this make work with both IPs and URLs for reverse and forward, respectively, but I can't remember)

When the DNS service is running, try using `nslookup` to see what the request resolves to. (I believe this works with both URLs and IPs.)

## System Networking
First, you need to configure your ip and the router's ip in `/etc/netplan/<some-sort-of-config>.yaml`

You can then set up your DNS server in the conf file above or in `/etc/resolv.conf` (which seems to work more easily):
```
nameserver 192.168.XX.YY
```

Use `netplay try` or `netplan apply` to apply the changes to your system's network.

Check your ip with `ip a` and/or `hostname -i`.


## Nice Tools
Use `journalctl -xe` to read the log for `named` and try to figure out what went wrong