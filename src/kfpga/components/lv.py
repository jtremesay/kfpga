import logging

from amaranth.lib.data import ArrayLayout
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from .le import LogicElement, LogicElementConfig, LogicElementConfigLayout

logger = logging.getLogger(__name__)

LogicVectorConfig = list[LogicElementConfig]


class LogicVectorConfigLayout(ArrayLayout):
    def __init__(self, vector_size: int, lut_size: int) -> None:
        self.vector_size = vector_size
        self.lut_size = lut_size
        self.le_config_layout = LogicElementConfigLayout(lut_size)
        super().__init__(self.le_config_layout, vector_size)


class LogicVector(Component):
    def __init__(self, vector_size: int, lut_size: int) -> None:
        self.vector_size = vector_size
        self.lut_size = lut_size
        self.config_layout = LogicVectorConfigLayout(vector_size, lut_size)

        super().__init__(
            {
                "data_in": In(vector_size * lut_size),
                "data_out": Out(vector_size),
                "config": In(self.config_layout),
            }
        )
        self.data_in: Signal = self.data_in
        self.data_out: Signal = self.data_out
        self.config = self.config_layout(self.config)

    def elaborate(self, platform) -> Module:
        m = Module()

        for i in range(self.vector_size):
            m.submodules[f"le_{i}"] = le = LogicElement(self.lut_size)
            m.d.comb += [
                le.data_in.eq(
                    self.data_in[i * self.lut_size : (i + 1) * self.lut_size]
                ),
                le.config.eq(self.config[i]),
                self.data_out[i].eq(le.data_out),
            ]

        return m
