from enum import Flag, StrEnum, auto


class Side(StrEnum):
    NORTH = "north"
    EAST = "east"
    SOUTH = "south"
    WEST = "west"

    @property
    def left(self) -> "Side":
        """Return the side to the left of the current side."""
        match self:
            case Side.NORTH:
                return Side.EAST
            case Side.EAST:
                return Side.SOUTH
            case Side.SOUTH:
                return Side.WEST
            case Side.WEST:
                return Side.NORTH

    @property
    def right(self) -> "Side":
        """Return the side to the right of the current side."""
        match self:
            case Side.NORTH:
                return Side.WEST
            case Side.EAST:
                return Side.NORTH
            case Side.SOUTH:
                return Side.EAST
            case Side.WEST:
                return Side.SOUTH

    @property
    def opposite(self) -> "Side":
        """Return the side opposite to the current side."""
        match self:
            case Side.NORTH:
                return Side.SOUTH
            case Side.EAST:
                return Side.WEST
            case Side.SOUTH:
                return Side.NORTH
            case Side.WEST:
                return Side.EAST

    @property
    def neighbors(self) -> tuple["Side", "Side", "Side"]:
        """Return the two sides adjacent to the current side."""
        return (self.left, self.opposite, self.right)


class SideFlag(Flag):
    NORTH = auto()
    EAST = auto()
    SOUTH = auto()
    WEST = auto()

    @property
    def inverse(self) -> "SideFlag":
        """Return the inverse of the current side flag."""
        return SideFlag(~self.value & 0xF)

    @property
    def sides(self) -> list[Side]:
        """Return a list of sides corresponding to the current side flag."""
        sides = []
        if self & SideFlag.NORTH:
            sides.append(Side.NORTH)
        if self & SideFlag.EAST:
            sides.append(Side.EAST)
        if self & SideFlag.SOUTH:
            sides.append(Side.SOUTH)
        if self & SideFlag.WEST:
            sides.append(Side.WEST)
        return sides
