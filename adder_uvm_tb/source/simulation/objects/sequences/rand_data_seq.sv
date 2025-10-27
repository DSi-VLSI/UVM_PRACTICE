//----------------------------------------------------------------------
// Class: rand_data_seq
//
// This sequence generates a stream of random transactions (`seq_item`).
// It creates, randomizes, and sends a specified number of items
// to the sequencer.
//----------------------------------------------------------------------

`ifndef __CUST_RAND_DATA_SEQ_SV__
`define __CUST_RAND_DATA_SEQ_SV__ 0

`include "seq_item.sv"

class rand_data_seq extends uvm_sequence #(seq_item);

  // UVM Factory Registration
  `uvm_object_utils(rand_data_seq)

  // The number of items to generate. This can be randomized or
  // overridden by a test via the uvm_config_db.
  rand int unsigned sequence_length = 10;

  //--------------------------------------------------------------------
  // Function: new
  //
  // Constructor for the rand_data_seq class.
  //
  // Parameters:
  //   name - The instance name of this sequence.
  //--------------------------------------------------------------------
  function new(string name = "rand_data_seq");
    super.new(name);
  endfunction

  //--------------------------------------------------------------------
  // Task: body
  //
  // The main logic of the sequence. It generates and sends a stream
  // of randomized `seq_item` transactions to the driver.
  //--------------------------------------------------------------------
  virtual task body();
    // Attempt to get sequence_length from config_db. If not found,
    // the default or randomized value of the class property is used.
    // The context 'this' makes the lookup relative to this sequence's
    // position in the hierarchy.
    void'(uvm_config_db#(int)::get(uvm_root::get(), "test", "sequence_length", sequence_length));

    `uvm_info(get_type_name(), $sformatf("Generating %0d items.", sequence_length), UVM_LOW)

    // Generate the specified number of transactions.
    // The `uvm_do macro is a convenient way to create, randomize, and
    // send a sequence item. It encapsulates the create, start_item,
    // randomize, and finish_item calls.
    for (int i = 0; i < sequence_length; i++) begin
      // // 1. Create the request item using the factory.
      // seq_item item = seq_item::type_id::create("item");
      // // 2. Indicate the start of a new item. This will wait for the driver
      // //    to be ready to accept a new transaction.
      // start_item(item);
      // // 3. Randomize the item. If randomization fails, report a fatal error.
      // if (!item.randomize()) begin
      //   `uvm_fatal(get_type_name(), "Failed to randomize sequence item")
      // end
      // // 4. Send the randomized item to the driver.
      // finish_item(item);

      // // alternatively, you could use:
      // The `req` object is a built-in member of uvm_sequence.
      // `uvm_do will create, randomize, and send it.
      `uvm_do(req)
    end

  endtask

endclass

`endif
