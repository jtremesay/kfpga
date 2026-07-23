import pytest
from kfpga.tests.atpg.lv import atpg_lv_test_cases

from kfpga.components.lv import LogicVector, LogicVectorConfigLayout
from kfpga.tests.atpg.asserts import assertATPGTestCase


@pytest.mark.parametrize("lv_size", [2, 3])
@pytest.mark.parametrize("lut_size", [2, 3])
def test_lv(lv_size: int, lut_size: int):
    dut = LogicVector(lv_size, lut_size)
    assertATPGTestCase(dut, atpg_lv_test_cases(lv_size, lut_size))


@pytest.mark.parametrize("lv_size", [2, 3])
@pytest.mark.parametrize("lut_size", [2, 3])
def test_lv_cfg_layout(lv_size: int, lut_size: int):
    layout = LogicVectorConfigLayout(lv_size, lut_size)
    expected_size = lv_size * (2**lut_size + 1)  # +1 for the n_reg bit
    assert layout.size == expected_size
