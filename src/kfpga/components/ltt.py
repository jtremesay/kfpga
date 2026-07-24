from amaranth.lib.data import ArrayLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from ..consts import SideFlag
from .lt import LogicTile
from .sr import ShiftRegister


class LogicTileTop(Component):
    def __init__(
        self,
        io_size: int,
        ic_size: int,
        io_sides: SideFlag,
        vector_size: int,
        lut_size: int,
    ) -> None:
        self.io_size = io_size
        self.ic_size = ic_size
        self.io_sides = io_sides
        self.vector_size = vector_size
        self.lut_size = lut_size

        signature = {}
        for side_str, side_flag in [
            ("north", SideFlag.NORTH),
            ("east", SideFlag.EAST),
            ("south", SideFlag.SOUTH),
            ("west", SideFlag.WEST),
        ]:
            size = io_size if side_flag in io_sides else ic_size
            signature |= {
                f"data_{side_str}_in": In(ArrayLayout(unsigned(1), size)),
                f"data_{side_str}_out": Out(ArrayLayout(unsigned(1), size)),
            }
        signature |= {
            "config_in": In(unsigned(1)),
            "config_out": Out(unsigned(1)),
            "config_enable": In(1),
        }

        super().__init__(signature)
        self.data_north_in: Signal = self.data_north_in
        self.data_north_out: Signal = self.data_north_out
        self.data_east_in: Signal = self.data_east_in
        self.data_east_out: Signal = self.data_east_out
        self.data_south_in: Signal = self.data_south_in
        self.data_south_out: Signal = self.data_south_out
        self.data_west_in: Signal = self.data_west_in
        self.data_west_out: Signal = self.data_west_out
        self.config_in: Signal = self.config_in
        self.config_out: Signal = self.config_out
        self.config_enable: Signal = self.config_enable

    def elaborate(self, platform) -> Module:
        m = Module()

        m.submodules.logic_tile = logic_tile = LogicTile(
            self.io_size,
            self.ic_size,
            self.io_sides,
            self.vector_size,
            self.lut_size,
        )
        m.submodules.shift_register = shift_register = ShiftRegister(
            size=logic_tile.config_layout.size
        )
        m.d.comb += [
            logic_tile.data_north_in.eq(self.data_north_in),
            logic_tile.data_east_in.eq(self.data_east_in),
            logic_tile.data_south_in.eq(self.data_south_in),
            logic_tile.data_west_in.eq(self.data_west_in),
            self.data_north_out.eq(logic_tile.data_north_out),
            self.data_east_out.eq(logic_tile.data_east_out),
            self.data_south_out.eq(logic_tile.data_south_out),
            self.data_west_out.eq(logic_tile.data_west_out),
            shift_register.data_in.eq(self.config_in),
            shift_register.enable.eq(self.config_enable),
            logic_tile.config.eq(shift_register.data_out),
            self.config_out.eq(shift_register.data_out[-1]),
        ]

        return m
