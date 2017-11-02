PACKET_FORWARDER_VERSION = master
PACKET_FORWARDER_SITE = https://github.com/Lora-net/packet_forwarder.git
PACKET_FORWARDER_SITE_METHOD = git
PACKET_FORWARDER_PATCH = 0001-Config-files-in-etc.patch

define PACKET_FORWARDER_BUILD_CMDS
	$(MAKE) LGW_PATH=../../lora_gateway-master/libloragw/ CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)
endef

define PACKET_FORWARDER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/lora_pkt_fwd/lora_pkt_fwd $(TARGET_DIR)/usr/bin/lora_pkt_fwd
endef

$(eval $(generic-package))
