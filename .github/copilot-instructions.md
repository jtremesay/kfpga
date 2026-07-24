# kFPGA Project Guidelines

## Overview

kFPGA is an open-hardware FPGA architecture. The project is being rewritten from a
legacy Verilog implementation to a Python-based generator using [Amaranth HDL](https://amaranth-lang.org/).

- `src/kfpga/` — **active** implementation (Amaranth). Do all new work here unless told otherwise.
- `tests/kfpga/` — pytest test suite mirroring `src/kfpga/components/`.
- `bak/` — legacy Vivado/Verilog project (`bak/kfpga/`, `bak/rtl/`, `bak/devboard/`) and old
  architecture docs (`bak/doc/architecture/`). Kept only for reference; do not edit unless
  explicitly asked to port something from it.
- `docs/dev/` — reference material (e.g. Wilton switchbox paper), not project docs.

## Architecture (`src/kfpga/components/`)

FPGA fabric components are built bottom-up, each wrapping the previous:

```
Mux (mux.py) / MuxMXN (mux_mxn.py)
  -> LookUpTable "LUT" (lut.py)
    -> LogicElement "LE" (le.py)         (LUT + optional output register)
      -> LogicVector "LV" (lv.py)        (array of LE)
        -> LogicTile "LT" (lt.py)        (LV + SwitchBox)
SwitchBox "SB" (sb.py)                    (routes N/E/S/W + local vector signals)
```

`consts.SideFlag` is a `Flag` enum (`NORTH/EAST/SOUTH/WEST`) used to say which tile sides
face chip I/O (wider `io_size`) vs. internal interconnect (`ic_size`).

## Component Conventions

Every component in `src/kfpga/components/` follows the same pattern — mirror it for new
components (see [lut.py](../src/kfpga/components/lut.py) or [le.py](../src/kfpga/components/le.py) as the simplest examples):

1. A plain `@dataclass` `XConfig` describing the config values.
2. An `XConfigLayout(StructLayout)` or `(ArrayLayout)` building the amaranth data layout,
   usually parameterized by sizes (`lut_size`, `vector_size`, `io_size`, `ic_size`, ...).
3. A `Component` subclass (from `amaranth.lib.wiring`) whose signature uses
   `In(...)`/`Out(...)` for `data_in`/`data_out`/`config`, and implements
   `elaborate(self, platform) -> Module`.

## Testing

- Run tests with `uv run pytest` (coverage over `kfpga` is enabled via `pyproject.toml`).
- Test files live in `tests/kfpga/components/test_<component>.py`, one per component in
  `src/kfpga/components/`.
- Test cases are generated via ATPG-style generators in `src/kfpga/tests/atpg/<component>.py`
  (functions like `atpg_lut_test_cases(lut_size)` yielding `(input, expected)` dataclass pairs).
- Assertions go through `assertATPGTestCase(dut, test_cases, clock_period=...)` from
  `src/kfpga/tests/atpg/asserts.py`, which drives an Amaranth `Simulator` testbench and checks
  each dataclass field against the DUT signal of the same name.
- For purely combinational DUTs, pass `clock_period=None` (see `test_lut`); sequential
  components (e.g. `LogicElement`, which has a register) use the default clock.

## Environment

- Python `>=3.14`, managed with `uv` (`uv.lock` present). Main dependency:
  `amaranth[builtin-yosys]`.
