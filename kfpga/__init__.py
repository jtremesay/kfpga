import enum
from io import TextIOBase
import math
from pathlib import Path
from typing import Any, Generator, Mapping, Optional, Tuple

from jinja2 import Environment, PackageLoader, select_autoescape


class ConfigByte:
    def __init__(self, name: str, width: int) -> None:
        self.name = name
        self.width = width


env = Environment(
    loader=PackageLoader("kfpga"), autoescape=select_autoescape()
)


class ConfigBitstream:
    def __init__(self):
        self.configs = []

    def add_config(self, config: ConfigByte) -> None:
        try:
            self.get_config(config.name)
        except KeyError:
            pass
        else:
            raise ValueError(
                "Config with the same name already exists {}".format(
                    config.name
                )
            )

        self.configs.append(config)

    def get_config(self, name: str) -> ConfigByte:
        for config in self.configs:
            if config.name == name:
                return config

        raise KeyError("Config not found: {}".format(name))

    @property
    def width(self) -> int:
        return sum(c.width for c in self.configs)

    def enumerate(self) -> Generator[Tuple[int, ConfigByte], None, None]:
        offset = 0
        for config in self.configs:
            yield offset, config
            offset += config.width


class Port:
    class Direction(enum.Enum):
        input = "input"
        output = "output"

    def __init__(self, name: str, direction: Direction, width: int) -> None:
        self.name = name
        self.direction = direction
        self.width = width


class ConfigPort:
    def __init__(self, config: ConfigBitstream) -> None:
        self.config = config

    @property
    def name(self) -> str:
        return "config_in"

    @property
    def direction(self) -> Port.Direction:
        return Port.Direction.input

    @property
    def width(self) -> int:
        return self.config.width


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

    def add_config(self, name: str, width: Optional[int] = 1) -> None:
        config = ConfigByte(name, width)
        self.config.add_config(config)

        if self.config_port is None:
            self.config_port = ConfigPort(self.config)
            self.add_port(self.config_port)

    def set_clock(self) -> None:
        port = Port("clock", Port.Direction.input, 1)
        self.add_port(port)

    def set_enable(self) -> None:
        port = Port("enable", Port.Direction.input, 1)
        self.add_port(port)

    def set_nreset(self) -> None:
        port = Port("nreset", Port.Direction.input, 1)
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


class LUTModule(Module):
    def __init__(self, size: int, library: Library) -> None:
        if size < 2:
            raise ValueError("Minimal LUT size is 2, asked: {}".format(size))

        super().__init__("LookUpTable", library)
        self.size = size
        self.add_data_input("data_in", size)
        self.add_data_output("data_out")

        config_width = 2**size
        self.add_config("truth_table", config_width)


class LogicElementModule(Module):
    def __init__(self, size: int, library: Library) -> None:
        if size < 2:
            raise ValueError("Minimal LUT size is 2, asked: {}".format(size))

        super().__init__("LogicElement", library)
        self.add_data_input("data_in", size)
        self.add_data_output("data_out")
        self.set_clock()
        self.set_nreset()

        lut = library.get_module("LookUpTable")
        self.add_config("lut", lut.config.width)
        self.add_config("comb_out")


class SwitchBoxModule(Module):
    def __init__(
        self,
        interconnect_pairs_count: int,
        cluster_size: int,
        lut_size: int,
        library: Library,
    ) -> None:
        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        if cluster_size < 1:
            raise ValueError(
                "Minimal cluster size is 1, asked: {}".format(cluster_size)
            )

        if lut_size < 2:
            raise ValueError(
                "Minimal LUT size is 2, asked: {}".format(lut_size)
            )

        super().__init__("SwitchBox", library)
        self.interconnect_pairs_count = interconnect_pairs_count
        self.cluster_size = cluster_size

        for side in ("north", "east", "south", "west"):
            self.add_data_input(
                "data_{}_in".format(side), interconnect_pairs_count
            )
            self.add_data_output(
                "data_{}_out".format(side), interconnect_pairs_count
            )

        self.add_data_input("data_from_les", cluster_size)
        self.add_data_output("data_to_les", cluster_size * lut_size)

        mux_ic = library.get_module(
            "Multiplexer{}".format(interconnect_pairs_count * 3 + cluster_size)
        )
        for side in ("north", "east", "south", "west"):
            for i in range(interconnect_pairs_count):
                self.add_config(
                    "mux_{}{}".format(side, i), mux_ic.config.width
                )

        mux_le = library.get_module(
            "Multiplexer{}".format(interconnect_pairs_count * 4 + cluster_size)
        )
        for i in range(cluster_size):
            self.add_config("mux_le{}".format(i), mux_le.config.width)

    def template_ctx(self) -> Mapping[str, Any]:
        ctx = super().template_ctx()
        ctx["interconnect_pairs_count"] = self.interconnect_pairs_count

        return ctx


