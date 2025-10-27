//----------------------------------------------------------------------
// Class: simple_test
//
// A simple test case that sends random data through both input agents
// simultaneously and waits for all transactions to be processed.
//----------------------------------------------------------------------

`ifndef __CUST_SIMPLE_TEST_SV__
`define __CUST_SIMPLE_TEST_SV__ 0

`include "base_test.sv"
`include "rand_data_seq.sv"

class simple_test extends base_test;

  // UVM Factory Registration
  `uvm_component_utils(simple_test)

  // The number of transactions to run in this test.
  // This can be overridden from a higher level (e.g., command line).
  int sequence_length = 20;

  //--------------------------------------------------------------------
  // Function: new
  //
  // Standard UVM constructor.
  //
  // Parameters:
  //   name   - The instance name of this component.
  //   parent - The parent component in the UVM hierarchy.
  //--------------------------------------------------------------------
  function new(string name = "simple_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------------------
  // Function: build_phase
  //
  // Configures the test environment by setting the sequence length
  // for the sequences that will run on the sequencers.
  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Set the sequence_length in the config_db for the sequences to use.
    // The path is relative to the sequencer component where the sequence will run.
    uvm_config_db#(int)::set(uvm_root::get(), "test", "sequence_length", sequence_length);

    // Set min/max delay constraints for the drivers. These values are retrieved
    // by the drivers (cust_dvr) to introduce random delays between transactions,
    // which helps in verifying the DUT's robustness to timing variations.
    // The keys "opa", "opb", and "sum" match the 'port' names of the drivers.
    uvm_config_db#(int)::set(uvm_root::get(), "opa", "min_delay", 0);
    uvm_config_db#(int)::set(uvm_root::get(), "opb", "min_delay", 0);
    uvm_config_db#(int)::set(uvm_root::get(), "sum", "min_delay", 0);

    uvm_config_db#(int)::set(uvm_root::get(), "opa", "max_delay", 5);
    uvm_config_db#(int)::set(uvm_root::get(), "opb", "max_delay", 5);
    uvm_config_db#(int)::set(uvm_root::get(), "sum", "max_delay", 5);
  endfunction

  //--------------------------------------------------------------------
  // Task: run_phase
  //
  // The main execution block for the test. It starts parallel sequences
  // on the input agents and waits for them to complete.
  //
  // Parameters:
  //   phase - The UVM phase object, providing context about the current phase.
  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    // Call the parent run_phase to apply reset and start the clock.
    // This is done after raising the objection.
    super.run_phase(phase);

    // Raise an objection to prevent the simulation from ending while
    // the sequences are running.
    phase.raise_objection(this);

    `uvm_info(get_type_name(), $sformatf("Starting test with sequence_length = %0d",
                                         sequence_length), UVM_LOW)

    begin
      // Create the sequences to be sent to the drivers.
      rand_data_seq seq_a = rand_data_seq::type_id::create("seq_a");
      rand_data_seq seq_b = rand_data_seq::type_id::create("seq_b");

      // Start the sequences on their respective agent sequencers in parallel.
      // fork...join_none allows the test to continue while sequences are running.
      fork
        seq_a.start(env.agent_opa.sqr);
        seq_b.start(env.agent_opb.sqr);
      join_none
    end

    // Wait until all agents have processed the expected number of transactions.
    // This test uses a polling mechanism, checking transaction counts that
    // are updated by the monitors and placed in the config_db.
    begin
      int count_a = 0;
      int count_b = 0;
      int count_sum = 0;

      do begin
        delay();  // Wait for a clock cycle (defined in base_test).
        // Get the current transaction counts from the config_db. A more
        // advanced testbench might use a uvm_barrier or scoreboard event.
        void'(uvm_config_db#(int)::get(uvm_root::get(), "opa", "transaction_count", count_a));
        void'(uvm_config_db#(int)::get(uvm_root::get(), "opb", "transaction_count", count_b));
        void'(uvm_config_db#(int)::get(uvm_root::get(), "sum", "transaction_count", count_sum));
      end while (count_a < sequence_length || count_b < sequence_length ||
                 count_sum < sequence_length);
    end

    // Add a small delay for the last transaction to propagate before ending.
    delay(10);

    // Drop the objection
    phase.drop_objection(this);

  endtask

endclass : simple_test

`endif
