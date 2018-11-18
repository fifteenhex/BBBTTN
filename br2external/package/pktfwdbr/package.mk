PKTFWDBR_VERSION = dev
PKTFWDBR_SITE = https://github.com/fifteenhex/pktfwdbr.git
PKTFWDBR_SITE_METHOD = git
PKTFWDBR_DEPENDENCIES = host-pkgconf #glib-networking
PKTFWDBR_GIT_SUBMODULES = YES

define PKTFWDBR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(PKTFWDBR_PKGDIR)/S59pktfwdbr $(TARGET_DIR)/etc/init.d/S59pktfwdbr
endef

$(eval $(meson-package))
