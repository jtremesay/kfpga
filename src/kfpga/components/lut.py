from dataclasses import dataclass

from amaranth.lib.data import ArrayLayout, StructLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from .mux import Mux


@dataclass
class LookUpTableConfig:
    truth_table: int


class LookUpTableConfigLayout(StructLayout):
    def __init__(self, lut_size: int) -> None:
        super().__init__({"truth_table": unsigned(2**lut_size)})


class LookUpTable(Component):
    def __init__(self, lut_size: int) -> None:
        self.lut_size = lut_size
        self.config_layout = LookUpTableConfigLayout(lut_size)

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

        m.submodules.mux = mux = Mux(2**self.lut_size)
        m.d.comb += [
            mux.data_in.eq(self.config.truth_table),
            mux.select.eq(self.data_in),
            self.data_out.eq(mux.data_out),
        ]

        return m
