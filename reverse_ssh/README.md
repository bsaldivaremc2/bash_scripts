# Connect to remote computer using reverse ssh

## Components
* **The Remote Computer, RC**: Is a computer where you want to connect. You do not have control over the router or firewall that allows the connection to its network.
* **The Local Computer, LC**: Is a computer at your house or office where you **are able** to control and manipulate the router or firewall that allows the connection to your network.

## General steps
* At your **Local**  router, **Activate port forwarding**. For instance that the public port be 2222 and your local port 22. Some routers do not allow to use different ports. So for that case, you should change your **LC** ssh port.

* Activate passwordless ssh connection using ssh keys.
