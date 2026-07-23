import pytest

from kfpga.components.mux import Mux, get_mux_selector_size
from kfpga.tests.atpg.asserts import assertATPGTestCase
from kfpga.tests.atpg.mux import atpg_mux_test_cases


@pytest.mark.parametrize("mux_size", [2, 3, 4])
def test_mux(mux_size: int):
    dut = Mux(mux_size)
    assertATPGTestCase(dut, atpg_mux_test_cases(mux_size), clock_period=None)


@pytest.mark.parametrize(
    "mux_size, expected_selector_size",
    [
        (2, 1),
        (3, 2),
        (4, 2),
        (5, 3),
        (8, 3),
    ],
)
def test_get_mux_selector_size(mux_size: int, expected_selector_size: int):
    assert get_mux_selector_size(mux_size) == expected_selector_size
