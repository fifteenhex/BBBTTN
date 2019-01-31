GWCTRL_VERSION = dev
GWCTRL_SITE = https://github.com/fifteenhex/gwctrl.git
GWCTRL_SITE_METHOD = git
GWCTRL_DEPENDENCIES = host-pkgconf #glib-networking
GWCTRL_GIT_SUBMODULES = YES

define THINGYJP_OTA_INSTALL_INIT_SYSV
endef

define GWCTRL_INSTALL_INIT_SYSV
	sed -e s#TMPL_MQTT_HOST#$(BR2_BBLWGW_MQTT_HOST)# \
		-e s#TMPL_GATEWAY_NAME#$(BR2_BBLWGW_GATEWAY_NAME)# \
		$(GWCTRL_PKGDIR)/S58gwctrl.template > \
		$(TARGET_DIR)/etc/init.d/S58gwctrl
	chmod 755 $(TARGET_DIR)/etc/init.d/S58gwctrl
endef

$(eval $(meson-package))
