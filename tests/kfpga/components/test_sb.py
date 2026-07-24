from amaranth.sim import SimulatorContext

from kfpga.components.sb import SwitchBox
from kfpga.consts import SideFlag
from kfpga.tests.asserts import assertTestBench


def test_instantiate_lt():
    # Boilerplate test to ensure that the LogicTile can be instantiated without errors.
    dut = SwitchBox(
        io_size=4,
        ic_size=4,
        io_sides=SideFlag.NONE,
        vector_size=2,
        lut_size=2,
    )

    async def tb(ctx: SimulatorContext):
        pass

    assertTestBench(testbench=tb, dut=dut, clock_period=None)
