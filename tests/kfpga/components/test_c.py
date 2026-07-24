from amaranth.sim import SimulatorContext

from kfpga.components.c import Core
from kfpga.tests.asserts import assertTestBench


def test_instantiate_c():
    # Boilerplate test to ensure that the LogicTile can be instantiated without errors.
    dut = Core(
        width=2,
        height=2,
        io_size=4,
        ic_size=4,
        vector_size=2,
        lut_size=2,
    )

    async def tb(ctx: SimulatorContext):
        pass

    assertTestBench(testbench=tb, dut=dut)
