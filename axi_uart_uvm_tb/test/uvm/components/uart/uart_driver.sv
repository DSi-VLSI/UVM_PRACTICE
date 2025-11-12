`include "dependencies.svh"

class uart_driver extends uvm_driver #(dut_seq_item);

    `uvm_component_utils(uart_driver)

    function new(string name="uart_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual uart_intf u_uart_intf;
    dut_seq_item item;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(uvm_config_db #(virtual uart_intf)::get(
            this, "", "uart_intf", u_uart_intf
        ))begin
            `uvm_info(get_name(), "UART INTERFACE FOUND", UVM_LOW)
        end else begin
            `uvm_error(get_name(), "UART INTERFACE NOT FOUND")
        end
        item = dut_seq_item::type_id::create("uart_dvr_item");
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(posedge u_uart_intf.clk);
            seq_item_port.get_next_item(item);
            drive_item(item);
            seq_item_port.item_done(item);
        end
    endtask

    task drive_item(dut_seq_item item);
        u_uart_intf.rx <= item.rx;
        item.tx <= u_uart_intf.tx;
    endtask

endclass

    