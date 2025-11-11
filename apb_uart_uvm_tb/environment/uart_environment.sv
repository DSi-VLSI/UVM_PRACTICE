
class uart_environment extends uvm_env;
    `uvm_component_utils(uart_environment)

    uart_scoreboard scb;
    apb_agent apb_agnt;
    uart_agent uart_agnt;



    function new(string name = "uart_environment", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_full_name, "Environment Constructed", UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scb = uart_scoreboard::type_id::create("scb", this);
        apb_agnt = apb_agent::type_id::create("apb_agnt", this);
        uart_agnt = uart_agent::type_id::create("uart_agnt", this);
        `uvm_info(get_full_name, "Environment Build Phase", UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name, "Environment Connect Phase", UVM_LOW)
    endfunction


    task run_phase(uvm_phase phase);

        phase.raise_objection(this);
        `uvm_info(get_full_name, "Environment run phase started, objection raised.", UVM_LOW)

        phase.drop_objection(this);
        `uvm_info(get_full_name, "Environment run phase finished, objection dropped.", UVM_LOW)
    endtask

    
endclass