class LogicTileModule(Module):
    def __init__(
        self,
        interconnect_pairs_count: int,
        cluster_size: int,
        lut_size: int,
        library: Library,
    ) -> None:
        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        if cluster_size < 1:
            raise ValueError(
                "Minimal cluster size is 1, asked: {}".format(cluster_size)
            )

        if lut_size < 2:
            raise ValueError(
                "Minimal LUT size is 2, asked: {}".format(lut_size)
            )

        super().__init__("LogicTile", library)
        self.cluster_size = cluster_size
        self.lut_size = lut_size

        for side in ("north", "east", "south", "west"):
            self.add_data_input(
                "data_{}_in".format(side), interconnect_pairs_count
            )
            self.add_data_output(
                "data_{}_out".format(side), interconnect_pairs_count
            )
        self.set_clock()
        self.set_nreset()

        le = library.get_module("LogicElement")
        for i in range(self.cluster_size):
            self.add_config("le{}".format(i), le.config.width)

        sb = library.get_module("SwitchBox")
        self.add_config("switchbox", sb.config.width)

    def template_ctx(self) -> Mapping[str, Any]:
        ctx = super().template_ctx()
        ctx["cluster_size"] = self.cluster_size
        ctx["lut_size"] = self.lut_size

        return ctx


class LogicColumnModule(Module):
    def __init__(
        self,
        height: int,
        interconnect_pairs_count: int,
        library: Library,
    ) -> None:
        if height < 1:
            raise ValueError("Minimal height is 1, asked: {}".format(height))

        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        super().__init__("LogicColumn", library)
        self.height = height
        self.interconnect_pairs_count = interconnect_pairs_count

        self.add_data_input("data_north_in", interconnect_pairs_count)
        self.add_data_output("data_north_out", interconnect_pairs_count)
        self.add_data_input("data_east_in", interconnect_pairs_count * height)
        self.add_data_output(
            "data_east_out", interconnect_pairs_count * height
        )
        self.add_data_input("data_south_in", interconnect_pairs_count)
        self.add_data_output("data_south_out", interconnect_pairs_count)
        self.add_data_input("data_west_in", interconnect_pairs_count * height)
        self.add_data_output(
            "data_west_out", interconnect_pairs_count * height
        )
        self.set_clock()
        self.set_nreset()

        tile = library.get_module("LogicTile")
        for y in range(height):
            self.add_config("tile{}".format(y), tile.config.width)

    def template_ctx(self) -> Mapping[str, Any]:
        ctx = super().template_ctx()
        ctx["height"] = self.height
        ctx["interconnect_pairs_count"] = self.interconnect_pairs_count

        return ctx


class LogicGridModule(Module):
    def __init__(
        self,
        width: int,
        height: int,
        interconnect_pairs_count: int,
        library: Library,
    ) -> None:
        if width < 1:
            raise ValueError("Minimal width is 1, asked: {}".format(width))

        if height < 1:
            raise ValueError("Minimal height is 1, asked: {}".format(height))

        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        super().__init__("LogicGrid", library)
        self.width = width
        self.height = height
        self.interconnect_pairs_count = interconnect_pairs_count

        self.add_data_input("data_north_in", interconnect_pairs_count * width)
        self.add_data_output(
            "data_north_out", interconnect_pairs_count * width
        )
        self.add_data_input("data_east_in", interconnect_pairs_count * height)
        self.add_data_output(
            "data_east_out", interconnect_pairs_count * height
        )
        self.add_data_input("data_south_in", interconnect_pairs_count * width)
        self.add_data_output(
            "data_south_out", interconnect_pairs_count * width
        )
        self.add_data_input("data_west_in", interconnect_pairs_count * height)
        self.add_data_output(
            "data_west_out", interconnect_pairs_count * height
        )
        self.set_clock()
        self.set_nreset()

        column = library.get_module("LogicColumn")
        for x in range(width):
            self.add_config("column{}".format(x), column.config.width)

    def template_ctx(self) -> Mapping[str, Any]:
        ctx = super().template_ctx()
        ctx["width"] = self.width
        ctx["height"] = self.height
        ctx["interconnect_pairs_count"] = self.interconnect_pairs_count

        return ctx


