from collections.abc import Generator
from typing import TypeVar

TestDataT = TypeVar("TestDataT")
TestExpectedT = TypeVar("TestExpectedT")

TestCase = tuple[TestDataT, TestExpectedT]
TestCaseGenerator = Generator[TestCase[TestDataT, TestExpectedT], None, None]
