LORA_GATEWAY_VERSION = master
LORA_GATEWAY_SITE = https://github.com/Lora-net/lora_gateway.git
LORA_GATEWAY_SITE_METHOD = git
LORA_GATEWAY_PATCH = 0001-Change-spidev-path.patch 0002-Fix-config-paths.patch
LORA_GATEWAY_INSTALL_STAGING = YES

define LORA_GATEWAY_BUILD_CMDS
	printf "DEBUG_AUX = 0\nDEBUG_SPI = 0\nDEBUG_REG = 1\nDEBUG_HAL = 1\nDEBUG_LBT = 0\nDEBUG_GPS = 0\nDEBUG_GPIO = 1\n\n" >\
		$(@D)/libloragw/library.cfg
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)
endef

define LORA_GATEWAY_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libloragw/libloragw.a $(STAGING_DIR)/usr/lib/libloragw.a
#	$(INSTALL) -D -m 0644 $(@D)/libloragw/library.cfg $(STAGING_DIR)/usr/share/libloragw/library.cfg
#	$(INSTALL) -D -m 0755 $(@D)/libfoo.so* $(STAGING_DIR)/usr/lib
endef

define LORA_GATEWAY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 -t$(TARGET_DIR)/usr/bin $(@D)/libloragw/test_loragw_* $(@D)/util_*/util_*
endef

$(eval $(generic-package))
