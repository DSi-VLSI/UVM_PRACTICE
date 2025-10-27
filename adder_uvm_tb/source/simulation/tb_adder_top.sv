//----------------------------------------------------------------------
// tb_adder_top.sv
//
// This is the top-level testbench module. It is responsible for:
// 1. Instantiating the Design Under Test (DUT).
// 2. Instantiating the UVM verification interfaces.
// 3. Connecting the DUT to the interfaces.
// 4. Setting up the UVM configuration database (config_db).
// 5. Starting the UVM test via `run_test()`.
//----------------------------------------------------------------------

`include "uvm_macros.svh"

import uvm_pkg::*;

`include "test_cases.sv"
`include "ctrl_intf.sv"
`include "data_intf.sv"

module tb_adder_top;

  // Display messages at the very beginning and end of the simulation for clarity.
  initial $display("\033[7;38m TEST STARTED \033[0m");
  final $display("\033[7;38m TEST ENDED \033[0m");

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Parameters
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Define local parameters for the DUT configuration.
  localparam int WIDTH = 8;
  localparam int INPUT_FIFO_SIZE = 4;
  localparam int OUTPUT_FIFO_SIZE = 4;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Signals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Top-level signals that will be connected to the DUT.
  logic             arst_ni;  // Active low reset signal
  logic             clk_i;  // Clock signal

  // Operand 'A' Interface (Valid/Ready Handshake)
  logic [WIDTH-1:0] opa_i;
  logic             opa_valid_i;
  logic             opa_ready_o;

  // Operand 'B' Interface (Valid/Ready Handshake)
  logic [WIDTH-1:0] opb_i;
  logic             opb_valid_i;
  logic             opb_ready_o;

  // Sum Interface (Valid/Ready Handshake)
  logic [WIDTH-1:0] sum_o;
  logic             sum_valid_o;
  logic             sum_ready_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Interfaces
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Control interface for clock and reset.
  ctrl_intf ctrl_if ();

  // Data interfaces for the two inputs (opa, opb) and the output (sum).
  // These interfaces bundle the data, valid, and ready signals.
  data_intf intf_opa (
      .arst_ni(arst_ni),
      .clk_i  (clk_i)
  );

  data_intf intf_opb (
      .arst_ni(arst_ni),
      .clk_i  (clk_i)
  );

  data_intf intf_sum (
      .arst_ni(arst_ni),
      .clk_i  (clk_i)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // DUT Instantiation
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Instantiate the top-level design module.
  adder_top #(
      .WIDTH           (WIDTH),
      .INPUT_FIFO_SIZE (INPUT_FIFO_SIZE),
      .OUTPUT_FIFO_SIZE(OUTPUT_FIFO_SIZE)
  ) u_adder_top (
      // Connect DUT ports to the top-level signals.
      .arst_ni    (arst_ni),
      .clk_i      (clk_i),
      // Operand A
      .opa_i      (opa_i),
      .opa_valid_i(opa_valid_i),
      .opa_ready_o(opa_ready_o),
      // Operand B
      .opb_i      (opb_i),
      .opb_valid_i(opb_valid_i),
      .opb_ready_o(opb_ready_o),
      // Sum
      .sum_o      (sum_o),
      .sum_valid_o(sum_valid_o),
      .sum_ready_i(sum_ready_i)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Assignments
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Connect the control interface signals to the top-level clock and reset.
  assign arst_ni = ctrl_if.arst_n;
  assign clk_i = ctrl_if.clk;

  // Connect the Operand A data interface to the DUT ports.
  assign opa_i = intf_opa.data;
  assign opa_valid_i = intf_opa.valid;
  assign intf_opa.ready = opa_ready_o;

  // Connect the Operand B data interface to the DUT ports.
  assign opb_i = intf_opb.data;
  assign opb_valid_i = intf_opb.valid;
  assign intf_opb.ready = opb_ready_o;

  // Connect the Sum data interface to the DUT ports.
  assign intf_sum.data = sum_o;
  assign intf_sum.valid = sum_valid_o;
  assign sum_ready_i = intf_sum.ready;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Procedural Blocks
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // This initial block sets up the entire UVM test environment and starts the test.
  initial begin
    string test_name;

    // Get the test name from the command line arguments (+test_name=<your_test>).
    // If not provided, the simulation will exit with a fatal error.
    if (!$value$plusargs("test_name=%s", test_name)) begin
      $fatal(1, "No test name provided. Use +test_name=<test_name> to specify a test.");
    end

    // This sets the time format for the simulation output, showing time in nanoseconds.
    $timeformat(-9, 0, "ns", 0);

    // This sets up the VCD (Value Change Dump) file for waveform viewing.
    $dumpfile("tb_adder_top.vcd");
    $dumpvars(0, tb_adder_top);

    // Use the uvm_config_db to pass configuration values down the hierarchy.
    // These values can be retrieved by any component in the test environment.

    // Pass DUT parameters.
    uvm_config_db#(int)::set(uvm_root::get(), "dut", "data_width", WIDTH);

    // Pass the virtual interfaces to the test environment. This is how the
    // UVM components (driver, monitor) interact with the DUT.
    uvm_config_db#(virtual ctrl_intf)::set(uvm_root::get(), "ctrl", "vif", ctrl_if);

    uvm_config_db#(virtual data_intf)::set(uvm_root::get(), "opa", "vif", intf_opa);
    uvm_config_db#(virtual data_intf)::set(uvm_root::get(), "opb", "vif", intf_opb);
    uvm_config_db#(virtual data_intf)::set(uvm_root::get(), "sum", "vif", intf_sum);

    // Start the UVM test. This function creates the test component specified
    // by 'test_name' and starts the UVM phasing mechanism.
    run_test(test_name);

    // End the simulation once the test is complete.
    $finish;

  end

endmodule
