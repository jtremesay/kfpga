from argparse import Namespace

from ..core.commands.base import BaseCommand


class Command(BaseCommand):
    """Command to run a sandbox environment."""

    help_message = "Run a sandbox environment."

    def run(self, args: Namespace) -> None:
        pass
