
//  Class: apb_agent
//
class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent);
    apb_driver apb_drvr;
    apb_monitor apb_mntr;
    apb_sequencer apb_seqr;



    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_drvr = apb_driver::type_id::create("apb_drvr", this);
        apb_mntr = apb_monitor::type_id::create("apb_mntr", this);
        apb_seqr = apb_sequencer::type_id::create("apb_seqr", this);
        `uvm_info("", "Agent Build Phase", UVM_LOW);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        apb_drvr.seq_item_port.connect(apb_seqr.seq_item_export);
        `uvm_info("", "Agent Connect Phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        `uvm_info("", "Agent run phase started", UVM_HIGH);
    endtask

   
    
endclass

