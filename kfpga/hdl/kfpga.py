from typing import Optional

from .base import MultiplexerModule, ShiftRegister
from .library import Library
from .module import Module


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
            raise ValueError("Minimal LUT size is 2, asked: {}".format(lut_size))

        super().__init__("SwitchBox", library)
        self.interconnect_pairs_count = interconnect_pairs_count
        self.cluster_size = cluster_size
        self.lut_size = lut_size

        for side in ("north", "east", "south", "west"):
            self.add_data_input("data_{}_in".format(side), interconnect_pairs_count)
            self.add_data_output("data_{}_out".format(side), interconnect_pairs_count)

        self.add_data_input("data_from_les", cluster_size)
        self.add_data_output("data_to_les", cluster_size * lut_size)

        mux_ic = library.get_module("MultiplexerSBIC")
        for side in ("north", "east", "south", "west"):
            self.add_config(
                "mux_{}".format(side), mux_ic.config.width, interconnect_pairs_count
            )

        mux_le = library.get_module("MultiplexerSBLE")
        self.add_config("mux_le", mux_le.config.width, cluster_size * lut_size)


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
            raise ValueError("Minimal LUT size is 2, asked: {}".format(lut_size))

        super().__init__("LogicTile", library)
        self.cluster_size = cluster_size
        self.lut_size = lut_size

        for side in ("north", "east", "south", "west"):
            self.add_data_input("data_{}_in".format(side), interconnect_pairs_count)
            self.add_data_output("data_{}_out".format(side), interconnect_pairs_count)
        self.set_clock()
        self.set_nreset()

        le = library.get_module("LogicElement")
        self.add_config("les", le.config.width, cluster_size)

        sb = library.get_module("SwitchBox")
        self.add_config("switchbox", sb.config.width)


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
        self.add_data_output("data_east_out", interconnect_pairs_count * height)
        self.add_data_input("data_south_in", interconnect_pairs_count)
        self.add_data_output("data_south_out", interconnect_pairs_count)
        self.add_data_input("data_west_in", interconnect_pairs_count * height)
        self.add_data_output("data_west_out", interconnect_pairs_count * height)
        self.set_clock()
        self.set_nreset()

        tile = library.get_module("LogicTile")
        for y in range(height):
            self.add_config("tile{}".format(y), tile.config.width)


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
        self.add_data_output("data_north_out", interconnect_pairs_count * width)
        self.add_data_input("data_east_in", interconnect_pairs_count * height)
        self.add_data_output("data_east_out", interconnect_pairs_count * height)
        self.add_data_input("data_south_in", interconnect_pairs_count * width)
        self.add_data_output("data_south_out", interconnect_pairs_count * width)
        self.add_data_input("data_west_in", interconnect_pairs_count * height)
        self.add_data_output("data_west_out", interconnect_pairs_count * height)
        self.set_clock()
        self.set_nreset()

        column = library.get_module("LogicColumn")
        for x in range(width):
            self.add_config("column{}".format(x), column.config.width)


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

        mux_ic = library.get_module("MultiplexerIOIC")
        for i in range(interconnect_pairs_count):
            self.add_config("mux_ic{}".format(i), mux_ic.config.width)

        mux_io = library.get_module("MultiplexerIOIO")
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

    mux_lut = MultiplexerModule(2**lut_size, library, name="MultiplexerLUT")
    library.add_module(mux_lut)

    lut_module = LUTModule(lut_size, library)
    library.add_module(lut_module)

    le_module = LogicElementModule(lut_size, library)
    library.add_module(le_module)

    mux_ic = MultiplexerModule(
        3 + cluster_size,
        library,
        name="MultiplexerSBIC",
    )
    library.add_module(mux_ic)

    mux_le = MultiplexerModule(
        interconnect_pairs_count * 4 + cluster_size,
        library,
        name="MultiplexerSBLE",
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

    g_module = LogicGridModule(width, height, interconnect_pairs_count, library)
    library.add_module(g_module)

    mux_io_ic = MultiplexerModule(io_pairs_count, library, name="MultiplexerIOIC")
    library.add_module(mux_io_ic)

    mux_io_io = MultiplexerModule(
        interconnect_pairs_count, library, name="MultiplexerIOIO"
    )
    library.add_module(mux_io_io)

    iot_module = IOTileModule(io_pairs_count, interconnect_pairs_count, library)
    library.add_module(iot_module)

    iol_module = IOLineModule(width, io_pairs_count, interconnect_pairs_count, library)
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

    sr_module = ShiftRegister(
        core_module.config.width, library, name="ConfigShiftRegister"
    )
    library.add_module(sr_module)

    top_core_module = TopCoreModule(
        width,
        height,
        io_pairs_count,
        library,
    )
    library.add_module(top_core_module)

    return library
