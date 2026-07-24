from amaranth.lib.data import ArrayLayout, unsigned
from amaranth.lib.wiring import Component, In, Module, Out, Signal

from ..consts import SideFlag
from .ltt import LogicTileTop


class Core(Component):
    def __init__(
        self,
        width: int,
        height: int,
        io_size: int,
        ic_size: int,
        vector_size: int,
        lut_size: int,
    ) -> None:
        self.width = width
        self.height = height
        self.io_size = io_size
        self.ic_size = ic_size
        self.vector_size = vector_size
        self.lut_size = lut_size

        super().__init__(
            {
                "data_north_in": In(
                    ArrayLayout(
                        ArrayLayout(
                            unsigned(1),
                            io_size,
                        ),
                        width,
                    )
                ),
                "data_north_out": Out(
                    ArrayLayout(
                        ArrayLayout(
                            unsigned(1),
                            io_size,
                        ),
                        width,
                    )
                ),
                "data_east_in": In(
                    ArrayLayout(ArrayLayout(unsigned(1), io_size), height)
                ),
                "data_east_out": Out(
                    ArrayLayout(ArrayLayout(unsigned(1), io_size), height)
                ),
                "data_south_in": In(
                    ArrayLayout(
                        ArrayLayout(
                            unsigned(1),
                            io_size,
                        ),
                        width,
                    )
                ),
                "data_south_out": Out(
                    ArrayLayout(
                        ArrayLayout(
                            unsigned(1),
                            io_size,
                        ),
                        width,
                    )
                ),
                "data_west_in": In(
                    ArrayLayout(ArrayLayout(unsigned(1), io_size), height)
                ),
                "data_west_out": Out(
                    ArrayLayout(ArrayLayout(unsigned(1), io_size), height)
                ),
                "config_in": In(unsigned(1)),
                "config_out": Out(unsigned(1)),
                "config_enable": In(1),
            }
        )

        self.data_north_in: Signal = self.data_north_in
        self.data_north_out: Signal = self.data_north_out
        self.data_east_in: Signal = self.data_east_in
        self.data_east_out: Signal = self.data_east_out
        self.data_south_in: Signal = self.data_south_in
        self.data_south_out: Signal = self.data_south_out
        self.data_west_in: Signal = self.data_west_in
        self.data_west_out: Signal = self.data_west_out
        self.config_in: Signal = self.config_in
        self.config_out: Signal = self.config_out
        self.config_enable: Signal = self.config_enable

    def elaborate(self, platform) -> Module:
        m = Module()

        logic_tiles: dict[tuple[int, int], LogicTileTop] = {}

        # Step 1: Create a grid of LogicTileTop instances
        for y in range(self.height):
            for x in range(self.width):
                io_sides = SideFlag.NONE
                if y == 0:
                    io_sides |= SideFlag.SOUTH
                if y == self.height - 1:
                    io_sides |= SideFlag.NORTH
                if x == 0:
                    io_sides |= SideFlag.WEST
                if x == self.width - 1:
                    io_sides |= SideFlag.EAST
                m.submodules[f"logic_tile_{x}_{y}"] = logic_tile = LogicTileTop(
                    self.io_size,
                    self.ic_size,
                    io_sides,
                    self.vector_size,
                    self.lut_size,
                )
                logic_tiles[(x, y)] = logic_tile

        # Step 2: Connect the LogicTileTop instances together
        for (x, y), logic_tile in logic_tiles.items():
            # Connect the south in inputs to the north out outputs of the tile below
            if y == 0:
                m.d.comb += [
                    logic_tile.data_south_in.eq(self.data_south_in[y]),
                    self.data_south_out[y].eq(logic_tile.data_south_out),
                ]
            else:
                m.d.comb += [
                    logic_tile.data_south_in.eq(logic_tiles[(x, y - 1)].data_north_out),
                ]

            # Connect the north in inputs to the south out outputs of the tile above
            if y == self.height - 1:
                m.d.comb += [
                    logic_tile.data_north_in.eq(self.data_north_in[y]),
                    self.data_north_out[y].eq(logic_tile.data_north_out),
                ]
            else:
                m.d.comb += [
                    logic_tile.data_north_in.eq(logic_tiles[(x, y + 1)].data_south_out),
                ]

            # Connect the west in inputs to the east out outputs of the tile to the left
            if x == 0:
                m.d.comb += [
                    logic_tile.data_west_in.eq(self.data_west_in[x]),
                    self.data_west_out[x].eq(logic_tile.data_west_out),
                ]
            else:
                m.d.comb += [
                    logic_tile.data_west_in.eq(logic_tiles[(x - 1, y)].data_east_out),
                ]

            # Connect the east in inputs to the west out outputs of the tile to the right
            if x == self.width - 1:
                m.d.comb += [
                    logic_tile.data_east_in.eq(self.data_east_in[x]),
                    self.data_east_out[x].eq(logic_tile.data_east_out),
                ]
            else:
                m.d.comb += [
                    logic_tile.data_east_in.eq(logic_tiles[(x + 1, y)].data_west_out),
                ]

            # Create a daisy chain of configuration signals through the grid of LogicTileTop instances
            # start bottom of first column (south west), and explore column by column, bottom to top,
            # then move to next column
            if x == 0 and y == 0:
                m.d.comb += [
                    logic_tile.config_in.eq(self.config_in),
                ]
            else:
                if y == 0:
                    m.d.comb += [
                        logic_tile.config_in.eq(
                            logic_tiles[(x - 1, self.height - 1)].config_out
                        ),
                    ]
                else:
                    m.d.comb += [
                        logic_tile.config_in.eq(logic_tiles[(x, y - 1)].config_out),
                    ]

            if x == self.width - 1 and y == self.height - 1:
                m.d.comb += [
                    self.config_out.eq(logic_tile.config_out),
                ]

            m.d.comb += [
                logic_tile.config_enable.eq(self.config_enable),
            ]

        return m
