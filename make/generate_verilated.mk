include $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/common.mk
###############################################################################
# Variables
###############################################################################
CORE             ?= core
PARAMS           ?= 
OUTPUT_DIR       ?= verilated
SRC_TYPE         ?= v
SRC_V_DIR        ?= ../src_v
OUTPUT_SUFFIX    ?=
SRC              ?= riscv_tcm_top
NAME             ?= riscv_tcm_top

RTL_INCLUDE      ?= ../../core/$(CORE)

# Verilator options
VERILATE_PARAMS  ?= --trace
VERILATOR_OPTS   ?= --pins-sc-uint

OLDER_VERILATOR := $(shell verilator --l2-name v 2>&1 | grep "Invalid Option" | wc -l)

ifeq ($(OLDER_VERILATOR),0)
  VERILATOR_OPTS += --l2-name v
endif

TARGETS          ?= $(OUTPUT_DIR)/V$(NAME)

###############################################################################
# Rules
###############################################################################
all: $(TARGETS)

$(OUTPUT_DIR):
	mkdir -p $@

$(OUTPUT_DIR)/V$(NAME): $(SRC_V_DIR)/$(SRC).$(SRC_TYPE) | $(OUTPUT_DIR)
	verilator --sc $(patsubst $(OUTPUT_DIR)/V$(NAME), $(SRC_V_DIR)/$(NAME), $@) --Mdir $(OUTPUT_DIR) -I$(SRC_V_DIR) $(patsubst %,-I%,$(RTL_INCLUDE)) $(VERILATOR_OPTS) $(VERILATE_PARAMS)

clean:
	-rm -rf $(TARGETS) $(OUTPUT_DIR)
