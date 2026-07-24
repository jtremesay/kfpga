import logging

from amaranth import Cat
from amaranth.lib.data import ArrayLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

logger = logging.getLogger(__name__)


class ShiftRegister(Component):
    def __init__(self, size: int) -> None:
        self.size = size

        super().__init__(
            {
                "data_in": In(1),
                "data_out": Out(ArrayLayout(unsigned(1), size)),
                "enable": In(1),
            }
        )
        self.data_in: Signal = self.data_in
        self.data_out: Signal = self.data_out
        self.enable: Signal = self.enable

    def elaborate(self, platform) -> Module:
        m = Module()
        with m.If(self.enable):
            m.d.sync += self.data_out.eq(Cat(self.data_in, self.data_out[:-1]))

        return m
