from argparse import ArgumentParser, Namespace

from amaranth.back import verilog
from amaranth.hdl import _nir

from ..components.c import Core
from ..components.le import LogicElement
from ..components.lt import LogicTile
from ..components.ltt import LogicTileTop
from ..components.lut import LookUpTable
from ..components.lv import LogicVector
from ..components.mux import Mux
from ..components.mux_mxn import MuxMXN
from ..components.sb import SwitchBox
from ..components.sr import ShiftRegister
from ..consts import SideFlag
from ..core.commands.base import BaseCommand

# Al diable l'autoritat de la topologia !
_nir.Netlist.check_comb_cycles = lambda self: None


class Command(BaseCommand):
    """Command to write a Verilog file from a KFPGA design."""

    help_message = "Write a Verilog file from a KFPGA design."

    def add_arguments(self, parser: ArgumentParser) -> None:
        parser.add_argument(
            "-o",
            "--output",
            type=str,
            default="output.v",
            help="Output Verilog file name.",
        )
        parser.add_argument(
            "-n",
            "--name",
            type=str,
            default="top",
            help="Top-level module name.",
        )
        parser.add_argument(
            "-w",
            "--width",
            type=int,
            default=3,
            help="Number of columns of logic tiles.",
        )
        parser.add_argument(
            "-H",
            "--height",
            type=int,
            default=3,
            help="Number of rows of logic tiles.",
        )
        parser.add_argument(
            "-i",
            "--io-size",
            type=int,
            default=2,
            help="Number of I/O pins per tile side.",
        )
        parser.add_argument(
            "-j",
            "--ic-size",
            type=int,
            default=4,
            help="Number of interconnects between tile sides.",
        )
        parser.add_argument(
            "-V", "--vector-size", type=int, default=2, help="Number of LUT per tile."
        )
        parser.add_argument(
            "-k", "--lut-size", type=int, default=4, help="Number of LUT inputs."
        )
        parser.add_argument(
            "-m",
            "--module",
            type=str,
            default="c",
            help="Module to generate.",
        )
        parser.add_argument(
            "-s",
            "--side",
            type=int,
            default=SideFlag.NORTH | SideFlag.EAST,
            help="Side of the tile.",
        )

    def run(self, args: Namespace) -> None:
        args.side = SideFlag(args.side)

        match args.module:
            case "mux":
                dut = Mux(
                    size=args.lut_size,
                )
            case "mux_mxn":
                dut = MuxMXN(m=args.lut_size, n=args.vector_size)
            case "lut":
                dut = LookUpTable(
                    lut_size=args.lut_size,
                )
            case "le":
                dut = LogicElement(
                    lut_size=args.lut_size,
                )
            case "lv":
                dut = LogicVector(
                    vector_size=args.vector_size,
                    lut_size=args.lut_size,
                )
            case "sb":
                dut = SwitchBox(
                    io_size=args.io_size,
                    ic_size=args.ic_size,
                    io_sides=args.side,
                    vector_size=args.vector_size,
                    lut_size=args.lut_size,
                )
            case "lt":
                dut = LogicTile(
                    io_size=args.io_size,
                    ic_size=args.ic_size,
                    io_sides=args.side,
                    vector_size=args.vector_size,
                    lut_size=args.lut_size,
                )
            case "sr":
                dut = ShiftRegister(size=args.lut_size)
            case "ltt":
                dut = LogicTileTop(
                    io_size=args.io_size,
                    ic_size=args.ic_size,
                    io_sides=args.side,
                    vector_size=args.vector_size,
                    lut_size=args.lut_size,
                )
            case "c":
                dut = Core(
                    width=args.width,
                    height=args.height,
                    io_size=args.io_size,
                    ic_size=args.ic_size,
                    vector_size=args.vector_size,
                    lut_size=args.lut_size,
                )

            case _:
                raise ValueError(f"Unknown module: {args.module}")

        with open(args.output, "w") as f:
            f.write(verilog.convert(dut, name=args.name))
