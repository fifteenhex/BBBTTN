PKTFWDBR_VERSION = master
PKTFWDBR_SITE = https://github.com/fifteenhex/pktfwdbr.git
PKTFWDBR_SITE_METHOD = git
PKTFWDBR_DEPENDENCIES = host-pkgconf #glib-networking
PKTFWDBR_GIT_SUBMODULES = YES

define PKTFWDBR_BUILD_CMDS
	PKGCONFIG=$(PKG_CONFIG_HOST_BINARY) CC=$(TARGET_CROSS)gcc $(MAKE) -C $(@D)
endef

define PKTFWDBR_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/pktfwdbr $(TARGET_DIR)/usr/bin/pktfwdbr
endef

define PKTFWDBR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(PKTFWDBR_PKGDIR)/S59pktfwdbr $(TARGET_DIR)/etc/init.d/S59pktfwdbr
endef

$(eval $(generic-package))
