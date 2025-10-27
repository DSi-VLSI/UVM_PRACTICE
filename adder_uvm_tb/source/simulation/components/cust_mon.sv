
//----------------------------------------------------------------------
// Class: cust_mon
//
// The monitor is a passive component that observes pin-level activity
// on the DUT's interface and converts it into transaction objects
// (rsp_item). These transactions are then broadcasted to other
// components, typically a scoreboard, for checking.
//----------------------------------------------------------------------

`ifndef __CUST_MON_SV__
`define __CUST_MON_SV__ 0

`include "data_intf.sv"
`include "rsp_item.sv"

class cust_mon extends uvm_monitor;

  // UVM Factory Registration
  `uvm_component_utils(cust_mon)

  // Virtual interface handle to connect to the DUT's interface.
  // This provides the monitor with access to the physical signals to observe.
  virtual data_intf             intf;

  // Port name for the monitor, used for configuration (e.g., "opa", "opb", "sum").
  // This is used to retrieve the correct virtual interface from the config_db.
  string                        port;

  // Number of transactions observed by the monitor.
  int                           number_of_transactions;

  // Analysis port used to broadcast observed transactions to subscribers.
  uvm_analysis_port #(rsp_item) mon_analysis_port;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  // Constructor: new
  // Standard UVM constructor. The 'port' parameter allows for configuring
  // which interface this monitor instance will observe.
  function new(string name = "cust_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Function: build_phase
  // Creates the analysis port for broadcasting transactions and retrieves
  // the virtual interface handle from the uvm_config_db.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_analysis_port = new("mon_analysis_port", this);
    if (!uvm_config_db#(virtual data_intf)::get(uvm_root::get(), port, "vif", intf))
      `uvm_fatal("NOVIF", $sformatf("Virtual interface not found for port:%s", port))
  endfunction

  // Task: run_phase
  // The main operational task for the monitor. It runs continuously,
  // sampling the interface and generating transactions.
  task run_phase(uvm_phase phase);
    // Initialize the number of transactions to zero.
    number_of_transactions = 0;
    // Update the transaction count in the uvm_config_db
    uvm_config_db#(int)::set(uvm_root::get(), port, "transaction_count", number_of_transactions);
    // Use fork..join_none to allow the run_phase to proceed without
    // being blocked by the main monitor loop.
    fork
      forever begin
        rsp_item item;
        // Create a new response item for each transaction.
        item = new();

        // Capture the observed data
        intf.look_data(item.data);

        // Broadcast the captured transaction through the analysis port.
        mon_analysis_port.write(item);
        // Increment the transaction count.
        number_of_transactions++;
        // Update the transaction count in the uvm_config_db
        uvm_config_db#(int)::set(uvm_root::get(), port, "transaction_count",
                                 number_of_transactions);
      end
    join_none
  endtask

endclass

`endif
