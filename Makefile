ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CROSS_COMPILE=arm-linux-gnueabihf-
GOOPS=GOPATH=$(ROOT_DIR)/build/ttnpf
CROSSGOOPS=$(GOOPS) GOOS=linux GOARCH=arm GOARM=7 CC=arm-linux-gnueabihf-gcc
TTNPFPATH=build/ttnpf/src/github.com/TheThingsNetwork/packet_forwarder/
KERNELOPS=ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-

UBOOT=u-boot-2017.09-rc4.tar.gz
LINUX=linux-4.13.tar.xz
BUILDROOT=buildroot-2017.08.tar.gz

SSHKEY=outputs/adminsshkey
FITNAME=outputs/bbbttn-$(TTN_ID).fit
BROVERLAY=build/broverlay

.PHONY: checkttnparams $(FITNAME) uboot linux broverlay ttnpf buildroot

all: buildinit checkttnparams $(FITNAME)

buildinit:
	mkdir -p build
	mkdir -p outputs

checkttnparams:
	test -n "$(TTN_ID)"
	test -n "$(TTN_KEY)"

$(FITNAME): linux buildroot
	mkimage -f bbbttn.its $@
uboot: build/uboot
	make -C $< am335x_boneblack_defconfig
	make -C $< CROSS_COMPILE=$(CROSS_COMPILE)
	cp $</MLO $</u-boot.img outputs/

build/uboot: $(UBOOT)
	rm -rf $@
	mkdir -p $@
	tar xzf $< --strip 1 -C $@

linux: build/linux
	cp am335x-boneblack.dts $</arch/arm/boot/dts/
	make -C $< $(KERNELOPS) -j4
	make -C $< $(KERNELOPS) dtbs

build/linux:
	mkdir -p $@
	tar xJf $(LINUX) --strip 1 -C $@
	cp linux.config $@/.config

$(BROVERLAY): buildinit checkttnparams $(SSHKEY) ttnpf
	rm -rf $(BROVERLAY)
	#setup ssh and sudo stuff for adm
	mkdir -p $(BROVERLAY)/home/adm/.ssh/
	cp $(SSHKEY).pub $(BROVERLAY)/home/adm/.ssh/authorized_keys
	mkdir -p $(BROVERLAY)/etc/sudoers.d/
	echo "adm ALL=(ALL) NOPASSWD:ALL" >> $(BROVERLAY)/etc/sudoers.d/adm
	#copy in ttn packet forwarder
	mkdir -p $(BROVERLAY)/usr/bin
	cp $(TTNPFPATH)/release/packet-forwarder-linux-arm-default-native $(BROVERLAY)/usr/bin/packet-forwarder
	arm-linux-gnueabihf-strip $(BROVERLAY)/usr/bin/packet-forwarder
	# add configuration file for ttn
	mkdir -p $(BROVERLAY)/etc/ttn
	echo "id: $(TTN_ID)" >> $(BROVERLAY)/etc/ttn/pktfwd.yml
	echo 'key: $(TTN_KEY)' >> $(BROVERLAY)/etc/ttn/pktfwd.yml
	# add our mdev.conf
	mkdir -p $(BROVERLAY)/etc
	cp mdev.conf $(BROVERLAY)/etc
	# add init script for packet forwarder
	mkdir -p $(BROVERLAY)/etc/init.d/
	cp S60ttnpf $(BROVERLAY)/etc/init.d/
	chmod +x $(BROVERLAY)/etc/init.d/S60ttnpf
	# add init script to enable gps module
	mkdir -p $(BROVERLAY)/etc/init.d/
	cp S49gpsen $(BROVERLAY)/etc/init.d/
	chmod +x $(BROVERLAY)/etc/init.d/S49gpsen

ttnpf:	build/ttnpf
#	-$(GOOPS) make -C $(TTNPFPATH) dev-deps
#	-$(CROSSGOOPS) make -C $(TTNPFPATH) deps
	$(CROSSGOOPS) make -C $(TTNPFPATH) build

build/ttnpf:
	-$(GOOPS) go get -v -u github.com/TheThingsNetwork/packet_forwarder


$(SSHKEY):
	ssh-keygen -t rsa -f $@ -P ""

buildroot: build/buildroot $(BROVERLAY)
	make -C $<


build/buildroot: $(BUILDROOT)
	rm -rf $@
	mkdir -p $@
	tar xzf $< --strip 1 -C $@
	cp buildroot.config $@/.config
