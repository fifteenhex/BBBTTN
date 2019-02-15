ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CROSS_COMPILE=arm-linux-gnueabihf-

UBOOT=u-boot-2017.09-rc4.tar.gz

BR2ARGS=BR2_EXTERNAL="../br2external ../br2autosshkey"
BROVERLAY=build/broverlay

TFTPHOST=tftp.work
MQTTHOST=mqtt.work

.PHONY: uboot broverlay buildroot buildroot_config buildroot_source linux_config clean upload clean_custompackages shell

all: buildinit buildroot

buildinit:
	mkdir -p build

uboot: build/uboot
	$(MAKE) -C $< am335x_boneblack_defconfig
	$(MAKE) -C $< CROSS_COMPILE=$(CROSS_COMPILE)
	cp $</MLO $</u-boot.img outputs/

build/uboot: $(UBOOT)
	rm -rf $@
	mkdir -p $@
	tar xzf $< --strip 1 -C $@

$(BROVERLAY): buildinit
	rm -rf $(BROVERLAY)
	cp -a br2overlay $(BROVERLAY)
	chmod +x $(BROVERLAY)/etc/init.d/*

buildroot: $(BROVERLAY)
	cp buildroot.config buildroot/.config
	$(MAKE) -C buildroot/ $(BR2ARGS)

buildroot_config:
	cp buildroot.config buildroot/.config
	$(MAKE) -C buildroot/ $(BR2ARGS) menuconfig
	cp buildroot/.config buildroot.config

buildroot_source:
	cp buildroot.config buildroot/.config
	$(MAKE) -C buildroot/ $(BR2ARGS) V=0 source

linux_config:
	$(MAKE) -C buildroot/ $(BR2ARGS) linux-menuconfig
	$(MAKE) -C buildroot/ $(BR2ARGS) linux-update-defconfig

clean: clean_custompackages
	$(MAKE) -C buildroot/ $(BR2ARGS) clean

clean_custompackages:
	rm -rf buildroot/output/build/gwctrl-dev/ buildroot/dl/gwctrl/
	rm -rf buildroot/output/build/pktfwdbr-dev/ buildroot/dl/pktfwdbr/

upload: buildroot
	scp buildroot/output/images/bbblwgw.fit $(TFTPHOST):/srv/tftp/bbbttn.fit
	mosquitto_pub -h $(MQTTHOST) -t gwctrl/bbbgw01/ctrl/reboot -m ""

shell:
	ssh -i buildroot/output/sshkeys/adm adm@bbbgw01.family
