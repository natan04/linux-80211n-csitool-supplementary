include $(TOPDIR)/rules.mk

PKG_NAME:=receive_and_transmit
PKG_RELEASE:=1

PLG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/receive_and_transmit
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=receive_and_transmit -- prints a snarky message
	#DESCRIPTION:=dd
endef

define Package/bridge/description
	hello
endef 

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR) 
	$(CP) ./src/* $(PKG_BUILD_DIR)/ 
endef 


define Package/receive_and_transmit/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/receive_and_transmit $(1)/bin/
endef 


$(eval $(call BuildPackage,receive_and_transmit))