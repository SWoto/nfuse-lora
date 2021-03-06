# The Things Network: n-Fuse 

<img src="https://www.thethingsnetwork.org/spa/static/img/b403019.png" height="150"/><img src="https://www.n-fuse.co/assets/products/lrwccx/lrwccx-mpcie_w_shield_w_label_500.png" height="150"/>

Reference setup for [The Things Network](http://thethingsnetwork.org/) gateways based on the n-Fuse mPCIe USB concentrator

# Table of Contents
- [Setting up the Gateway](#setting-up-the-gateway)
- [Installing Package Fowarder and Andrew's Monitor](#installing-package-fowarder-and-andrews-monitor)
- [Setting up your device on TTN](#setting-up-your-device-on-ttn)
- [Commands](#commands)

# Setting up the Gateway

1. Plug mPCIe n-Fuse Lora Concentrator card into unit.
1. Fit the antenna BEFORE power up.
1. Connect the Ethernet cable
1. Power the board and wait a few seconds to connect to it.

# Installing Package Fowarder and Andrew's Monitor
Andrew made some really cool bash files to help installing the package fowarder from [picoGW](https://github.com/Lora-net/picoGW_packet_forwarder). Now, instead of clone two repositories, building those two and some other steps, now we just need clone one rep and execute one bash file. Simple, right? It also comes with a cool service that show us the status and last updates (logs) on the chip.
If you have any questions, you can check [here](https://thomasflummer.com/projects/lora-gateway/). This is one of the best tutorials explaining step by step on how to install it (without this repository).

1. update the OS and install git
```bash
sudo apt-get update && sudo apt-get upgrade -y
apt-get install git -y
```

2. Run the below to clone this repository and make the `.sh` files executables.
```bash
git clone https://github.com/SWoto/nfuse-lora.git
cd nfuse-lora
chmod +x *.sh
```
3. In the `start.sh` file, change the `SX1301_RESET_BCM_PIN` value to the Reset Pin number of your board.

4. Before installing it, :warning: beware that this process uses US LoRaWAN configuration. If you want to swap to the EU version, just change the `global_config.json` to the desired one found [here](https://github.com/Lora-net/picoGW_packet_forwarder/tree/master/lora_pkt_fwd/cfg) and also change the server address on the `start.sh` file to `router.eu.thethings.network`.  
You might be asking me "But only US and EU? What about the others?". As an answer to these questions, altough I haven't tested it yet, you can take a look to the [TTN global_config files](https://github.com/TheThingsNetwork/gateway-conf) and, please, let me know if it worked. Don't forget to change [the server address](https://www.thethingsnetwork.org/docs/gateways/packet-forwarder/semtech-udp.html#router-addresses).

5. Next run the to start the install process
```bash
./install.sh
```
When it finishes executing, the gateway will reboot. After this process, you should procced to configure your unit on [The Things Network](https://www.thethingsnetwork.org/).

# Setting up your device on TTN

1. Log back in and type the following  comand to get the gateway's EUI*:
```bash
cd /opt/ttn-gateway/bin/
./showeui.sh
cd ${OLDPWD}
```
You output will be like this:
```bash
#################################################################

                  GATEWAY EUID = 1234567891011121

    Open TTN console and register your gateway using your EUI: 
         https://console.thethingsnetwork.org/gateways 

 #################################################################
 ```
* _LoRaWAN devices have a 64 bit unique identifier (DevEUI) that is assigned to the device by the chip manufacturer._

2. Goto the [TTN's](https://console.thethingsnetwork.org/gateways) console and register a new account then procced adding a new gateway.
  
3. When registering your gateway, check "I'm using the legacy packet forwarder" to insert the **GATEWAY EUID**
<img src="/images/TTNlegacyOption.png" width="500"/>

4. After your registration is done, remmeber that it may take a while for the system to attempt a connection and to show as "connected" on TTN dashboard. 

# Commands

- Information about the state of the unit can be found by running the command below :
```bash
service ttn-gateway status
```
- Another command that show similar information but less complete:
```bash
sudo tail -f /var/log/syslog
```
- If you want to **UNINSTALL** it, please run the command below, but be aware that this will erase all the previus configurations.
```bash
cd ~/nfuse-lora
sudo ./uninstall.sh
```
