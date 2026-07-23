import math
from typing import Optional

from .library import Library
from .module import ConfigurableModuleMixin, Module, SequentialModuleMixin


class MultiplexerModule(ConfigurableModuleMixin, Module):
    def __init__(self, size: int, library: Library, name: Optional[str] = None) -> None:
        if size < 2:
            raise ValueError("Minimal mux size is 2, asked: {}".format(size))

        super().__init__(name or "Multiplexer{}".format(size), library)
        self.size = size
        stages = math.ceil(math.log2(size))

        self.add_data_input("data_in", size)
        self.add_data_output("data_out")
        self.add_config("selector", stages)

    def template_name(self) -> str:
        return "verilog/base/Multiplexer.v"


class ShiftRegister(SequentialModuleMixin, Module):
    def __init__(
        self, width: int, library: Library, name: Optional[str] = None
    ) -> None:
        if width < 1:
            raise ValueError("Minimal width is 1, asked: {}".format(width))

        super().__init__(name or "ShiftRegister{}".format(width), library)
        self.width = width

        self.add_data_input("data_in")
        self.add_data_output("data_out", self.width)

    def template_name(self) -> str:
        return "verilog/base/ShiftRegister.v"
