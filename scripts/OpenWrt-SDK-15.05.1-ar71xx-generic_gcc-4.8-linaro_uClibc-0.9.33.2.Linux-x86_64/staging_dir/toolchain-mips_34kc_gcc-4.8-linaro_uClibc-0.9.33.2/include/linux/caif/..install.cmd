cmd_/home/buildbot/slave-local/ar71xx_generic/build/build_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/caif/.install := bash scripts/headers_install.sh /home/buildbot/slave-local/ar71xx_generic/build/build_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/caif ./include/uapi/linux/caif caif_socket.h if_caif.h; bash scripts/headers_install.sh /home/buildbot/slave-local/ar71xx_generic/build/build_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/caif ./include/linux/caif ; bash scripts/headers_install.sh /home/buildbot/slave-local/ar71xx_generic/build/build_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/caif ./include/generated/uapi/linux/caif ; for F in ; do echo "\#include <asm-generic/$$F>" > /home/buildbot/slave-local/ar71xx_generic/build/build_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/caif/$$F; done; touch /home/buildbot/slave-local/ar71xx_generic/build/build_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/caif/.install
