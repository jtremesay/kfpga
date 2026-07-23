from unittest import TestCase

from amaranth.sim import Simulator, SimulatorContext

from kfpga.components.lut import LookUpTable, get_lut_config_size


class LookUpTableTestCase(TestCase):
    def test_lut(self):
        for lut_size in [2, 3, 4]:
            dut = LookUpTable(lut_size)

            async def testbench(ctx: SimulatorContext):
                for pattern in range(
                    2**lut_size
                ):  # Generate all possible input patterns
                    ctx.set(dut.config, pattern)
                    for select in range(lut_size):
                        ctx.set(dut.data_in, select)
                        await ctx.delay(1e-6)
                        dut_value = ctx.get(dut.data_out)
                        expected_output = (pattern >> select) & 1
                        assert dut_value == expected_output, (
                            f"pattern={pattern}, select={select}, expected={expected_output}, got={dut_value}"
                        )

            sim = Simulator(dut)
            sim.add_testbench(testbench)
            sim.run()

    def test_get_lut_config_size(self):
        self.assertEqual(get_lut_config_size(2), 4)
        self.assertEqual(get_lut_config_size(3), 8)
        self.assertEqual(get_lut_config_size(4), 16)
        self.assertEqual(get_lut_config_size(5), 32)
        self.assertEqual(get_lut_config_size(6), 64)
