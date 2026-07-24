from abc import ABC, abstractmethod
from argparse import ArgumentParser, Namespace


class BaseCommand(ABC):
    """Base class for all commands."""

    help_message: str

    def add_arguments(self, parser: ArgumentParser) -> None:
        """Add command-specific arguments to the parser."""
        pass

    @abstractmethod
    def run(self, args: Namespace) -> None:
        """Run the command with the given arguments."""
        pass
