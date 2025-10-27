//----------------------------------------------------------------------
// Class: cust_vsqr
//
// The virtual sequencer is a container for the actual sequencers that
// generate stimulus for the different interfaces of the DUT. It is used
// to coordinate and synchronize sequences running on multiple sequencers.
// In this testbench, it holds handles to the sequencers for the 'opa'
// and 'opb' input agents.
//----------------------------------------------------------------------

`ifndef __CUST_CUST_VSQR_SV__
`define __CUST_CUST_VSQR_SV__ 0

`include "seq_item.sv"

class cust_vsqr extends uvm_sequencer;

  // UVM Factory Registration
  `uvm_component_utils(cust_vsqr)

  //--------------------------------------------------------------------
  // Component Handles
  //--------------------------------------------------------------------

  // Handle to the sequencer for the 'opa' agent.
  uvm_sequencer #(seq_item) sqr_opa;

  // Handle to the sequencer for the 'opb' agent.
  uvm_sequencer #(seq_item) sqr_opb;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  // Constructor: new
  // Standard UVM constructor.
  function new(string name = "cust_vsqr", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif
