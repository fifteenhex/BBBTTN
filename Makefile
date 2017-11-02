ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
CROSS_COMPILE=arm-linux-gnueabihf-
GOOPS=GOPATH=$(ROOT_DIR)/build/ttnpf
CROSSGOOPS=$(GOOPS) GOOS=linux GOARCH=arm GOARM=7 CC=arm-linux-gnueabihf-gcc
KERNELOPS=ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-

UBOOT=u-boot-2017.09-rc4.tar.gz
LINUX=linux-4.13.tar.xz
BUILDROOT=buildroot-2017.08.tar.gz

SSHKEY=outputs/adminsshkey
FITNAME=outputs/bbbttn-$(TTN_ID).fit
BROVERLAY=build/broverlay

.PHONY: checkttnparams $(FITNAME) uboot linux broverlay ttnpf buildroot config_buildroot clean

all: buildinit checkttnparams $(FITNAME)

buildinit:
	mkdir -p build
	mkdir -p outputs

checkttnparams:
	test -n "$(TTN_ID)"
	test -n "$(TTN_KEY)"

$(FITNAME): buildroot
	mkimage -f bbbttn.its $@

uboot: build/uboot
	make -C $< am335x_boneblack_defconfig
	make -C $< CROSS_COMPILE=$(CROSS_COMPILE)
	cp $</MLO $</u-boot.img outputs/

build/uboot: $(UBOOT)
	rm -rf $@
	mkdir -p $@
	tar xzf $< --strip 1 -C $@

$(BROVERLAY): buildinit checkttnparams $(SSHKEY) ttnpf
	rm -rf $(BROVERLAY)
	cp -a br2overlay $(BROVERLAY)
	#setup ssh and sudo stuff for adm
	mkdir -p $(BROVERLAY)/home/adm/.ssh/
	cp $(SSHKEY).pub $(BROVERLAY)/home/adm/.ssh/authorized_keys
	mkdir -p $(BROVERLAY)/etc/sudoers.d/
	echo "adm ALL=(ALL) NOPASSWD:ALL" >> $(BROVERLAY)/etc/sudoers.d/adm
	chmod +x $(BROVERLAY)/etc/init.d/*

$(SSHKEY):
	ssh-keygen -t rsa -f $@ -P ""

buildroot: $(BROVERLAY)
	cp buildroot.config buildroot/.config
	make -C buildroot/ BR2_EXTERNAL=../br2external

config_buildroot:
	cp buildroot.config buildroot/.config
	make -C buildroot/ BR2_EXTERNAL=../br2external menuconfig
	cp buildroot/.config buildroot.config

clean:
	$(MAKE) -C buildroot/ BR2_EXTERNAL=../br2external clean
