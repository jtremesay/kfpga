from dataclasses import dataclass
from itertools import product

from ...components.le import LogicElementConfig
from .base import TestCaseGenerator
from .le import atpg_le_test_cases


@dataclass
class LvTestData:
    config: list[LogicElementConfig]
    data_in: int


@dataclass
class LvTestExpected:
    data_out: int


def atpg_lv_test_cases(
    lv_size: int, lut_size: int
) -> TestCaseGenerator[LvTestData, LvTestExpected]:
    """Generate test cases for a Logic Vector (LV) of a given size."""
    for test_cases in product(
        atpg_le_test_cases(lut_size), repeat=lv_size
    ):  # Generate all combinations of LE test cases for the LV
        yield (
            LvTestData(
                config=[le_inputs.config for le_inputs, _ in test_cases],
                data_in=sum(
                    le_inputs.data_in << i
                    for i, (le_inputs, _) in enumerate(test_cases)
                ),
            ),
            LvTestExpected(
                data_out=sum(
                    le_expected.data_out << i
                    for i, (_, le_expected) in enumerate(test_cases)
                )
            ),
        )
