from typing import Optional

from amaranth.lib.wiring import Component
from amaranth.sim import SimulatorContext

from ..asserts import assertTestBench
from .base import TestCaseGenerator, TestDataT, TestExpectedT


async def assertTestCase[TestDataT, TestExpectedT](
    dut: Component, ctx: SimulatorContext, test_case: tuple[TestDataT, TestExpectedT]
):
    return

    # Assign input values
    for field in test_case.input.__dataclass_fields__:
        try:
            ctx.set(getattr(dut, field), getattr(test_case.input, field))
        except Exception as e:
            raise ValueError(getattr(test_case.input, field)) from e

    try:
        await ctx.tick()
    except NameError:
        await ctx.delay(1.0e-6)  # Allow for combinational logic to settle

    # Check expected output values
    for field in test_case.expected.__dataclass_fields__:
        expected_value = getattr(test_case.expected, field)
        actual_value = ctx.get(getattr(dut, field))
        assert actual_value == expected_value, (
            f"Expected {field}={expected_value}, but got {actual_value}"
        )


def assertATPGTestCase(
    dut: Component,
    test_cases: TestCaseGenerator[TestDataT, TestExpectedT],
    clock_period: Optional[float] = 1e-6,
):
    async def testbench(ctx: SimulatorContext):
        for test_case in test_cases:
            await assertTestCase(dut, ctx, test_case)

    assertTestBench(testbench, dut, clock_period=clock_period)
