#! /bin/bash

# Reset PIN
SX1301_RESET_BCM_PIN=23

echo "Resetting Module..."
echo "$SX1301_RESET_BCM_PIN"  > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/direction
echo "0"   > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/value
sleep 0.5
echo "1"   > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/value
sleep 0.5
echo "0"   > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/value
sleep 15
echo "$SX1301_RESET_BCM_PIN"  > /sys/class/gpio/unexport

echo "Checking for internet connectivity..."
# Test the connection, wait if needed.
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "[TTN Gateway]: Waiting for internet connection..."
  sleep 30
  done

grep -q AA555A0000240409 global_conf.json
if [[ $? == 0 ]]
then
	echo "[TTN Gateway] First boot config update running"
        GATEWAY_EUI=`/opt/ttn-gateway/picoGW_hal/util_chip_id/util_chip_id`		
        echo "GATEWAY EUI = [$GATEWAY_EUI]"
	echo "$GATEWAY_EUI" >euid.txt
        sed -i --follow-symlinks "s|AA555A0000240409|$GATEWAY_EUI|g" ./global_conf.json #replace gateway ID
        sed -i --follow-symlinks 's/localhost/router.us.thethings.network/g' ./global_conf.json # replace server address
        sed -i --follow-symlinks 's/1680/1700/g' ./global_conf.json # replace server port

fi
echo "Starting Packet Forwarder..."
# Fire up the forwarder.
./lora_pkt_fwd
