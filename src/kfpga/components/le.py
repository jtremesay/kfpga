import logging
from dataclasses import dataclass

from amaranth.lib.data import ArrayLayout, StructLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from .lut import LookUpTable, LookUpTableConfig, LookUpTableConfigLayout

logger = logging.getLogger(__name__)


@dataclass
class LogicElementConfig:
    lut: LookUpTableConfig
    n_reg: bool


class LogicElementConfigLayout(StructLayout):
    def __init__(self, lut_size: int) -> None:
        self.lut_size = lut_size
        self.lut_config_layout = LookUpTableConfigLayout(lut_size)
        super().__init__({"lut": self.lut_config_layout, "n_reg": bool(1)})


class LogicElement(Component):
    def __init__(self, lut_size: int) -> None:
        self.lut_size = lut_size
        self.config_layout = LogicElementConfigLayout(lut_size)

        super().__init__(
            {
                "data_in": In(ArrayLayout(unsigned(1), lut_size)),
                "data_out": Out(1),
                "config": In(self.config_layout),
            }
        )
        self.data_in: Signal = self.data_in
        self.data_out: Signal = self.data_out
        self.config = self.config_layout(self.config)

    def elaborate(self, platform) -> Module:
        m = Module()
        m.submodules.lut = lut = LookUpTable(self.lut_size)
        lut_data_out_r = Signal()

        m.d.comb += [
            lut.data_in.eq(self.data_in),
            lut.config.eq(self.config.lut),
        ]

        with m.If(self.config.n_reg == 0):
            m.d.comb += self.data_out.eq(lut_data_out_r)
        with m.Else():
            m.d.comb += self.data_out.eq(lut.data_out)

        m.d.sync += lut_data_out_r.eq(lut.data_out)

        return m
