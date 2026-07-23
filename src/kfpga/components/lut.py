import logging

from amaranth.lib.wiring import Component, In, Module, Out, Signal

from .mux import Mux

logger = logging.getLogger(__name__)


def get_lut_config_size(size: int) -> int:
    value = 2**size
    logger.debug(f"get_lut_config_size(size={size}) = {value}")

    return value


class LookUpTable(Component):
    def __init__(self, size: int) -> None:
        self.size = size
        self.config_size = get_lut_config_size(size)

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
        m.submodules.mux = mux = Mux(self.size)
        m.d.comb += [
            mux.data_in.eq(self.config),
            mux.select.eq(self.data_in),
            self.data_out.eq(mux.data_out),
        ]

        return m
