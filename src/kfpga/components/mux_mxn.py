import logging

from amaranth.lib.data import ArrayLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from .mux import Mux, get_mux_selector_size

logger = logging.getLogger(__name__)


def get_mux_mxn_selector_size(m: int, n: int) -> int:
    value = get_mux_selector_size(m) * n
    logger.debug(f"get_mux_mxn_selector_size(m={m}, n={n}) = {value}")

    return value


class MuxMXN(Component):
    """Can can connect M inputs to N outputs, with each output having its own selector."""

    def __init__(self, m: int, n: int) -> None:
        self.m = m
        self.n = n
        super().__init__(
            {
                "data_in": In(ArrayLayout(unsigned(1), m)),
                "select": In(ArrayLayout(unsigned(get_mux_selector_size(m)), n)),
                "data_out": Out(ArrayLayout(unsigned(1), n)),
            }
        )
        self.data_in: Signal = self.data_in
        self.select: Signal = self.select
        self.data_out: Signal = self.data_out

    def elaborate(self, platform) -> Module:
        m = Module()

        for i in range(self.n):
            m.submodules[f"mux_{i}"] = mux = Mux(self.m)
            m.d.comb += [
                mux.data_in.eq(self.data_in),
                mux.select.eq(self.select[i]),
                self.data_out[i].eq(mux.data_out),
            ]

        return m
