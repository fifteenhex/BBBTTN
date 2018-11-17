GATEWAY_CONF_VERSION = 551afce4b1bf9bf4507fd0f0b6602c7397d4e3d3
GATEWAY_CONF_SITE = https://github.com/TheThingsNetwork/gateway-conf.git
GATEWAY_CONF_SITE_METHOD = git

define GATEWAY_CONF_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 -t$(TARGET_DIR)/usr/share/gateway_conf/ $(@D)/*.json
endef

$(eval $(generic-package))
