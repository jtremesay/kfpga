from unittest import TestCase

from amaranth.sim import Simulator, SimulatorContext

from kfpga.components.le import LogicElement, get_le_config_size


class LogicElementTestCase(TestCase):
    def test_le(self):
        for le_size in [2, 3, 4]:
            dut = LogicElement(le_size)

            async def testbench(ctx: SimulatorContext):
                for reg_enable in [0, 1]:  # Test both register enable states
                    for pattern in range(
                        2**le_size
                    ):  # Generate all possible input patterns
                        ctx.set(
                            dut.config, reg_enable << (dut.config_size - 1) | pattern
                        )
                        for select in range(le_size):
                            ctx.set(dut.data_in, select)
                            await ctx.tick()  # Wait for the next clock cycle
                            dut_value = ctx.get(dut.data_out)
                            expected_output = (pattern >> select) & 1
                            assert dut_value == expected_output, (
                                f"pattern={pattern}, select={select}, expected={expected_output}, got={dut_value}"
                            )

            sim = Simulator(dut)
            sim.add_clock(1e-6)  # Add a clock with a period of 1 microsecond
            sim.add_testbench(testbench)
            sim.run()

    def test_get_le_config_size(self):
        self.assertEqual(get_le_config_size(2), 5)
        self.assertEqual(get_le_config_size(3), 9)
        self.assertEqual(get_le_config_size(4), 17)
        self.assertEqual(get_le_config_size(5), 33)
        self.assertEqual(get_le_config_size(6), 65)
