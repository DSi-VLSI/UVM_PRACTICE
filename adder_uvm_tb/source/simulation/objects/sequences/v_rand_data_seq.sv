//----------------------------------------------------------------------
// Class: v_rand_data_seq
//
// This virtual sequence runs on the virtual sequencer (`cust_vsqr`).
// Its purpose is to start and coordinate other sequences on the individual
// agent sequencers. In this case, it concurrently starts two instances
// of `rand_data_seq`, one for each input operand ('opa' and 'opb'),
// to drive random data to the DUT simultaneously.
//----------------------------------------------------------------------

`ifndef __CUST_V_RAND_DATA_SEQ_SV__
`define __CUST_V_RAND_DATA_SEQ_SV__ 0

`include "rand_data_seq.sv"

class v_rand_data_seq extends uvm_sequence;

  // UVM Factory Registration
  `uvm_object_utils(v_rand_data_seq)

  // Macro to get a typed handle (p_sequencer) to the target virtual sequencer.
  `uvm_declare_p_sequencer(cust_vsqr)

  // Constructor: new
  // Standard UVM constructor.
  function new(string name = "v_rand_data_seq");
    super.new(name);
  endfunction

  // Task: body
  // The main execution body of the sequence.
  virtual task body();
    // Declare handles for the sub-sequences that will run on the agent sequencers.
    rand_data_seq seq_opa;
    rand_data_seq seq_opb;

    // Create the sub-sequence objects.
    seq_opa = rand_data_seq::type_id::create("seq_opa");
    seq_opb = rand_data_seq::type_id::create("seq_opb");

    // Use fork/join to start both sequences in parallel.
    // Each sequence is started on its respective agent sequencer, which is
    // accessed through the virtual sequencer handle (p_sequencer).
    fork
      seq_opa.start(p_sequencer.sqr_opa);
      seq_opb.start(p_sequencer.sqr_opb);
    join
  endtask

endclass

`endif
