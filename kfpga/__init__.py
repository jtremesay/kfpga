from pathlib import Path
from .hdl.kfpga import create_kfpga_library


def main():

    base_dir = Path(__file__).parent

    output_dir = base_dir.parent / "rtl" / "k1g8x8y4io10ic4c6l"
    output_dir.mkdir(exist_ok=True, parents=True)
    library = create_kfpga_library()
    library.write_verilog_dir(output_dir)

    output_dir = base_dir.parent / "rtl" / "k1g3x3y4io6ic2c4l"
    output_dir.mkdir(exist_ok=True, parents=True)
    library = create_kfpga_library(
        width=3,
        height=3,
        io_pairs_count=4,
        interconnect_pairs_count=6,
        cluster_size=2,
        lut_size=4,
    )
    library.write_verilog_dir(output_dir)
