import logging
import math

from amaranth.lib.data import ArrayLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

logger = logging.getLogger(__name__)


def get_mux_selector_size(size: int) -> int:
    value = math.ceil(math.log2(size))
    logger.debug(f"get_mux_selector_size(size={size}) = {value}")

    return value


class Mux(Component):
    def __init__(self, size: int) -> None:
        self.size = size
        self.select_size = get_mux_selector_size(size)

        super().__init__(
            {
                "data_in": In(ArrayLayout(unsigned(1), size)),
                "data_out": Out(1),
                "select": In(self.select_size),
            }
        )
        self.data_in: Signal = self.data_in
        self.data_out: Signal = self.data_out
        self.select: Signal = self.select

    def elaborate(self, platform) -> Module:
        m = Module()
        m.d.comb += self.data_out.eq(self.data_in[self.select])

        return m
