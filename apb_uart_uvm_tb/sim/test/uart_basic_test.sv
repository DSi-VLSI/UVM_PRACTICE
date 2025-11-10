
//  Class: uart_basic_test
//
class uart_basic_test extends uart_base_test;
    `uvm_component_utils(uart_basic_test)

    function new(string name = "uart_basic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "Basic Test Build Phase", UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), "Basic Test Connect Phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "Basic Test run phase started, objection raised.", UVM_LOW);
        
        write(1'b0, 'd8, 'h1001, 'b1111);
        read(1'b0, 'd8);
        
    
        phase.drop_objection(this);
        `uvm_info(get_name(), "Basic Test run phase finished, objection dropped.", UVM_LOW);
    endtask
    



    
endclass
