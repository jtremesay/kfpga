from enum import Flag, auto


class SideFlag(Flag):
    NONE = 0
    NORTH = auto()
    EAST = auto()
    SOUTH = auto()
    WEST = auto()
