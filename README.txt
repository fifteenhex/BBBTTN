Crappy makefile thing to generate a tftp bootable fit image for a BeagleBoneBlack based
TheThingsNetwork gateway.

Why you would want this? Say your gateway is outside in a sealed enclosure powered via
PoE or whatever...

Say you update Debian or whatever you have running on it and you brick it with a
package update, or the eMMC gets filled up with logs etc. You'll need to go and get
your gateway and strip it apart to fix it.

With a FIT image booted via TFTP everything is running from RAM so there is no
filesystem corruption due to power loss, eMMC wearing out etc to worry about.
"upgrading" means sticking a new FIT image on your TFTP server and rebooting
or power cycling the gateway. For PoE that can be done remotely via the switch
if it's fancy enough or manually by pulling the cable out and pushing it back
in again. If an upgrade breaks something put the old FIT back and power cycle.

hardware connections:
The pinmux etc will be configured for the concentrator being connected
to SPI1 on P9 (D0 is MISO, D1 is MOSI) and a GPS connected to UART1 on
P9.

building:
$TTN_ID=<gatewayid> TTN_KEY=<key> make;
<nap for 30 minutes or so>
The outputs directory will contain a file called bbbttn-<gatewayid>.fit

u-boot:

I think the u-boot that the official images install to eMMC is capable of
TFTP. So you should be able to just update the environment like this to
have it boot from TFTP each time:

setenv fitaddr 0x89000000
setenv bootcmd dhcp "${fitaddr} 192.168.2.1:bbbttn-<gatewayid>.fit; bootm ${fitaddr}"
save env

Just in case you don't have a u-boot that can boot from TFTP a recent
version of u-boot is in outputs. You should be able to write it to
your eMMC by booting up a Debian image via SD card etc:

$dd if=MLO of=/dev/mmcblk1 bs=512 seek=256 count=256 conv=notrunc;
$dd if=u-boot.img of=/dev/mmcblk1 bs=512 seek=768 count=1024 conv=notrunc;

ssh login:

ssh -i adminsshkey adm@<ip address>
use sudo to do stuff as root
