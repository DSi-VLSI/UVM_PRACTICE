//----------------------------------------------------------------------
// Class: cust_dvr
//
// The driver is responsible for receiving transactions (seq_item) from
// the sequencer and driving them onto the physical interface according
// to the DUT's protocol. It implements the pin-level activity based
// on the abstract data from the sequence item.
//----------------------------------------------------------------------

`ifndef __CUST_DVR_SV__
`define __CUST_DVR_SV__ 0

`include "seq_item.sv"
`include "data_intf.sv"

class cust_dvr extends uvm_driver #(seq_item);

  // UVM Factory Registration
  `uvm_component_utils(cust_dvr)

  // Virtual interface handle to connect to the DUT's interface.
  // This provides the driver with access to the physical signals.
  virtual data_intf intf;

  // Port name for the driver, used for configuration (e.g., "opa", "opb", "sum").
  // This is used to retrieve the correct virtual interface from the config_db.
  string            port;

  // Role of the driver (e.g., "tx" for transmitter, "rx" for receiver).
  // This determines the driver's behavior in the run_phase.
  string            role;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  //--------------------------------------------------------------------
  // Function: new
  //
  // Constructor for the cust_dvr class.
  //
  // Parameters:
  //   name   - The instance name of this component.
  //   parent - The parent component in the UVM hierarchy.
  //--------------------------------------------------------------------
  function new(string name = "cust_dvr", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------------------------
  // Function: build_phase
  //
  // Retrieves configuration from the uvm_config_db, including the
  // virtual interface handle. The 'port' string is used as a key
  // to find the correct interface in the database.
  //--------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual data_intf)::get(uvm_root::get(), port, "vif", intf))
      `uvm_fatal("NOVIF", $sformatf("Virtual interface not found for port:%s", port))
  endfunction

  //--------------------------------------------------------------------
  // Task: run_phase
  //
  // The main operational task for the driver. It runs continuously,
  // processing items based on its configured 'role'.
  //
  // - If role is "tx", it gets items from the sequencer and drives
  //   them onto the interface using a valid/ready handshake.
  // - If role is "rx", it models a receiver by randomly asserting
  //   the 'ready' signal.
  //
  // The task is forked so it does not block the phase from ending.
  //--------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    int min_delay, max_delay;

    // Retrieve timing configuration from the database.
    void'(uvm_config_db#(int)::get(uvm_root::get(), port, "min_delay", min_delay));
    void'(uvm_config_db#(int)::get(uvm_root::get(), port, "max_delay", max_delay));

    // Fork the main driver loop so this phase doesn't block.
    if (role == "tx") begin
      fork
        forever begin
          seq_item req;

          // Wait until not in reset before starting a new transaction.
          @(posedge intf.clk_i);
          if (intf.arst_ni == 1'b0) begin
            `uvm_info(get_type_name(), "In reset, waiting for reset de-assertion", UVM_MEDIUM)
            @(posedge intf.arst_ni);  // Wait for reset to end
          end

          // Get the next transaction item from the sequencer.
          seq_item_port.get_next_item(req);

          // Insert a random delay before driving the transaction.
          repeat ($urandom_range(min_delay, max_delay)) @(posedge intf.clk_i);

          // Send the data using the interface's send_data task.
          intf.send_data(req.data);

          // If the handshake completed without a reset, finish the item.
          // Otherwise, the item is considered dropped and we do not call item_done.
          if (intf.arst_ni == 1'b1) begin
            seq_item_port.item_done();
          end else begin
            `uvm_warning(get_type_name(), "Transaction dropped due to reset")
          end
        end
      join_none
    end else if (role == "rx") begin
      // Models the behavior of a receiver, randomly asserting 'ready'.
      fork
        forever begin
          // Wait for a random delay, but check for reset each cycle.
          logic [127:0] dummy_data;
          int cycles_to_wait = $urandom_range(min_delay, max_delay);
          repeat (cycles_to_wait) @(posedge intf.clk_i);

          // Only receive data if not in reset
          if (intf.arst_ni == 1'b1) begin
            intf.recv_data(dummy_data);
          end
        end
      join_none
    end
  endtask

endclass

`endif
