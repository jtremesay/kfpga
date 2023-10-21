target_core ?= k1g3x3y4io6ic2c4l
netlist_file ?= build/$(target_core).v
verilog_files ?= \
	rtl/$(target_core)/MultiplexerLUT.v \
	rtl/$(target_core)/LookUpTable.v \
	rtl/$(target_core)/LogicElement.v \
	rtl/$(target_core)/MultiplexerSBIC.v \
	rtl/$(target_core)/MultiplexerSBLE.v \
	rtl/$(target_core)/SwitchBox.v \
	rtl/$(target_core)/LogicTile.v \
	rtl/$(target_core)/LogicTileConfig.v \
	rtl/$(target_core)/LogicTileTop.v \
	rtl/$(target_core)/MultiplexerIOIC.v \
	rtl/$(target_core)/MultiplexerIOIO.v \
	rtl/$(target_core)/IOTile.v \
	rtl/$(target_core)/IOTileConfig.v \
	rtl/$(target_core)/NorthIOTileTop.v \
	rtl/$(target_core)/EastIOTileTop.v \
	rtl/$(target_core)/SouthIOTileTop.v \
	rtl/$(target_core)/WestIOTileTop.v \
	rtl/$(target_core)/kFPGACore.v

all: synth

synth: build $(netlist_file)

build:
	mkdir -p $@

$(netlist_file): $(verilog_files)
	yosys -Q -l logs/synthesis.$(target_core).log -s synthesis/synth.ys -o $@ $^

clean:
	$(RM) $(netlist_file)

.PHONY: all clean synth