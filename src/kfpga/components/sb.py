import logging
from dataclasses import dataclass

from amaranth import Cat
from amaranth.lib.data import ArrayLayout, StructLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from ..consts import SideFlag
from .mux_mxn import MuxMXN, get_mux_mxn_selector_size

logger = logging.getLogger(__name__)


@dataclass
class SwitchBoxConfig:
    pass


class SwitchBoxConfigLayout(StructLayout):
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

        north_size = io_size if SideFlag.NORTH in io_sides else ic_size
        east_size = io_size if SideFlag.EAST in io_sides else ic_size
        south_size = io_size if SideFlag.SOUTH in io_sides else ic_size
        west_size = io_size if SideFlag.WEST in io_sides else ic_size

        north_mux_inputs = east_size + south_size + west_size + vector_size
        east_mux_inputs = south_size + west_size + north_size + vector_size
        south_mux_inputs = west_size + north_size + east_size + vector_size
        west_mux_inputs = north_size + east_size + south_size + vector_size
        lv_mux_inputs = north_size + east_size + south_size + west_size + vector_size

        super().__init__(
            {
                "north_muxes": unsigned(
                    get_mux_mxn_selector_size(north_mux_inputs, north_size)
                ),
                "east_muxes": unsigned(
                    get_mux_mxn_selector_size(east_mux_inputs, east_size)
                ),
                "south_muxes": unsigned(
                    get_mux_mxn_selector_size(south_mux_inputs, south_size)
                ),
                "west_muxes": unsigned(
                    get_mux_mxn_selector_size(west_mux_inputs, west_size)
                ),
                "lv_muxes": unsigned(
                    get_mux_mxn_selector_size(lv_mux_inputs, vector_size)
                ),
            }
        )


class SwitchBox(Component):
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
        self.config_layout = SwitchBoxConfigLayout(
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
            "data_lv_in": Out(
                ArrayLayout(ArrayLayout(unsigned(1), lut_size), vector_size)
            ),
            "data_lv_out": In(ArrayLayout(unsigned(1), vector_size)),
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
        self.data_lv_in: Signal = self.data_lv_in
        self.data_lv_out: Signal = self.data_lv_out
        self.config = self.config_layout(self.config)

    def elaborate(self, platform) -> Module:
        m = Module()

        north_size = self.io_size if SideFlag.NORTH in self.io_sides else self.ic_size
        east_size = self.io_size if SideFlag.EAST in self.io_sides else self.ic_size
        south_size = self.io_size if SideFlag.SOUTH in self.io_sides else self.ic_size
        west_size = self.io_size if SideFlag.WEST in self.io_sides else self.ic_size

        north_mux_inputs = east_size + south_size + west_size + self.vector_size
        east_mux_inputs = south_size + west_size + north_size + self.vector_size
        south_mux_inputs = west_size + north_size + east_size + self.vector_size
        west_mux_inputs = north_size + east_size + south_size + self.vector_size
        lv_mux_inputs = (
            north_size + east_size + south_size + west_size + self.vector_size
        )

        m.submodules.north_muxes = north_muxes = MuxMXN(north_mux_inputs, north_size)
        m.submodules.east_muxes = east_muxes = MuxMXN(east_mux_inputs, east_size)
        m.submodules.south_muxes = south_muxes = MuxMXN(south_mux_inputs, south_size)
        m.submodules.west_muxes = west_muxes = MuxMXN(west_mux_inputs, west_size)
        m.submodules.lv_muxes = lv_muxes = MuxMXN(lv_mux_inputs, self.vector_size)
        m.d.comb += [
            north_muxes.data_in.eq(
                Cat(
                    self.data_east_out,
                    self.data_south_out,
                    self.data_west_out,
                    self.data_lv_out,
                )
            ),
            north_muxes.select.eq(self.config.north_muxes),
            self.data_north_in.eq(north_muxes.data_out),
            east_muxes.data_in.eq(
                Cat(
                    self.data_south_out,
                    self.data_west_out,
                    self.data_north_out,
                    self.data_lv_out,
                )
            ),
            east_muxes.select.eq(self.config.east_muxes),
            self.data_east_in.eq(east_muxes.data_out),
            south_muxes.data_in.eq(
                Cat(
                    self.data_west_out,
                    self.data_north_out,
                    self.data_east_out,
                    self.data_lv_out,
                )
            ),
            south_muxes.select.eq(self.config.south_muxes),
            self.data_south_in.eq(south_muxes.data_out),
            west_muxes.data_in.eq(
                Cat(
                    self.data_north_out,
                    self.data_east_out,
                    self.data_south_out,
                    self.data_lv_out,
                )
            ),
            west_muxes.select.eq(self.config.west_muxes),
            self.data_west_in.eq(west_muxes.data_out),
            lv_muxes.data_in.eq(
                Cat(
                    self.data_north_out,
                    self.data_east_out,
                    self.data_south_out,
                    self.data_west_out,
                )
            ),
            lv_muxes.select.eq(self.config.lv_muxes),
            self.data_lv_in.eq(lv_muxes.data_out),
        ]

        return m
