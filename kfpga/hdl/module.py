from io import TextIOBase
from pathlib import Path
from typing import Any, Mapping, Optional

from jinja2 import Environment, PackageLoader, select_autoescape

from .config import ConfigBitstream, ConfigByte
from .port import ConfigPort, Port

env = Environment(loader=PackageLoader("kfpga"), autoescape=select_autoescape())


class Module:
    def __init__(self, name: str, library: "Library") -> None:
        self.name = name
        self.config = ConfigBitstream()
        self.config_port = None
        self.ports = []

    def add_port(self, port: Port) -> None:
        try:
            self.get_port(port.name)
        except KeyError:
            pass
        else:
            raise ValueError(
                "Port with the same name already exists {}".format(port.name)
            )

        self.ports.append(port)

    def get_port(self, name: str) -> ConfigByte:
        for port in self.ports:
            if port.name == name:
                return port

        raise KeyError("Port not found: {}".format(name))

    def delete_port(self, name: str):
        for i, port in enumerate(self.ports):
            if port.name == name:
                del self.ports[i]
                return

        raise KeyError("Port not found: {}".format(name))

    def add_data_input(self, name: str, width: Optional[int] = 1) -> None:
        port = Port(name, Port.Direction.input, width)
        self.add_port(port)

    def add_data_output(self, name: str, width: Optional[int] = 1) -> None:
        port = Port(name, Port.Direction.output, width)
        self.add_port(port)

    def template_ctx(self) -> Mapping[str, Any]:
        return {"module": self}

    def template_name(self) -> str:
        return "verilog/kfpga/{}.v".format(self.name)

    def write_verilog_stream(self, stream: TextIOBase) -> None:
        template_name = self.template_name()
        template = env.get_template(template_name)

        ctx = self.template_ctx()

        result = template.render(ctx)
        stream.write(result)

    def write_verilog_file(self, output_file: Path) -> None:
        if output_file.is_dir():
            output_file /= "{}.v".format(self.name)

        with output_file.open("w") as f:
            self.write_verilog_stream(f)


class SequentialModuleMixin(Module):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.set_clock()
        self.set_nreset()
        self.set_enable()

    def set_clock(self) -> None:
        port = Port("clock", Port.Direction.input, 1)
        self.add_port(port)

    def set_enable(self) -> None:
        port = Port("enable", Port.Direction.input, 1)
        self.add_port(port)

    def set_nreset(self) -> None:
        port = Port("nreset", Port.Direction.input, 1)
        self.add_port(port)


class ConfigurableModuleMixin(Module):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)

    def add_config(self, name: str, width: Optional[int] = 1, count=1) -> None:
        config = ConfigByte(name, width, count)
        self.config.add_config(config)

        if self.config_port is None:
            self.config_port = ConfigPort(self.config)
            self.add_port(self.config_port)


class ConfigChainModuleMixin(Module):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.set_config_chain()

    def set_config_chain(self) -> None:
        port = Port("config_in", Port.Direction.input, 1)
        self.add_port(port)
        port = Port("config_out", Port.Direction.output, 1)
        self.add_port(port)
        port = Port("config_enable", Port.Direction.input, 1)
        self.add_port(port)
        port = Port("config_nreset", Port.Direction.input, 1)
        self.add_port(port)
