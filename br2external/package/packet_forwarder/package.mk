PACKET_FORWARDER_VERSION = v4.0.1
PACKET_FORWARDER_SITE = https://github.com/Lora-net/packet_forwarder.git
PACKET_FORWARDER_SITE_METHOD = git
PACKET_FORWARDER_DEPENDENCIES = lora_gateway

define PACKET_FORWARDER_BUILD_CMDS
	$(MAKE) LGW_PATH=../../lora_gateway-master/libloragw/ CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)
endef

define PACKET_FORWARDER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/lora_pkt_fwd/lora_pkt_fwd $(TARGET_DIR)/usr/bin/lora_pkt_fwd
endef

define PACKET_FORWARDER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(PACKET_FORWARDER_PKGDIR)/S60pktfwd $(TARGET_DIR)/etc/init.d/S60pktfwd
endef

$(eval $(generic-package))
