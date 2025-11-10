
//  Class: uart_scoreboard
//
class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard);


    function new(string name = "uart_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    
        `uvm_info(get_full_name(), "Scoreboard Build Phase", UVM_HIGH);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    
        `uvm_info(get_name(), "Scoreboard Connect Phase", UVM_HIGH)
        
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "Scoreboard run phase started, objection raised.", UVM_HIGH)
    
        
    
        phase.drop_objection(this);
        `uvm_info(get_name(), "Scoreboard run phase finished, objection dropped.", UVM_HIGH)
    endtask: run_phase
    
    
    

    
endclass
