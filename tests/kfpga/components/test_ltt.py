from amaranth.sim import SimulatorContext

from kfpga.components.ltt import LogicTileTop
from kfpga.consts import SideFlag
from kfpga.tests.asserts import assertTestBench


def test_instantiate_ltt():
    # Boilerplate test to ensure that the LogicTile can be instantiated without errors.
    dut = LogicTileTop(
        io_size=4,
        ic_size=4,
        io_sides=SideFlag.NONE,
        vector_size=2,
        lut_size=2,
    )

    async def tb(ctx: SimulatorContext):
        pass

    assertTestBench(testbench=tb, dut=dut)
