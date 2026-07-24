import dataclasses
from typing import Optional

from amaranth.lib.data import ArrayLayout, Const as DataConst
from amaranth.lib.wiring import Component
from amaranth.sim import SimulatorContext

from ..asserts import assertTestBench
from .base import TestCaseGenerator, TestDataT, TestExpectedT


def _prepare_value(dut_field, value):
    """Convert value to a form accepted by ctx.set()."""
    if dataclasses.is_dataclass(value) and not isinstance(value, type):
        return dataclasses.asdict(value)
    if isinstance(value, list):
        return [
            dataclasses.asdict(v) if (dataclasses.is_dataclass(v) and not isinstance(v, type)) else v
            for v in value
        ]
    if isinstance(value, int) and isinstance(dut_field.shape(), ArrayLayout):
        shape = dut_field.shape()
        inner_shape = shape.elem_shape
        inner_size = inner_shape.size if isinstance(inner_shape, ArrayLayout) else inner_shape.width
        if inner_size == 1:
            return [(value >> i) & 1 for i in range(shape.length)]
        else:
            inner_mask = (1 << inner_size) - 1
            return [
                [(((value >> (i * inner_size)) & inner_mask) >> j) & 1 for j in range(inner_size)]
                for i in range(shape.length)
            ]
    return value


async def assertTestCase(
    dut: Component, ctx: SimulatorContext, test_case: tuple[TestDataT, TestExpectedT]
):
    test_inputs, test_expected = test_case

    # Assign input values
    print(test_inputs, test_expected)
    for field in test_inputs.__dataclass_fields__:
        dut_field = getattr(dut, field)
        test_input_value = _prepare_value(dut_field, getattr(test_inputs, field))
        ctx.set(dut_field, test_input_value)

    try:
        await ctx.tick()
    except NameError:
        await ctx.delay(1.0e-6)  # Allow for combinational logic to settle

    # Check expected output values
    for field in test_expected.__dataclass_fields__:
        expected_value = getattr(test_expected, field)
        raw_value = ctx.get(getattr(dut, field))
        actual_value = raw_value.as_bits() if isinstance(raw_value, DataConst) else raw_value
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
