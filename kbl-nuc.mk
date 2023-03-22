################################################################################
# Copyright (c) 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

export PATH := /usr/local/gcc-10.2.0/bin:$(PATH)
export LD_LIBRARY_PATH := /usr/local/gcc-10.2.0/lib:$(LD_LIBRARY_PATH)

TOP_DIR = $(shell pwd)

OPTEE_OS_ENV_VAR += ARCH=x86_64
OPTEE_OS_ENV_VAR += CROSS_COMPILE=
OPTEE_OS_ENV_VAR += CROSS_COMPILE64=
OPTEE_OS_ENV_VAR += PLATFORM=kbl
OPTEE_OS_ENV_VAR += O=$(TOP_DIR)/out/optee_os
OPTEE_OS_ENV_VAR += CFG_TEE_BENCHMARK=n

#run "make RELEASE=y" to make release build
ifeq ($(RELEASE),y)
OPTEE_OS_ENV_VAR += CFG_TEE_CORE_DEBUG=n
OPTEE_OS_ENV_VAR += DEBUG=0
OPTEE_OS_ENV_VAR += CFG_TEE_CORE_LOG_LEVEL=1
else
OPTEE_OS_ENV_VAR += DEBUG=1
OPTEE_OS_ENV_VAR += CFG_TEE_CORE_LOG_LEVEL=3
endif

OPTEE_CLIENT_ENV_VAR += CROSS_COMPILE=
OPTEE_CLIENT_ENV_VAR += O=$(TOP_DIR)/out/optee_client

OPTEE_TEST_ENV_VAR += TA_DEV_KIT_DIR=${TOP_DIR}/out/optee_os/export-ta_x86_64
OPTEE_TEST_ENV_VAR += OPTEE_CLIENT_EXPORT=${TOP_DIR}/out/optee_client/export/usr
OPTEE_TEST_ENV_VAR += O=$(TOP_DIR)/out/optee_test

IKGT_ENV_VAR += BUILD_DIR=$(TOP_DIR)/out/ikgt/
IKGT_ENV_VAR += OPTEEBIN_DIR=$(TOP_DIR)/out/optee_os/core/
IKGT_ENV_VAR += BOOT_ARCH=grub
IKGT_ENV_VAR += TRUSTY_REF_TARGET=optee_kbl

.PHONY: all ikgt optee_os optee_client optee_test clean

all: ikgt optee_os optee_client optee_test

optee_os:
	@echo '****************************************************************'
	@echo '*   build optee_os ...'
	@echo '****************************************************************'
	gcc -v
	$(OPTEE_OS_ENV_VAR) $(MAKE) -C optee_os

optee_client:
	@echo '****************************************************************'
	@echo '*   build optee_client ...'
	@echo '****************************************************************'
	$(OPTEE_CLIENT_ENV_VAR) $(MAKE) -C optee_client

optee_test: optee_client optee_os
	@echo '****************************************************************'
	@echo '*   build optee_test ...'
	@echo '****************************************************************'
	$(OPTEE_TEST_ENV_VAR) $(MAKE) -C optee_test

ikgt: optee_os
	@echo '****************************************************************'
	@echo '*   build ikgt core...'
	@echo '****************************************************************'
	$(IKGT_ENV_VAR) $(MAKE) -C ikgt

clean:
	$(OPTEE_OS_ENV_VAR) $(MAKE) -C optee_os clean
	$(OPTEE_CLIENT_ENV_VAR) $(MAKE) -C optee_client clean
	$(OPTEE_TEST_ENV_VAR) $(MAKE) -C optee_test clean
	$(IKGT_ENV_VAR) $(MAKE) -C ikgt clean
