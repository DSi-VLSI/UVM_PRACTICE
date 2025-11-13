
//  Class: uart_sequencer
//
class uart_sequencer extends uvm_sequencer #(uart_seq_item);
    `uvm_component_utils(uart_sequencer);

    function new(string name = "uart_sequencer", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("UART_Sequencer", $sformatf("Constructed"), UVM_DEBUG);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("UART_Sequencer", $sformatf("Build"), UVM_DEBUG);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("UART_Sequencer", $sformatf("Connected"), UVM_DEBUG)
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("UART_Sequencer", $sformatf("run phase started"), UVM_DEBUG);
    endtask

    
endclass
