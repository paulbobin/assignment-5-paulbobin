##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################

AESD_ASSIGNMENTS_VERSION = 1f95061ac94f5b8ca182450b0d78cbbe53fb318b
AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-paulbobin.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) -C $(@D)/server clean
	$(MAKE) -C $(@D)/server \
		CC="$(TARGET_CC)" \
		all
endef

define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket \
		$(TARGET_DIR)/usr/bin/

	$(INSTALL) -m 0755 $(@D)/server/aesdsocket-start-stop \
		$(TARGET_DIR)/etc/init.d/S99aesdsocket
endef

$(eval $(generic-package))
