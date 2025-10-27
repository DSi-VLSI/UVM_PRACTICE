//----------------------------------------------------------------------
// Class: rsp_item
//
// This class defines the transaction captured by a monitor from the
// DUT's output. It is typically created by a monitor and broadcast
// through an analysis port to components like a scoreboard.
//
// It extends `seq_item` to reuse the `data` field for carrying the
// observed result.
//----------------------------------------------------------------------

`ifndef __CUST_RSP_ITEM_SV__
`define __CUST_RSP_ITEM_SV__ 0

`include "seq_item.sv"

class rsp_item extends seq_item;

  // UVM Factory Registration
  `uvm_object_utils(rsp_item)

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  //--------------------------------------------------------------------
  // Function: new
  //
  // Constructor for the rsp_item class.
  //
  // Parameters:
  //   name - The instance name of this object.
  //--------------------------------------------------------------------
  function new(string name = "rsp_item");
    super.new(name);
  endfunction

endclass

`endif
