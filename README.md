# RISC-V

An educational implementation of basic RISC-V processor components and instructions in SystemVerilog.

This project was developed while studying *Digital Design and Computer Architecture: RISC-V Edition* by Sarah Harris and David Harris.

## Build and test

The project uses CMake, Icarus Verilog, and the RISC-V GNU toolchain:

```sh
cmake -S . -B build
cmake --build build
```

To run an individual simulation:

```sh
cmake --build build --target sim_tb_06_1_cycle_cpu
```

To run all simulations:

```sh
cmake --build build --target sim_all
```

## View waveforms

The simulations generate VCD waveform files in `build/`. Open one with [Surfer](https://surfer-project.org/):

```sh
surfer build/tb_06_1_cycle_cpu.vcd
```

The RISC-V assembler, linker, and objcopy tools must be available as `riscv64-elf-as`, `riscv64-elf-ld`, and `riscv64-elf-objcopy`.

## Disclaimer

This is an independent educational project. It is not affiliated with or endorsed by Sarah Harris, David Harris, or the publisher of the referenced textbook.

The project is provided for learning purposes and is not intended for production hardware.
