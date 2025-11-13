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
        write_traffic('1, 8'h14, 32'hFB, 4'hf);        
        #1500us;
        write_traffic('0, 8'h1C, '0, '0);
        #500ns;
        phase.drop_objection(this);

    endtask

    task write_traffic (logic isWrite, logic [7:0] addr, logic [31:0] data, logic [3:0] strb);
        if (isWrite) begin
            u_uart_traffic_sequence.isWriteTraffic = isWrite;
            u_uart_traffic_sequence.addr = addr;
            u_uart_traffic_sequence.data = data;
            u_uart_traffic_sequence.strb = strb;
            u_uart_traffic_sequence.start(u_axi_env.u_axi_agent.u_axi_sequencer);
        end else begin
            u_uart_traffic_sequence.isWriteTraffic = isWrite;
            u_uart_traffic_sequence.addr = addr;
            u_uart_traffic_sequence.start(u_axi_env.u_axi_agent.u_axi_sequencer);
        end
    endtask

endclass