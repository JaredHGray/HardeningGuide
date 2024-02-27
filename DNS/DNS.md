# DNS Specific Notes

## DNS

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

zone "16.172.in...
```
More coming soon...

## System Networking
First, you need to configure your ip and the router's ip in `/etc/netplan/<some-sort-of-config>.yaml`

You can then set up your DNS server in the conf file above or in `/etc/resolv.conf` (which seems to work more easily)

Use `netplay try` or `netplan apply` to apply the changes to your system's network.

Check your ip with `ip a` and/or `hostname -i`.


## Nice Tools
Use `journalctl -xe` to read the log for `named` and try to figure out what went wrong