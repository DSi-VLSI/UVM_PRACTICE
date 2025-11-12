`include "dependencies.svh"

class uart_env extends uvm_env;

    `uvm_component_utils(uart_env)

    function new(string name="uart_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uart_agent u_uart_agent;
    uart_scoreboard u_uart_scoreboard;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        u_uart_agent = uart_agent::type_id::create("u_uart_agent", this);
        u_uart_scoreboard = uart_scoreboard::type_id::create("u_uart_scoreboard", this); 
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        u_uart_agent.u_uart_monitor.mon_analysis_port.connect(u_uart_scoreboard.m_analysis_imp);
    endfunction

endclass

    