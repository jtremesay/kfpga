import logging

from amaranth.lib.wiring import Component, In, Module, Out, Signal

from .lut import LookUpTable, get_lut_config_size

logger = logging.getLogger(__name__)


def get_le_config_size(size: int) -> int:
    value = get_lut_config_size(size) + 1
    logger.debug(f"get_le_config_size(size={size}) = {value}")

    return value


class LogicElement(Component):
    def __init__(self, size: int) -> None:
        self.size = size
        self.config_size = get_le_config_size(size)

        super().__init__(
            {
                "data_in": In(size),
                "data_out": Out(1),
                "config": In(self.config_size),
            }
        )
        self.data_in: Signal = self.data_in
        self.data_out: Signal = self.data_out
        self.config: Signal = self.config

    def elaborate(self, platform) -> Module:
        m = Module()
        m.submodules.lut = lut = LookUpTable(self.size)
        lut_data_out_r = Signal()

        m.d.comb += [
            lut.data_in.eq(self.data_in),
            lut.config.eq(self.config[:-1]),
        ]

        with m.If(self.config[-1] == 0):
            m.d.comb += self.data_out.eq(lut_data_out_r)
        with m.Else():
            m.d.comb += self.data_out.eq(lut.data_out)

        m.d.sync += lut_data_out_r.eq(lut.data_out)

        return m
