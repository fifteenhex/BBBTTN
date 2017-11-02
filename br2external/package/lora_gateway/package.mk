LORA_GATEWAY_VERSION = master
LORA_GATEWAY_SITE = https://github.com/Lora-net/lora_gateway.git
LORA_GATEWAY_SITE_METHOD = git
LORA_GATEWAY_PATCH = 0001-Change-spidev-path.patch
LORA_GATEWAY_INSTALL_STAGING = YES

define LORA_GATEWAY_BUILD_CMDS
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)
endef

define LORA_GATEWAY_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libloragw/libloragw.a $(STAGING_DIR)/usr/lib/libloragw.a
#	$(INSTALL) -D -m 0644 $(@D)/libloragw/library.cfg $(STAGING_DIR)/usr/share/libloragw/library.cfg
#	$(INSTALL) -D -m 0755 $(@D)/libfoo.so* $(STAGING_DIR)/usr/lib
endef

define LORA_GATEWAY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libloragw/test_loragw_* $(TARGET_DIR)/usr/sbin
endef

$(eval $(generic-package))
