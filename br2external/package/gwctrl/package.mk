GWCTRL_VERSION = dev
GWCTRL_SITE = https://github.com/fifteenhex/gwctrl.git
GWCTRL_SITE_METHOD = git
GWCTRL_DEPENDENCIES = host-pkgconf #glib-networking
GWCTRL_GIT_SUBMODULES = YES

$(eval $(meson-package))
