from unittest import TestCase

from amaranth.sim import Simulator, SimulatorContext

from kfpga.components.mux import Mux, get_mux_selector_size


class MuxTestCase(TestCase):
    def test_mux(self):
        for mux_size in [2, 3, 4]:
            dut = Mux(mux_size)

            async def testbench(ctx: SimulatorContext):
                for pattern in range(mux_size):
                    ctx.set(dut.data_in, pattern)
                    for select in range(mux_size):
                        ctx.set(dut.select, select)
                        await ctx.delay(1e-6)
                        dut_value = ctx.get(dut.data_out)
                        expected_output = (pattern >> select) & 1
                        assert dut_value == expected_output, (
                            f"pattern={pattern}, select={select}, expected={expected_output}, got={dut_value}"
                        )

            sim = Simulator(dut)
            sim.add_testbench(testbench)
            sim.run()

    def test_get_mux_selector_size(self):
        self.assertEqual(get_mux_selector_size(2), 1)
        self.assertEqual(get_mux_selector_size(3), 2)
        self.assertEqual(get_mux_selector_size(4), 2)
        self.assertEqual(get_mux_selector_size(5), 3)
        self.assertEqual(get_mux_selector_size(8), 3)
