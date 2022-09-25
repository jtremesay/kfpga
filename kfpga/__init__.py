from pathlib import Path
from .hdl.kfpga import create_kfpga_library


def main():
    library = create_kfpga_library()

    base_dir = Path(__file__).parent

    output_dir = base_dir.parent / "rtl" / "gen"
    output_dir.mkdir(exist_ok=True, parents=True)
    # for entry in output_dir.iterdir():
    #    print(entry)

    library.write_verilog_dir(output_dir)
