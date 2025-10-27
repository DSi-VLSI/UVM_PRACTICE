//----------------------------------------------------------------------
// Class: base_test
//
// The base_test class is the foundation for all test cases. Its primary
// responsibility is to build the testbench environment. It does not
// contain any specific stimulus generation; that is left to the classes
// that extend from it. This promotes reusability and a structured
// approach to test writing.
//----------------------------------------------------------------------

`ifndef __CUST_BASE_TEST_SV__
`define __CUST_BASE_TEST_SV__ 0

`include "cust_env.sv"
`include "ctrl_intf.sv"

virtual class base_test extends uvm_test;

  // UVM Factory Registration: This macro registers the base_test class
  // with the UVM factory, which allows it to be created and overridden
  // by other tests.
  `uvm_component_utils(base_test)

  //--------------------------------------------------------------------
  // Component Handles
  //--------------------------------------------------------------------

  // Handle to the top-level environment component. This handle will be
  // used to access sub-components within the environment if needed.
  cust_env env;

  // Virtual interface for control signals
  virtual ctrl_intf ctrl_if;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  //--------------------------------------------------------------------
  // Function: new
  //
  // Constructor for the base_test class.
  //
  // Parameters:
  //   name   - The instance name of this component.
  //   parent - A handle to the parent component in the hierarchy.
  //--------------------------------------------------------------------
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------------------
  // Function: build_phase
  //
  // Constructs the testbench environment and retrieves necessary
  // configuration, such as the control interface handle.
  //
  // Parameters:
  //   phase - The UVM phase object, providing context about the current phase.
  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the environment instance using the UVM factory.
    env = cust_env::type_id::create("env", this);

    // Get the virtual control interface from the config_db. This is
    // required for the clock and reset helper tasks.
    if (!uvm_config_db#(virtual ctrl_intf)::get(uvm_root::get(), "ctrl", "vif", ctrl_if)) begin
      `uvm_fatal("CTRL_IF", "Control interface not found in the UVM config database.")
    end
  endfunction

  //--------------------------------------------------------------------
  // Task: run_phase
  //
  // The base test's run_phase performs common startup tasks for all
  // tests: it applies a reset, starts the clock, and prints the
  // testbench topology.
  //
  // Derived tests MUST call `super.run_phase(phase)` to ensure this
  // setup is executed before the test-specific stimulus begins.
  //
  // Parameters:
  //   phase - The UVM phase object, providing context about the current phase.
  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    uvm_top.print_topology();
    apply_reset();
    start_clock();
    phase.drop_objection(this);
  endtask

  //--------------------------------------------------------------------
  // Task: apply_reset
  //
  // Helper task to apply a reset pulse to the DUT.
  //
  // Parameters:
  //   duration - The duration of the active-low reset pulse.
  //--------------------------------------------------------------------
  task automatic apply_reset(input realtime duration = 100ns);
    ctrl_if.apply_reset(duration);
  endtask

  //--------------------------------------------------------------------
  // Task: start_clock
  //
  // Helper task to start the clock generation.
  //
  // Parameters:
  //   timeperiod - The clock period.
  //--------------------------------------------------------------------
  task automatic start_clock(input realtime timeperiod = 10ns);
    ctrl_if.timeperiod = timeperiod;
    ctrl_if.start_clock();
  endtask

  //--------------------------------------------------------------------
  // Task: delay
  //
  // Helper task to wait for a specified number of clock cycles.
  //
  // Parameters:
  //   x - The number of positive clock edges to wait for.
  //--------------------------------------------------------------------
  task automatic delay(int x = 1);
    repeat (x) @(posedge ctrl_if.clk);
  endtask

endclass

`endif
