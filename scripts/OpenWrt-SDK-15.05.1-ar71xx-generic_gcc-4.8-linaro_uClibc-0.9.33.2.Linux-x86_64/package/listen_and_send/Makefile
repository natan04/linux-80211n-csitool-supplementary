include $(TOPDIR)/rules.mk

PKG_NAME:=listen_and_send
PKG_RELEASE:=1

PLG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/listen_and_send
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Helloworld -- prints a snarky message
	#DESCRIPTION:=dd
endef

define Package/bridge/description
	Listening to mon0, and send the packet by UDP socket
endef 

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR) 
	$(CP) ./src/* $(PKG_BUILD_DIR)/ 
endef 


define Package/listen_and_send/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/listen_and_send $(1)/bin/
endef 


$(eval $(call BuildPackage,listen_and_send))
