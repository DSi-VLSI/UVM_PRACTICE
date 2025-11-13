
//  Class: apb_sequencer
//
class apb_sequencer extends uvm_sequencer #(apb_seq_item);
    `uvm_component_utils(apb_sequencer);

    function new(string name = "apb_sequencer", uvm_component parent);
        super.new(name, parent);
        `uvm_info("Sequencer", $sformatf("Constructed"), UVM_DEBUG);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Sequencer", $sformatf("Build"), UVM_DEBUG);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("Sequencer", $sformatf("Connected"), UVM_DEBUG)
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("Sequencer", $sformatf("run phase started"), UVM_DEBUG);
    endtask

    
endclass
