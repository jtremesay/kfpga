from dataclasses import dataclass

from ...components.le import LogicElementConfig
from .base import TestCaseGenerator
from .lut import atpg_lut_test_cases


@dataclass
class LeTestData:
    config: LogicElementConfig
    data_in: int


@dataclass
class LeTestExpected:
    data_out: int


def atpg_le_test_cases(
    lut_size: int,
) -> TestCaseGenerator[LeTestData, LeTestExpected]:
    """Generate test cases for a Logic Element (LE) of a given size."""
    for n_reg in [False, True]:
        for lut_inputs, lut_expected in atpg_lut_test_cases(lut_size):
            yield (
                LeTestData(
                    config=LogicElementConfig(
                        lut=lut_inputs.config,
                        n_reg=n_reg,
                    ),
                    data_in=lut_inputs.data_in,
                ),
                LeTestExpected(data_out=lut_expected.data_out),
            )
