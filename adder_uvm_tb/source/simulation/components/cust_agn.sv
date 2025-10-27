//----------------------------------------------------------------------
// Class: cust_agn
//
// The agent is a configurable container component that encapsulates the driver,
// sequencer, and monitor for a specific interface. It can be configured into
// an active stimulus-generating role ("tx") or a reactive/responder role ("rx").
// The "tx" role includes a sequencer, driver, and monitor. The "rx" role
// includes a driver and monitor.
//----------------------------------------------------------------------

`ifndef __CUST_AGN_SV__
`define __CUST_AGN_SV__ 0

`include "cust_dvr.sv"
`include "cust_mon.sv"

class cust_agn extends uvm_agent;

  // UVM Factory Registration
  `uvm_component_utils(cust_agn)

  //--------------------------------------------------------------------
  // Component Handles
  //--------------------------------------------------------------------

  // The sequencer controls the flow of sequence items to the driver.
  uvm_sequencer #(seq_item) sqr;
  // The driver converts sequence items into pin-level activity.
  cust_dvr                  dvr;
  // The monitor observes pin-level activity and converts it into transactions.
  cust_mon                  mon;

  // Specifies the interface this agent is associated with (e.g., "opa", "opb", "sum").
  // This is passed to sub-components to retrieve the correct virtual interface.
  string                    port;

  // Determines the agent's operational mode (e.g., "tx" for active/transmitter, "rx" for receiver).
  // This controls which sub-components are built and how they are configured.
  string                    role;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  // Constructor: new
  // Standard UVM constructor. The 'port' and 'role' parameters are used to
  // configure the agent's target interface and operational mode.
  function new(string name = "cust_agn", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Function: build_phase
  // Creates the agent's sub-components based on its configured 'role'.
  // - "tx" (active): Creates sequencer, driver, and monitor.
  // - "rx" (reactive): Creates driver and monitor.
  // The monitor is always created to ensure observability.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (role == "tx") begin
      sqr = uvm_sequencer#(seq_item)::type_id::create($sformatf("sqr"), this);
    end
    dvr = cust_dvr::type_id::create($sformatf("dvr"), this);
    dvr.port = port;
    dvr.role = role;
    mon = cust_mon::type_id::create($sformatf("mon"), this);
    mon.port = port;
  endfunction

  // Function: connect_phase
  // Connects the driver to the sequencer if the agent is in an active role ("tx").
  // The monitor's analysis port is connected at a higher level (e.g., in the environment).
  function void connect_phase(uvm_phase phase);
    if (role == "tx") begin
      dvr.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction

endclass

`endif
