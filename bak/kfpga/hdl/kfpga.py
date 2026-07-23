from typing import Optional

from .base import MultiplexerModule, ShiftRegister
from .library import Library
from .module import (
    ConfigChainModuleMixin,
    ConfigurableModuleMixin,
    Module,
    SequentialModuleMixin,
)


class LUTModule(ConfigurableModuleMixin, Module):
    def __init__(self, size: int, library: Library) -> None:
        if size < 2:
            raise ValueError("Minimal LUT size is 2, asked: {}".format(size))

        super().__init__("LookUpTable", library)
        self.size = size
        self.add_data_input("data_in", size)
        self.add_data_output("data_out")

        config_width = 2**size
        self.add_config("truth_table", config_width)


class LogicElementModule(ConfigurableModuleMixin, SequentialModuleMixin, Module):
    def __init__(self, size: int, library: Library) -> None:
        if size < 2:
            raise ValueError("Minimal LUT size is 2, asked: {}".format(size))

        super().__init__("LogicElement", library)
        self.add_data_input("data_in", size)
        self.add_data_output("data_out")

        lut = library.get_module("LookUpTable")
        self.add_config("lut", lut.config.width)
        self.add_config("comb_out")


class SwitchBoxModule(ConfigurableModuleMixin, Module):
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
                "muxes_{}".format(side), mux_ic.config.width, interconnect_pairs_count
            )

        mux_le = library.get_module("MultiplexerSBLE")
        self.add_config("muxes_les", mux_le.config.width, cluster_size * lut_size)


class LogicTileModule(SequentialModuleMixin, ConfigurableModuleMixin, Module):
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

        le = library.get_module("LogicElement")
        self.add_config("les", le.config.width, cluster_size)

        sb = library.get_module("SwitchBox")
        self.add_config("switchbox", sb.config.width)


class TileTopModule(Module):
    def __init__(self, csr: ShiftRegister, name: str, library: Library) -> None:
        super().__init__(name, library)
        self.csr = csr


class LogicTileTopModule(SequentialModuleMixin, ConfigChainModuleMixin, TileTopModule):
    def __init__(
        self,
        interconnect_pairs_count: int,
        cluster_size: int,
        lut_size: int,
        library: Library,
    ) -> None:
        super().__init__(library.get_module("LogicTileConfig"), "LogicTileTop", library)
        self.cluster_size = cluster_size
        self.lut_size = lut_size

        for side in ("north", "east", "south", "west"):
            self.add_data_input("data_{}_in".format(side), interconnect_pairs_count)
            self.add_data_output("data_{}_out".format(side), interconnect_pairs_count)


class IOTileModule(ConfigurableModuleMixin, Module):
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


class IOTileTopModule(ConfigChainModuleMixin, TileTopModule):
    def __init__(
        self,
        side: str,
        io_pairs_count: int,
        interconnect_pairs_count: int,
        library: Library,
    ) -> None:
        super().__init__(
            library.get_module("IOTileConfig"), f"{side}IOTileTop", library
        )

        self.add_data_input("data_from_io", io_pairs_count)
        self.add_data_output("data_to_io", io_pairs_count)
        self.add_data_input("data_from_ic", interconnect_pairs_count)
        self.add_data_output("data_to_ic", interconnect_pairs_count)

    def template_name(self) -> str:
        return "verilog/kfpga/IOTileTop.v".format(self.name)


class CoreModule(SequentialModuleMixin, ConfigChainModuleMixin, Module):
    def __init__(
        self,
        width: int,
        height: int,
        io_pairs_count: int,
        ic_pairs_count: int,
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

        if ic_pairs_count < 1:
            raise ValueError(
                "Minimal interconnect pairs count is 1, asked: {}".format(
                    ic_pairs_count
                )
            )

        super().__init__("kFPGACore", library)
        self.width = width
        self.height = height
        self.io_pairs_count = io_pairs_count
        self.ic_pairs_count = ic_pairs_count

        self.add_data_input("data_north_in", io_pairs_count * width)
        self.add_data_output("data_north_out", io_pairs_count * width)
        self.add_data_input("data_east_in", io_pairs_count * height)
        self.add_data_output("data_east_out", io_pairs_count * height)
        self.add_data_input("data_south_in", io_pairs_count * width)
        self.add_data_output("data_south_out", io_pairs_count * width)
        self.add_data_input("data_west_in", io_pairs_count * height)
        self.add_data_output("data_west_out", io_pairs_count * height)


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

    tc_module = ShiftRegister(t_module.config.width, library, name="LogicTileConfig")
    library.add_module(tc_module)

    tt_module = LogicTileTopModule(
        interconnect_pairs_count, cluster_size, lut_size, library
    )
    library.add_module(tt_module)

    mux_io_ic = MultiplexerModule(io_pairs_count, library, name="MultiplexerIOIC")
    library.add_module(mux_io_ic)

    mux_io_io = MultiplexerModule(
        interconnect_pairs_count, library, name="MultiplexerIOIO"
    )
    library.add_module(mux_io_io)

    iot_module = IOTileModule(io_pairs_count, interconnect_pairs_count, library)
    library.add_module(iot_module)

    iotc_module = ShiftRegister(iot_module.config.width, library, name="IOTileConfig")
    library.add_module(iotc_module)

    for side in ("North", "East", "South", "West"):
        iott_module = IOTileTopModule(
            side, io_pairs_count, interconnect_pairs_count, library
        )
        library.add_module(iott_module)

    core_module = CoreModule(
        width,
        height,
        io_pairs_count,
        interconnect_pairs_count,
        library,
    )
    library.add_module(core_module)

    return library
