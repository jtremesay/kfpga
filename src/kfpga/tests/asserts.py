from collections.abc import Callable, Coroutine
from typing import Any, Optional

from amaranth.lib.wiring import Component
from amaranth.sim import Simulator, SimulatorContext


def assertTestBench(
    testbench: Callable[[SimulatorContext], Coroutine[Any, None, None]],
    dut: Component,
    clock_period: Optional[float] = 1e-6,
):
    sim = Simulator(dut)
    if clock_period is not None:
        sim.add_clock(clock_period)
    sim.add_testbench(testbench)
    sim.run()
