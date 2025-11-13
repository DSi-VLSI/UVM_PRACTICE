
class uart_environment extends uvm_env;
    `uvm_component_utils(uart_environment)

    uart_scoreboard scb;
    apb_agent apb_agnt;
    uart_agent uart_agnt;



    function new(string name = "uart_environment", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("Environment ", "Constructed", UVM_DEBUG);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scb = uart_scoreboard::type_id::create("scb", this);
        apb_agnt = apb_agent::type_id::create("apb_agnt", this);
        uart_agnt = uart_agent::type_id::create("uart_agnt", this);
        `uvm_info("Environment ", "Build", UVM_DEBUG);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        apb_agnt.apb_mntr.apb_port.connect(scb.apb_imp);
        uart_agnt.uart_mntr.uart_port.connect(scb.uart_imp);
        `uvm_info("Environment ", "Connected", UVM_DEBUG)
    endfunction


    task run_phase(uvm_phase phase);

        phase.raise_objection(this);
        `uvm_info("Environment ", "run phase started, objection raised.", UVM_DEBUG)

        phase.drop_objection(this);
        `uvm_info("Environment ", "run phase finished, objection dropped.", UVM_DEBUG)
    endtask

    
endclass