from dataclasses import dataclass

from amaranth.lib.data import ArrayLayout, StructLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from ..consts import SideFlag
from .lv import LogicVector, LogicVectorConfig, LogicVectorConfigLayout
from .sb import SwitchBox, SwitchBoxConfig, SwitchBoxConfigLayout


@dataclass
class LogicTileConfig:
    lv: LogicVectorConfig
    sb: SwitchBoxConfig


class LogicTileConfigLayout(StructLayout):
    def __init__(
        self,
        io_size: int,
        ic_size: int,
        io_sides: SideFlag,
        vector_size: int,
        lut_size: int,
    ) -> None:
        self.vector_size = vector_size
        self.lut_size = lut_size
        super().__init__(
            {
                "lv": LogicVectorConfigLayout(vector_size, lut_size),
                "sb": SwitchBoxConfigLayout(
                    io_size, ic_size, io_sides, vector_size, lut_size
                ),
            }
        )


class LogicTile(Component):
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
        self.config_layout = LogicTileConfigLayout(
            io_size, ic_size, io_sides, vector_size, lut_size
        )

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
            "config": In(self.config_layout),
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
        self.config = self.config_layout(self.config)

    def elaborate(self, platform) -> Module:
        m = Module()

        m.submodules.lv = lv = LogicVector(self.vector_size, self.lut_size)
        m.submodules.sb = sb = SwitchBox(
            self.io_size,
            self.ic_size,
            self.io_sides,
            self.vector_size,
            self.lut_size,
        )
        m.d.comb += [
            sb.data_north_in.eq(self.data_north_in),
            self.data_north_out.eq(sb.data_north_out),
            sb.data_east_in.eq(self.data_east_in),
            self.data_east_out.eq(sb.data_east_out),
            sb.data_south_in.eq(self.data_south_in),
            self.data_south_out.eq(sb.data_south_out),
            sb.data_west_in.eq(self.data_west_in),
            self.data_west_out.eq(sb.data_west_out),
            sb.data_lv_out.eq(lv.data_out),
            lv.data_in.eq(sb.data_lv_out),
            sb.config.eq(self.config.sb),
            lv.config.eq(self.config.lv),
        ]

        return m
