//----------------------------------------------------------------------
// Class: cust_env
//
// The environment class is a container that instantiates and connects
// the major verification components of the testbench, such as agents
// for each interface and the scoreboard for checking.
//----------------------------------------------------------------------

`ifndef __CUST_ENV_SV__
`define __CUST_ENV_SV__ 0

`include "cust_vsqr.sv"
`include "cust_agn.sv"
`include "cust_scb.sv"

class cust_env extends uvm_env;

  // UVM Factory Registration
  `uvm_component_utils(cust_env)

  //--------------------------------------------------------------------
  // Component Handles
  //--------------------------------------------------------------------

  // Virtual sequencer pointing to the sequencers in agent_opa and agent_opb.
  cust_vsqr vsqr;

  // Agent for the 'opa' input interface. Configured as a transmitter ("tx").
  cust_agn  agent_opa;

  // Agent for the 'opb' input interface. Configured as a transmitter ("tx").
  cust_agn  agent_opb;

  // Agent for the 'sum' output interface. Configured as a receiver ("rx").
  cust_agn  agent_sum;

  // The scoreboard is used for end-to-end checking of the DUT's functionality.
  cust_scb  scbd;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  // Constructor: new
  // Standard UVM constructor.
  function new(string name = "cust_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Function: build_phase
  // Creates the agents and the scoreboard. The 'opa' and 'opb' agents are
  // configured as active transmitters ("tx"), while the 'sum' agent is
  // configured as a passive receiver ("rx").
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    vsqr = cust_vsqr::type_id::create($sformatf("vsqr"), this);
    agent_opa = cust_agn::type_id::create($sformatf("agent_opa"), this);
    agent_opa.port = "opa";
    agent_opa.role = "tx";
    agent_opb = cust_agn::type_id::create($sformatf("agent_opb"), this);
    agent_opb.port = "opb";
    agent_opb.role = "tx";
    agent_sum = cust_agn::type_id::create($sformatf("agent_sum"), this);
    agent_sum.port = "sum";
    agent_sum.role = "rx";
    scbd = cust_scb::type_id::create($sformatf("scbd"), this);
  endfunction

  // Function: connect_phase
  // Connects the analysis ports of the monitors within each agent to the
  // corresponding analysis implementation ports in the scoreboard. This allows
  // the scoreboard to receive all transactions observed on the interfaces.
  function void connect_phase(uvm_phase phase);
    vsqr.sqr_opa = agent_opa.sqr;
    vsqr.sqr_opb = agent_opb.sqr;
    agent_opa.mon.mon_analysis_port.connect(scbd.m_analysis_imp_opa);
    agent_opb.mon.mon_analysis_port.connect(scbd.m_analysis_imp_opb);
    agent_sum.mon.mon_analysis_port.connect(scbd.m_analysis_imp_sum);
  endfunction

endclass

`endif
