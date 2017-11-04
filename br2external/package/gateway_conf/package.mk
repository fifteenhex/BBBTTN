GATEWAY_CONF_VERSION = master
GATEWAY_CONF_SITE = https://github.com/TheThingsNetwork/gateway-conf.git
GATEWAY_CONF_SITE_METHOD = git
GATEWAY_CONF_PATCH = 0001-Disable-LTB-for-AS1.patch

define GATEWAY_CONF_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 -t$(TARGET_DIR)/usr/share/gateway_conf/ $(@D)/*.json
endef

$(eval $(generic-package))
