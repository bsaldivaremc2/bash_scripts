#NFS share folder
## In the server

Install server software
```bash
sudo apt install nfs-kernel-server
```

create folder to be shared with the name **shared**

```bash
sudo mkdir -p /mnt/shared
```

Give permissions to all to manipulate the folder:
```bash
sudo chown nobody:nogroup /mnt/shared
sudo chmod 777 /mnt/shared
```

The configuration is done in the exports file. See some examples there
```bash
cat /etc/exports
```

You can add a line
```bash
sudo echo "/mnt/shared/ 192.168.1.0/24(rw,sync,no_subtree_check) #added" >> /etc/exports
```
If that does not work, copy in the local directory a copy of the exports file. repeat the process and copy the changed version back to /etc/
```bash
cp /etc/exports .
echo "/mnt/shared/ 192.168.1.0/24(rw,sync,no_subtree_check)" >> ./exports
sudo cp ./exports /etc/
```
Apply the changes and see if the configuration file is exported:
```bash
 sudo exportfs -a
 sudo systemctl restart nfs-kernel-server
 showmount -e
``` 

## In the client
```bash
sudo apt-get install nfs-common
mkdir -p ./MOUNTED_DIR/shared/
sudo mount 192.168.1.69:/mnt/shared ./MOUNTED_DIR/shared/
``` 
The server has the IP address 192.168.1.69

References:
* http://wiki.r1soft.com/display/ServerBackup/Configure+NFS+server+on+Linux
* https://vitux.com/install-nfs-server-and-client-on-ubuntu/