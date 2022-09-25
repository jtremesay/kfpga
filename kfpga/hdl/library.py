from pathlib import Path
from typing import Any, Generator, Mapping, Optional, Tuple

from .module import Module


class Library:
    def __init__(self, name: Optional[str] = "default") -> None:
        self.name = name
        self.modules = []

    def add_module(self, module: Module) -> None:
        try:
            self.get_module(module.name)
        except KeyError:
            pass
        else:
            raise ValueError(
                "Module with the same name already exists {}".format(
                    module.name
                )
            )

        self.modules.append(module)

    def get_module(self, name: str) -> Module:
        for module in self.modules:
            if module.name == name:
                return module

        raise KeyError("Module not found: {}".format(name))

    def write_verilog_dir(self, output_dir: Path):
        for module in self.modules:
            module.write_verilog_file(output_dir)
