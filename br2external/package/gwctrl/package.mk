GWCTRL_VERSION = dev
GWCTRL_SITE = https://github.com/fifteenhex/gwctrl.git
GWCTRL_SITE_METHOD = git
GWCTRL_DEPENDENCIES = host-pkgconf #glib-networking
GWCTRL_GIT_SUBMODULES = YES

define GWCTRL_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(GWCTRL_PKGDIR)/S58gwctrl $(TARGET_DIR)/etc/init.d/S58gwctrl
endef

$(eval $(meson-package))
