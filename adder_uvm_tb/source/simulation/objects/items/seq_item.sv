//----------------------------------------------------------------------
// Class: seq_item
//
// This class defines the basic transaction item for this testbench.
// It contains the data payload that is transferred between the
// sequencer and the driver.
//----------------------------------------------------------------------

`ifndef __CUST_SEQ_ITEM_SV__
`define __CUST_SEQ_ITEM_SV__ 0

class seq_item extends uvm_sequence_item;

  // UVM Factory Registration and Field Macros
  // This provides implementations for print, copy, compare, etc.
  `uvm_object_utils_begin(seq_item)
  // Register the 'data' field for UVM automation
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  //--------------------------------------------------------------------
  // Data Members
  //--------------------------------------------------------------------

  // The data payload for the transaction.
  // 'rand' allows this field to be randomized by a sequence.
  // The width is fixed at a large value (128 bits) to accommodate various
  // DUT configurations. The `post_randomize` function will later trim this
  // value to the actual width used by the DUT.
  rand logic [127:0] data;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  //--------------------------------------------------------------------
  // Function: new
  //
  // Constructor for the seq_item class.
  //
  // Parameters:
  //   name - The instance name of this object.
  //--------------------------------------------------------------------
  function new(string name = "seq_item");
    super.new(name);
  endfunction

  //--------------------------------------------------------------------
  // Function: post_randomize
  //
  // This is a UVM callback executed after the object's random fields
  // have been randomized. It adjusts the randomized 'data' to the
  // specific width required by the DUT. This allows a single sequence
  // item definition to be used with DUTs of varying data widths.
  //--------------------------------------------------------------------
  function void post_randomize();
    int DATA_WIDTH;

    // Retrieve the 'data_width' from the configuration database.
    // This value is expected to be set by the test or environment.
    if (!uvm_config_db#(int)::get(uvm_root::get(), "dut", "data_width", DATA_WIDTH)) begin
      `uvm_fatal(get_type_name(),
                 "Failed to get 'data_width' from uvm_config_db. Check testbench configuration.")
    end

    // After randomization, the entire 128-bit 'data' field may contain random
    // values. This loop clears any bits beyond the configured DATA_WIDTH,
    // ensuring the value sent to the driver and DUT is correctly sized.
    for (int i = DATA_WIDTH; i < 128; i++) begin
      data[i] = 0;
    end
  endfunction

endclass

`endif
