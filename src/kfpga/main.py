from argparse import ArgumentParser
from collections.abc import Sequence
from importlib import import_module
from pkgutil import iter_modules
from typing import Optional

from kfpga.core.commands.base import BaseCommand


def main(args: Optional[Sequence[str]] = None) -> int:
    """Main entry point for the application."""
    parser = ArgumentParser(description="KFPGA Command Line Interface")

    # Add subparsers for different commands
    subparsers = parser.add_subparsers(dest="command", required=True)

    # Autodiscover the commands. They are in `kfpga.commands.<command_name>:Command`
    # and are subclasses of `BaseCommand`.
    commands_module = import_module("kfpga.commands")
    commands_path = commands_module.__path__

    for _, module_name, _ in iter_modules(commands_path):
        module = import_module(f"kfpga.commands.{module_name}")
        command_class = getattr(module, "Command", None)
        if command_class and issubclass(command_class, BaseCommand):
            command_instance = command_class()
            command_parser = subparsers.add_parser(
                module_name, help=command_instance.help_message
            )
            command_instance.add_arguments(command_parser)
            command_parser.set_defaults(command=command_instance)

    # Parse the arguments
    parsed_args = parser.parse_args(args)

    if (command := parsed_args.command) is not None:
        command.run(parsed_args)
    else:
        parser.print_help()

    return 0
