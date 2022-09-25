import enum

from .config import ConfigBitstream


class Port:
    class Direction(enum.Enum):
        input = "input"
        output = "output"

    def __init__(self, name: str, direction: Direction, width: int) -> None:
        self.name = name
        self.direction = direction
        self.width = width


class ConfigPort:
    def __init__(self, config: ConfigBitstream) -> None:
        self.config = config

    @property
    def name(self) -> str:
        return "config_in"

    @property
    def direction(self) -> Port.Direction:
        return Port.Direction.input

    @property
    def width(self) -> int:
        return self.config.width
