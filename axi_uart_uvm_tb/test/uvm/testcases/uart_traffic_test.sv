`include "dependencies.svh"

class uart_traffic_test extends base_test;
    `uvm_component_utils(uart_traffic_test)

    function new(string name="uart_traffic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uart_traffic_sequence u_uart_traffic_sequence;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_uart_traffic_sequence = uart_traffic_sequence::type_id::create("u_uart_traffic_sequence");
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        u_uart_traffic_sequence.start(u_axi_env.u_axi_agent.u_axi_sequencer);
        #1500us;

        phase.drop_objection(this);

    endtask

endclass