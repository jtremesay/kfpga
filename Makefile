target_core ?= gen
netlist_file ?= build/$(target_core).v
verilog_files ?= \
	rtl/$(target_core)/Multiplexer64.v \
	rtl/$(target_core)/LookUpTable.v \
	rtl/$(target_core)/LogicElement.v \
	rtl/$(target_core)/Multiplexer34.v \
	rtl/$(target_core)/Multiplexer44.v \
	rtl/$(target_core)/SwitchBox.v \
	rtl/$(target_core)/LogicTile.v \
	rtl/$(target_core)/LogicColumn.v \
	rtl/$(target_core)/LogicGrid.v \
	rtl/$(target_core)/Multiplexer4.v \
	rtl/$(target_core)/Multiplexer10.v \
	rtl/$(target_core)/IOTile.v \
	rtl/$(target_core)/IOLine.v \
	rtl/$(target_core)/IOColumn.v \
	rtl/$(target_core)/kFPGACore.v \
	rtl/$(target_core)/ShiftRegister42368.v \
	rtl/$(target_core)/kFPGACoreTop.v

all: synth

synth: build $(netlist_file)

build:
	mkdir -p $@


$(netlist_file): $(verilog_files)
	yosys -Q -l logs/synthesis.$(target_core).log -s synthesis/synth.ys -o $@ $^

clean:
	$(RM) $(netlist_file)

.PHONY: all clean synth