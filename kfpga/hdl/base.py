import math

from .library import Library
from .module import Module


class MultiplexerModule(Module):
    def __init__(self, size: int, library: Library) -> None:
        if size < 2:
            raise ValueError("Minimal mux size is 2, asked: {}".format(size))

        super().__init__("Multiplexer{}".format(size), library)
        self.size = size
        self.stages = math.ceil(math.log2(size))

        self.add_data_input("data_in", size)
        self.add_data_output("data_out")
        self.add_config("selector", self.stages)

    def template_name(self) -> str:
        return "verilog/kfpga/Multiplexer.v"


class ShiftRegister(Module):
    def __init__(self, width: int, library: Library) -> None:
        if width < 1:
            raise ValueError("Minimal width is 1, asked: {}".format(width))

        super().__init__("ShiftRegister{}".format(width), library)
        self.width = width

        self.add_data_input("data_in")
        self.add_data_output("data_out", self.width)
        self.set_clock()
        self.set_enable()
        self.set_nreset()

    def template_name(self) -> str:
        return "verilog/kfpga/ShiftRegister.v"