class IOTileModule(Module):
    def __init__(
        self,
        io_pairs_count: int,
        interconnect_pairs_count: int,
        library: Library,
    ):
        if io_pairs_count < 1:
            raise ValueError(
                "Minimal IO pairs count is 1, asked: {}".format(io_pairs_count)
            )

        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        super().__init__("IOTile", library)
        self.io_pairs_count = io_pairs_count
        self.interconnect_pairs_count = interconnect_pairs_count

        self.add_data_input("data_from_io", io_pairs_count)
        self.add_data_output("data_to_io", io_pairs_count)
        self.add_data_input("data_from_ic", interconnect_pairs_count)
        self.add_data_output("data_to_ic", interconnect_pairs_count)

        mux_ic = library.get_module("Multiplexer{}".format(io_pairs_count))
        for i in range(interconnect_pairs_count):
            self.add_config("mux_ic{}".format(i), mux_ic.config.width)

        mux_io = library.get_module(
            "Multiplexer{}".format(interconnect_pairs_count)
        )
        for i in range(io_pairs_count):
            self.add_config("mux_io{}".format(i), mux_io.config.width)


class IOLineModule(Module):
    def __init__(
        self,
        width: int,
        io_pairs_count: int,
        interconnect_pairs_count: int,
        library: Library,
    ):
        if width < 1:
            raise ValueError("Minimal width is 1, asked: {}".format(width))

        if io_pairs_count < 1:
            raise ValueError(
                "Minimal IO pairs count is 1, asked: {}".format(io_pairs_count)
            )

        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        super().__init__("IOLine", library)
        self.width = width
        self.io_pairs_count = io_pairs_count
        self.interconnect_pairs_count = interconnect_pairs_count

        self.add_data_input("data_from_io", io_pairs_count * width)
        self.add_data_output("data_to_io", io_pairs_count * width)
        self.add_data_input("data_from_ic", interconnect_pairs_count * width)
        self.add_data_output("data_to_ic", interconnect_pairs_count * width)

        iot = library.get_module("IOTile")
        for x in range(width):
            self.add_config("iot{}".format(x), iot.config.width)


class IOColumnModule(Module):
    def __init__(
        self,
        height: int,
        io_pairs_count: int,
        interconnect_pairs_count: int,
        library: Library,
    ):
        if height < 1:
            raise ValueError("Minimal height is 1, asked: {}".format(height))

        if io_pairs_count < 1:
            raise ValueError(
                "Minimal IO pairs count is 1, asked: {}".format(io_pairs_count)
            )

        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        super().__init__("IOColumn", library)
        self.height = height
        self.io_pairs_count = io_pairs_count
        self.interconnect_pairs_count = interconnect_pairs_count

        self.add_data_input("data_from_io", io_pairs_count * height)
        self.add_data_output("data_to_io", io_pairs_count * height)
        self.add_data_input("data_from_ic", interconnect_pairs_count * height)
        self.add_data_output("data_to_ic", interconnect_pairs_count * height)

        iot = library.get_module("IOTile")
        for y in range(height):
            self.add_config("iot{}".format(y), iot.config.width)


class CoreModule(Module):
    def __init__(
        self,
        width: int,
        height: int,
        io_pairs_count: int,
        interconnect_pairs_count: int,
        library: Library,
    ) -> None:
        if width < 1:
            raise ValueError("Minimal width is 1, asked: {}".format(width))

        if height < 1:
            raise ValueError("Minimal height is 1, asked: {}".format(height))

        if io_pairs_count < 1:
            raise ValueError(
                "Minimal IO pairs count is 1, asked: {}".format(io_pairs_count)
            )

        if interconnect_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    interconnect_pairs_count
                )
            )

        super().__init__("kFPGACore", library)
        self.width = width
        self.height = height
        self.io_pairs_count = io_pairs_count
        self.interconnect_pairs_count = interconnect_pairs_count

        self.add_data_input("data_north_in", io_pairs_count * width)
        self.add_data_output("data_north_out", io_pairs_count * width)
        self.add_data_input("data_east_in", io_pairs_count * height)
        self.add_data_output("data_east_out", io_pairs_count * height)
        self.add_data_input("data_south_in", io_pairs_count * width)
        self.add_data_output("data_south_out", io_pairs_count * width)
        self.add_data_input("data_west_in", io_pairs_count * height)
        self.add_data_output("data_west_out", io_pairs_count * height)
        self.set_clock()
        self.set_nreset()

        iol = library.get_module("IOLine")
        ioc = library.get_module("IOColumn")
        self.add_config("io_north", iol.config.width)
        self.add_config("io_east", ioc.config.width)
        self.add_config("io_south", iol.config.width)
        self.add_config("io_west", ioc.config.width)

        grid = library.get_module("LogicGrid")
        self.add_config("grid", grid.config.width)


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


