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

TOP_DIR = $(shell pwd)

TOOLCHAIN_ROOT ?= $(TOP_DIR)/toolchain
GCC_TOOLCHAIN_PATH := $(TOOLCHAIN_ROOT)/gcc/x86_64-linux-android-4.9/bin
CROSS_COMPILE=$(GCC_TOOLCHAIN_PATH)/x86_64-linux-android-

OPTEE_OS_ENV_VAR += ARCH=x86_64
OPTEE_OS_ENV_VAR += CROSS_COMPILE64=$(GCC_TOOLCHAIN_PATH)/x86_64-linux-android-
OPTEE_OS_ENV_VAR += PLATFORM=bxtp
OPTEE_OS_ENV_VAR += O=$(TOP_DIR)/out/optee_os
OPTEE_OS_ENV_VAR += CFG_TEE_BENCHMARK=n

OPTEE_CLIENT_ENV_VAR += O=$(TOP_DIR)/out/optee_client
OPTEE_CLIENT_ENV_VAR += CFG_TEE_CLIENT_LOAD_PATH=/data/tee

OPTEE_TEST_ENV_VAR += TA_DEV_KIT_ROOT=$(TOP_DIR)/optee_os
OPTEE_TEST_ENV_VAR += OPTEE_CLIENT_EXPORT_ROOT=$(TOP_DIR)/optee_client
OPTEE_TEST_ENV_VAR += TA_DEV_KIT_DIR=${TA_DEV_KIT_ROOT}/out/x86_64-plat-bxtp/export-ta_x86_64
OPTEE_TEST_ENV_VAR += OPTEE_CLIENT_EXPORT=${OPTEE_CLIENT_EXPORT_ROOT}/out/export/usr
OPTEE_TEST_ENV_VAR += O=$(TOP_DIR)/out/optee_test
OPTEE_TEST_ENV_VAR += TA_DIR=/data/tee/optee_armtz

IKGT_ENV_VAR += COMPILE_TOOLCHAIN=$(GCC_TOOLCHAIN_PATH)/x86_64-linux-android-
IKGT_ENV_VAR += BUILD_DIR=$(TOP_DIR)/out/ikgt/
IKGT_ENV_VAR += OPTEEBIN_DIR=$(TOP_DIR)/optee_os/out/x86_64-plat-bxtp/core/
IKGT_ENV_VAR += BOOT_ARCH=abl
IKGT_ENV_VAR += TRUSTY_REF_TARGET=optee_gordon_peak


.PHONY: all ikgt optee_os optee_client optee_test clean

all: ikgt optee_os optee_client optee_test

optee_os:
	@echo '****************************************************************'
	@echo '*   build optee_os ...'
	@echo '****************************************************************'
	$(OPTEE_OS_ENV_VAR) $(MAKE) -C optee_os

optee_client:
	@echo '****************************************************************'
	@echo '*   build optee_client ...'
	@echo '****************************************************************'
	$(OPTEE_CLIENT_ENV_VAR) $(MAKE) -C optee_client

optee_test:
	@echo '****************************************************************'
	@echo '*   build optee_test ...'
	@echo '****************************************************************'
	$(OPTEE_TEST_ENV_VAR) $(MAKE) -C optee_test

ikgt:
	@echo '****************************************************************'
	@echo '*   build ikgt core...'
	@echo '****************************************************************'
	$(IKGT_ENV_VAR) $(MAKE) -C ikgt

clean:
	$(OPTEE_OS_ENV_VAR) $(MAKE) -C optee_os clean
	$(OPTEE_CLIENT_ENV_VAR) $(MAKE) -C optee_client clean
	$(OPTEE_TEST_ENV_VAR) $(MAKE) -C optee_test clean
	$(IKGT_ENV_VAR) $(MAKE) -C ikgt clean
