import pytest
from kfpga.tests.atpg.lut import atpg_lut_test_cases

from kfpga.components.lut import LookUpTable, LookUpTableConfigLayout
from kfpga.tests.atpg.asserts import assertATPGTestCase


@pytest.mark.parametrize("lut_size", [2, 3, 4])
def test_lut(lut_size: int):
    dut = LookUpTable(lut_size)
    assertATPGTestCase(dut, atpg_lut_test_cases(lut_size), clock_period=None)


@pytest.mark.parametrize("lut_size", [2, 3, 4])
def test_lut_cfg_layout(lut_size: int):
    layout = LookUpTableConfigLayout(lut_size)
    assert layout.size == 2**lut_size
