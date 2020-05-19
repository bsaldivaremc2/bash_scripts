# Connect automatically to remote computer using reverse ssh

Read this [tutorial](https://www.howtogeek.com/428413/what-is-reverse-ssh-tunneling-and-how-to-use-it/)  to see what is reverse ssh and how it is setup then come back.

## Components
* **The Remote Computer, RC**: Is a computer where you want to connect. You do not have control over the router or firewall that allows the connection to its network.
* **The Local Computer, LC**: Is a computer at your house or office where you **are able** to control and manipulate the router or firewall that allows the connection to your network.

## General steps
* At your **Local**  router, **Activate port forwarding**. For instance that the public port be 2222 and your local port 22. Some routers do not allow to use different ports. So for that case, you should change your **LC** ssh port (Use a number greater than 1024).

### Activate passwordless ssh
[Tutorial](https://www.cyberciti.biz/tips/ssh-public-key-based-authentication-how-to.html)

* Create ssh keys at the **LC**.  and do **not** use a passphrase. 
```
#This command will generate a key in your ~/.ssh/ directory
ssh-keygen -t rsa
#~/.ssh/id_rsa.pub
```
* Copy the generated key to **~/.ssh/authorized_keys** file in the **RC**
```
ssh-copy-id -i ~/.ssh/id_rsa.pub remoteuser@remotedomain -p remoteport
#e.g.
ssh-copy-id -i ~/.ssh/id_rsa.pub bryan@200.99.102.3 -p 2222
```
Here 200.99.102.3 is the public IP address of **LC**. You can get this by just googling _what is my public ip_ . **2222** is the public port that you configured on your **Local router** to point towards your **LC**.
Take in mind that **authorized_keys IS a file**. Therefore the contents will be appended to it.

* test if you can connect without a password.
```
ssh bryan@200.99.102.3 -p 2222
```
### Understand how the system works

#### General flow
There is a **guard** that will be running _forever_ at the **RC**, as long as you want this system to work.
The **guard** will run the **monitor.sh** script every **5 minutes** by default (Later explanation how to change it)
The **monitor.sh** will:
* Download a git repo where you hold the connection instructions such as the remote user, remote server, remote port, remote reverse port and status.
Here, remote user, server and port are the **LC** values that you used to connect using ssh in the **Activate passwordless ssh** section.
**reverse port** is the additional port that will be used at your **LC** to connect to **RC**
**status** can be set **ONLINE** or **OFFLINE**. When the **monitor** checks **ONLINE** it will try to connect to your **LC** , not otherwise. 
After **monitor** fails to connect because of network error or because the **status** is **OFFLINE, guard** will wait **300** seconds (5 minutes by default).

```
While 1
	guard runs monitor
	monitor pulls git repo
	de-encrypt connection information
	try to connect
	if connect successful, 
		reverse ssh enabled you can connect to RC from LC
		e.g. at LC : 
		#bryan@bryanpc:~$ ssh local_computer_user@localhost -p reverseport
		bryan@bryanpc:~$ ssh percy@localhost -p 4444
	else
		exit monitor
	guard wait 300 seconds-
```
In this example **percy** is the username at **RC** and **4444** is the **reverseport** present in the configuration file. Use a port above 1024 and that is not used by other software.

#### Files information
* The **general.config.sample** file shows how the configuration have to be defined.
```
IDSERVER1	5
REMOTE_USER	BRYAN
REMOTE_IP	120.22.33.44
REMOTE_PORT 2222
REVERSE_PORT	4444
STATUS	OFFLINE

LABSERVER1	5
REMOTE_USER	SALDIVAR
REMOTE_IP	200.11.22.3
REMOTE_PORT 2828
REVERSE_PORT	3333
STATUS	ONLINE
```
This file can be used by many monitors/computers. Each paragraph contains the instructions for a given **LC**. In this case, there are two computers **IDSERVER1** and **LABSERVER1**. 
**monitor** has a line where you have to define its **ID**, that ID has to match the configuration ID, **it is case sensitive!**. If no ID is found the program will exit.

The number next to the ID indicates to **monitor** how many lines belong to that computer following its ID.
These labels/flags are unique, so do not change them, just the value next to them. You can separate the FIELD (e.g. STATUS) from the value (e.g. OFFLINE) by spaces or tab.

* The **create_keys** files will be used to create a public and private keys. 
	* The **private key** signs the **publc key**.
	* You encrypt the configuration file with the **public key**
	* **monitor** decrypts the configuration file with the **private key**
Just run the **create_keys.sh** file to create two keys, private and public. **Do not store the keys in your git repo!**
```bash
./create_keys.sh
#output1: ssh_reverse_private.pem 
#output2: ssh_reverse_public.pem 
```

* Use the **encrypt_file.sh** script to encrypt the configuration file.
```bash
#./encrypt_file <publi_key.pem> <configuration_file>
./encrypt_file ssh_reverse_public.pem  central.config
#output central.config.blurr
```
* **Monitor setup**
Open the **monitor.sh** file and edit the lines according to the location of your configuration file:
```bash
MONITORID="LABSERVER1"
GIT_REPO="https://github.com/bsaldivaremc2/bash_scripts.git"
RAW_CONFIG_FILE="reverse_ssh/central.config.blurr"
PRIVATEKEY="ssh_reverse_private.pem"
```
**RAW_CONFIG_FILE** contains the path of the encrypted configuration file inside the **GIT_REPO** directory.