class TopCoreModule(Module):
    def __init__(
        self,
        width: int,
        height: int,
        io_pairs_count: int,
        library: Library,
    ) -> None:
        if width < 1:
            raise ValueError("Minimal width is 1, asked: {}".format(width))

        if height < 1:
            raise ValueError("Minimal height is 1, asked: {}".format(height))

        if io_pairs_count < 1:
            raise ValueError(
                "Minimal IO pairs count is 1, asked: {}".format(io_pairs_count)
            )

        super().__init__("kFPGACoreTop", library)
        self.width = width
        self.height = height
        self.io_pairs_count = io_pairs_count

        core = library.get_module("kFPGACore")
        self.config_width = core.config.width

        self.add_data_input("data_north_in", io_pairs_count * width)
        self.add_data_output("data_north_out", io_pairs_count * width)
        self.add_data_input("data_east_in", io_pairs_count * height)
        self.add_data_output("data_east_out", io_pairs_count * height)
        self.add_data_input("data_south_in", io_pairs_count * width)
        self.add_data_output("data_south_out", io_pairs_count * width)
        self.add_data_input("data_west_in", io_pairs_count * height)
        self.add_data_output("data_west_out", io_pairs_count * height)
        self.set_clock()
        self.set_nreset()
        self.add_data_input("config_in")
        self.add_data_output("config_out")
        self.add_data_input("config_clock")
        self.add_data_input("config_enable")
        self.add_data_input("config_nreset")


def create_kfpga_library(
    width: Optional[int] = 8,
    height: Optional[int] = 8,
    io_pairs_count: Optional[int] = 4,
    interconnect_pairs_count: Optional[int] = 10,
    cluster_size: Optional[int] = 4,
    lut_size: Optional[int] = 6,
) -> Library:
    library = Library("kfpga")

    mux_lut = MultiplexerModule(2**lut_size, library)
    library.add_module(mux_lut)

    lut_module = LUTModule(lut_size, library)
    library.add_module(lut_module)

    le_module = LogicElementModule(lut_size, library)
    library.add_module(le_module)

    mux_ic = MultiplexerModule(
        interconnect_pairs_count * 3 + cluster_size, library
    )
    library.add_module(mux_ic)

    mux_le = MultiplexerModule(
        interconnect_pairs_count * 4 + cluster_size, library
    )
    library.add_module(mux_le)

    sb_module = SwitchBoxModule(
        interconnect_pairs_count, cluster_size, lut_size, library
    )
    library.add_module(sb_module)

    t_module = LogicTileModule(
        interconnect_pairs_count, cluster_size, lut_size, library
    )
    library.add_module(t_module)

    c_module = LogicColumnModule(height, interconnect_pairs_count, library)
    library.add_module(c_module)

    g_module = LogicGridModule(
        width, height, interconnect_pairs_count, library
    )
    library.add_module(g_module)

    mux_io_ic = MultiplexerModule(interconnect_pairs_count, library)
    library.add_module(mux_io_ic)

    mux_io_io = MultiplexerModule(io_pairs_count, library)
    library.add_module(mux_io_io)

    iot_module = IOTileModule(
        io_pairs_count, interconnect_pairs_count, library
    )
    library.add_module(iot_module)

    iol_module = IOLineModule(
        width, io_pairs_count, interconnect_pairs_count, library
    )
    library.add_module(iol_module)

    ioc_module = IOColumnModule(
        height, io_pairs_count, interconnect_pairs_count, library
    )
    library.add_module(ioc_module)

    core_module = CoreModule(
        width,
        height,
        io_pairs_count,
        interconnect_pairs_count,
        library,
    )
    library.add_module(core_module)

    sr_module = ShiftRegister(core_module.config.width, library)
    library.add_module(sr_module)

    top_core_module = TopCoreModule(
        width,
        height,
        io_pairs_count,
        library,
    )
    library.add_module(top_core_module)

    return library


def main():
    library = create_kfpga_library()

    base_dir = Path(__file__).parent

    output_dir = base_dir.parent / "rtl" / "gen"
    output_dir.mkdir(exist_ok=True, parents=True)
    # for entry in output_dir.iterdir():
    #    print(entry)

    library.write_verilog_dir(output_dir)
