#
# General variables
#

RUSTC := rustc
BUILD := build
LIB := $(BUILD)/$(shell $(RUSTC) --crate-file-name src/lib.rs)
CIVETWEB := $(BUILD)/libcivetweb.a
RUSTFLAGS += -L $(BUILD)
EXAMPLES := channel_response simple

#
# Frob the variables
#

EXAMPLES := $(EXAMPLES:%=$(BUILD)/%)

#
# Build targets
#

all: $(LIB) examples

examples: $(EXAMPLES)

-include $(BUILD)/civet.d

$(LIB): src/lib.rs $(CIVETWEB) | $(BUILD)
	$(RUSTC) $< --dep-info --out-dir $(@D) $(RUSTFLAGS)

$(EXAMPLES): $(BUILD)/%: examples/%.rs $(LIB) | $(BUILD)
	$(RUSTC) $(RUSTFLAGS) $< -o $@

$(CIVETWEB): src/civetweb/libcivetweb.a | $(BUILD)
	$(MAKE) -C src/civetweb lib
	cp $< $@

$(BUILD):
	@mkdir -p $@

clean:
	rm -rf $(BUILD)
