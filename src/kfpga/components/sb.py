import logging
from dataclasses import dataclass

from amaranth.lib.data import StructLayout
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from ..consts import SideFlag

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
        super().__init__({})


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

        super().__init__(
            {
                "data_north_in": In(io_size if SideFlag.NORTH in io_sides else ic_size),
                "data_north_out": Out(
                    io_size if SideFlag.NORTH in io_sides else ic_size
                ),
                "data_east_in": In(io_size if SideFlag.EAST in io_sides else ic_size),
                "data_east_out": Out(io_size if SideFlag.EAST in io_sides else ic_size),
                "data_south_in": In(io_size if SideFlag.SOUTH in io_sides else ic_size),
                "data_south_out": Out(
                    io_size if SideFlag.SOUTH in io_sides else ic_size
                ),
                "data_west_in": In(io_size if SideFlag.WEST in io_sides else ic_size),
                "data_west_out": Out(io_size if SideFlag.WEST in io_sides else ic_size),
                "data_lv_in": Out(vector_size * lut_size),
                "data_lv_out": In(vector_size),
                "config": In(self.config_layout),
            }
        )
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

        return m
