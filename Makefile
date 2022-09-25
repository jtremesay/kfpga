target_core ?= k1g3x3y4io6ic2c4l
netlist_file ?= build/$(target_core).v
verilog_files ?= \
	rtl/$(target_core)/Multiplexer16.v \
	rtl/$(target_core)/LookUpTable.v \
	rtl/$(target_core)/LogicElement.v \
	rtl/$(target_core)/Multiplexer20.v \
	rtl/$(target_core)/Multiplexer26.v \
	rtl/$(target_core)/SwitchBox.v \
	rtl/$(target_core)/LogicTile.v \
	rtl/$(target_core)/LogicColumn.v \
	rtl/$(target_core)/LogicGrid.v \
	rtl/$(target_core)/Multiplexer4.v \
	rtl/$(target_core)/Multiplexer6.v \
	rtl/$(target_core)/IOTile.v \
	rtl/$(target_core)/IOLine.v \
	rtl/$(target_core)/IOColumn.v \
	rtl/$(target_core)/kFPGACore.v \
	rtl/$(target_core)/ShiftRegister2034.v \
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