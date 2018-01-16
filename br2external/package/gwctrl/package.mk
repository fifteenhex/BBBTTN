GWCTRL_VERSION = master
GWCTRL_SITE = https://github.com/fifteenhex/gwctrl.git
GWCTRL_SITE_METHOD = git
GWCTRL_DEPENDENCIES = host-pkgconf #glib-networking
GWCTRL_GIT_SUBMODULES = YES

define GWCTRL_BUILD_CMDS
	PKGCONFIG=$(PKG_CONFIG_HOST_BINARY) CC=$(TARGET_CROSS)gcc $(MAKE) -C $(@D) gwctrl
endef

define GWCTRL_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/gwctrl $(TARGET_DIR)/usr/bin/gwctrl
endef

$(eval $(generic-package))
