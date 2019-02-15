PKTFWDBR_VERSION = dev
PKTFWDBR_SITE = https://github.com/fifteenhex/pktfwdbr.git
PKTFWDBR_SITE_METHOD = git
PKTFWDBR_DEPENDENCIES = host-pkgconf glib-networking
PKTFWDBR_GIT_SUBMODULES = YES

define PKTFWDBR_USERS
	pktfwdbr -1 pktfwdbr -1 * - - - pktfwdbr
endef

define PKTFWDBR_INSTALL_INIT_SYSV
	sed -e s#TMPL_MQTT_HOST#$(BR2_BBLWGW_MQTT_HOST)# \
		$(PKTFWDBR_PKGDIR)/S59pktfwdbr.template > \
		$(TARGET_DIR)/etc/init.d/S59pktfwdbr
	chmod 755 $(TARGET_DIR)/etc/init.d/S59pktfwdbr
endef

$(eval $(meson-package))
