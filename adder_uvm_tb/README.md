# Adder UVM Testbench

This repository contains a UVM (Universal Verification Methodology) testbench for a simple adder design. The purpose of this project is to demonstrate a basic UVM environment setup for verifying a Verilog/SystemVerilog module.

## Design Under Test (DUT)

The Design Under Test (DUT) is a pipelined adder (`adder_top`) that performs addition on two input operands. It features:

- **Input/Output Buffering**: The DUT uses FIFOs to buffer the two input operands (`opa` and `opb`) and the output `sum`. This allows the adder to handle data arriving at different rates.
- **Handshake-based Communication**: The interfaces for the operands and the sum use a valid/ready handshake protocol to ensure synchronized data transfer.
- **Synchronized Operation**: A `handshake_combiner` module ensures that an addition is only performed when both input operands are available and there is space in the output buffer for the result.

![DUT TOP](document/dut.svg "DUT TOP")

## Testbench

The UVM testbench is designed to verify the functionality of the `adder_top` DUT. It is structured to be reusable and scalable, following standard UVM practices.

-   **Top-Level Module (`tb_adder_top`)**: This is the entry point of the simulation. It is responsible for:
    -   Instantiating the DUT.
    -   Instantiating the UVM verification interfaces (`ctrl_intf` for control signals and `data_intf` for data signals).
    -   Connecting the DUT to the interfaces.
    -   Setting up the UVM configuration database (`uvm_config_db`) to pass the virtual interfaces and other configuration parameters to the UVM environment.
    -   Starting the UVM test by calling `run_test()`.

-   **Interfaces**:
    -   `ctrl_intf`: Handles the clock and reset signals.
    -   `data_intf`: A generic interface for valid/ready handshake-based communication, used for the two input operands (`opa`, `opb`) and the output (`sum`).

-   **UVM Environment**: The testbench uses a standard UVM environment with agents, drivers, monitors, and a scoreboard to verify the DUT's behavior. The tests are written as sequences that generate random data and send it to the DUT.

![TB TOP](document/tb.svg "TB TOP")

## Project Structure

The project is organized into the following directories:

- `source/design`: Contains the Verilog/SystemVerilog source code for the adder design.
- `source/interface`: Contains the SystemVerilog interfaces used to connect the testbench to the design.
- `source/simulation`: Contains the UVM testbench components, including:
    - `components`: UVM agents, drivers, monitors, and scoreboards.
    - `objects`: Sequence items, sequences, and other transaction-level objects.
    - `testcases`: Test cases that run different simulation scenarios.
- `Makefile`: The main Makefile for running simulations.
- `wave.gtkw`: A GTKWave save file for viewing waveforms.

## Dependencies

To run the simulations, you will need a Verilog simulator that supports UVM. This project has been tested with **Xilinx Vivado**.

## Usage

The `Makefile` provides several commands for managing the simulation:

- `make simulate [test_name=<test>]`: Compiles and runs a simulation. The default test is `base_test`. You can specify a different test by providing the `test_name` argument (e.g., `make simulate test_name=simple_test`).
- `make all`: Cleans the project and runs all available tests.
- `make fresh`: Cleans the project and runs the default test.
- `make clean`: Removes the `build` directory.
- `make clean_full`: Removes both the `build` and `log` directories.
- `make help`: Displays a help message with all available commands.

## License

This project is licensed under the terms of the LICENSE file.