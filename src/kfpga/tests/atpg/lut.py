from dataclasses import dataclass

from ...components.lut import LookUpTableConfig
from .base import TestCaseGenerator
from .mux import atpg_mux_test_cases


@dataclass
class LutTestData:
    config: LookUpTableConfig
    data_in: int


@dataclass
class LutTestExpected:
    data_out: int


def atpg_lut_test_cases(
    lut_size: int,
) -> TestCaseGenerator[LutTestData, LutTestExpected]:
    """Generate test cases for a Look-Up Table (LUT) of a given size."""
    for mux_inputs, mux_expected in atpg_mux_test_cases(2**lut_size):
        yield (
            LutTestData(
                config=LookUpTableConfig(truth_table=mux_inputs.data_in),
                data_in=mux_inputs.select,
            ),
            LutTestExpected(data_out=mux_expected.data_out),
        )
