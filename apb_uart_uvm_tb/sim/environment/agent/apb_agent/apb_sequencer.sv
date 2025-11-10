
//  Class: apb_sequencer
//
class apb_sequencer extends uvm_sequencer #(seq_item);
    `uvm_component_utils(apb_sequencer);

    function new(string name = "apb_sequencer", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_full_name(), $sformatf("[Sequencer] :: Sequencer Constructed"), UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), $sformatf("[Sequencer] :: Sequencer Build Phase"), UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), $sformatf("[Sequencer] :: Sequencer Connect Phase"), UVM_LOW)
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), $sformatf("[Sequencer] :: Sequencer run phase started"), UVM_HIGH);
    endtask

    
endclass
