from dataclasses import dataclass

from .base import TestCaseGenerator


def eval_truth_table(truth_table: int, select: int) -> int:
    return (truth_table >> select) & 1


@dataclass
class MuxTestData:
    data_in: int
    select: int


@dataclass
class MuxTestExpected:
    data_out: int


def atpg_mux_test_cases(
    mux_size: int,
) -> TestCaseGenerator[MuxTestData, MuxTestExpected]:
    """Generate test cases for a multiplexer (MUX) of a given size."""
    for data_in in range(mux_size):
        for select in range(mux_size):
            data_out = eval_truth_table(data_in, select)
            yield (
                MuxTestData(data_in=data_in, select=select),
                MuxTestExpected(data_out=data_out),
            )
