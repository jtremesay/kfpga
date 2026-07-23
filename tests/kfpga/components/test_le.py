import pytest

from kfpga.components.le import LogicElement, LogicElementConfigLayout
from kfpga.tests.atpg.asserts import assertATPGTestCase
from kfpga.tests.atpg.le import atpg_le_test_cases


@pytest.mark.parametrize("lut_size", [2, 3, 4])
def test_le(lut_size: int):
    dut = LogicElement(lut_size)
    assertATPGTestCase(dut, atpg_le_test_cases(lut_size))


@pytest.mark.parametrize("lut_size", [2, 3, 4])
def test_le_cfg_layout(lut_size: int):
    layout = LogicElementConfigLayout(lut_size)
    assert layout.size == 2**lut_size + 1  # +1 for the n_reg bit
