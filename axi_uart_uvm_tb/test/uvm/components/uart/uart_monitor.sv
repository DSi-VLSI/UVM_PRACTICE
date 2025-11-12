`include "dependencies.svh"

class uart_monitor extends uvm_monitor;

    `uvm_component_utils(uart_monitor)

    function new(string name="uart_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(uart_tx_item) tx_analysis_port;
    uvm_analysis_port #(uart_rx_item) rx_analysis_port;
    virtual uart_intf u_uart_intf;

    logic previous_tx;
    logic tx;
    logic previous_rx;
    logic rx;

    int baud_divisor = 10417;

    typedef logic [15:0] serial_to_parallel_t;
    serial_to_parallel_t tx_array;
    serial_to_parallel_t rx_array;
    int tx_counter;
    int rx_counter;

    typedef enum {IDLE, START, DATA, STOP} uart_state_t;
    uart_state_t tx_state;
    uart_state_t rx_state;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tx_analysis_port = new("tx_analysis_port", this);
        rx_analysis_port = new("rx_analysis_port", this);
        if(uvm_config_db #(virtual uart_intf)::get(
            this, "", "uart_intf", u_uart_intf
        )) begin
            `uvm_info(get_name(), "UART INTERFACE FOUND", UVM_LOW)
        end else begin
            `uvm_error(get_name(), "UART INTERFACE NOT FOUND")
        end
        tx_state = IDLE;
        rx_state = IDLE;
        tx_counter = '0;
        rx_counter = '0;
        tx_array   = '0;
        rx_array   = '0;
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            begin
                sample_port("tx_thread");
            end
            begin
                sample_port("rx_thread");
            end
        join
    endtask

    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        $display("%b", tx_array);
        $display("%b", rx_array);
    endfunction

    task sample_port(string tag="");
        uart_tx_item tx_item;
        uart_rx_item rx_item;

        tx_item = uart_tx_item::type_id::create("tx_item");
        rx_item = uart_rx_item::type_id::create("rx_item");

        forever begin
            @(posedge u_uart_intf.clk);

            // TX
            if (tag == "tx_thread") begin
                if (tx_state == IDLE && previous_tx === '1 && u_uart_intf.tx === '0) begin
                    tx_state = START;
                    $display("tx: %b", u_uart_intf.tx);
                    repeat (baud_divisor / 2) @(posedge u_uart_intf.clk);
                end
                else if (tx_state == START) begin
                    `uvm_info(get_name(), "TX STARTED", UVM_LOW)
                    tx_state = DATA;
                    $display("tx: %b", u_uart_intf.tx);
                    repeat (baud_divisor) @(posedge u_uart_intf.clk);
                end
                else if (tx_state == DATA) begin
                    int data_bit_count = 8;
                    for (int i = 0; i < data_bit_count; i++) begin
                        tx_array[tx_counter] = u_uart_intf.tx;
                        tx_counter++;
                        `uvm_info(get_name(), "TX DATA ACQUIRED", UVM_LOW)
                        if(i == data_bit_count - 1) begin
                            tx_state = STOP;
                        end
                        $display("tx: %b", u_uart_intf.tx);
                        repeat (baud_divisor) @(posedge u_uart_intf.clk);
                    end
                end
                else if (tx_state == STOP) begin
                    int stop_bit_count = 1;
                    tx_item.tx_array = tx_array;
                    tx_analysis_port.write(tx_item);
                    for (int i = 0; i < stop_bit_count; i++) begin
                        `uvm_info(get_name(), "TX STOPPED", UVM_LOW)
                        if(i == stop_bit_count - 1) begin
                            tx_state = IDLE;
                            tx_counter = 0;
                        end
                        $display("tx: %b", u_uart_intf.tx);
                        repeat (baud_divisor) @(posedge u_uart_intf.clk);
                    end
                end
                previous_tx = u_uart_intf.tx;
            end

            // RX
            else if (tag == "rx_thread") begin
                if (rx_state == IDLE && previous_rx === '1 && u_uart_intf.rx === '0) begin
                    rx_state = START;
                    $display("rx: %b", u_uart_intf.rx);
                    repeat (baud_divisor / 2) @(posedge u_uart_intf.clk);
                end
                else if (rx_state == START) begin
                    `uvm_info(get_name(), "RX STARTED", UVM_LOW)
                    rx_state = DATA;
                    $display("rx: %b", u_uart_intf.rx);
                    repeat (baud_divisor) @(posedge u_uart_intf.clk);
                end
                else if (rx_state == DATA) begin
                    int data_bit_count = 8;
                    for (int i = 0; i < data_bit_count; i++) begin
                        rx_array[rx_counter] = u_uart_intf.rx;
                        rx_counter++;
                        `uvm_info(get_name(), "RX DATA ACQUIRED", UVM_LOW)
                        if(i == data_bit_count - 1) begin
                            rx_state = STOP;
                        end
                        $display("rx: %b", u_uart_intf.rx);
                        repeat (baud_divisor) @(posedge u_uart_intf.clk);
                    end
                end
                else if (rx_state == STOP) begin
                    int stop_bit_count = 1;
                    rx_item.rx_array = rx_array;
                    rx_analysis_port.write(rx_item);
                    for (int i = 0; i < stop_bit_count; i++) begin
                        `uvm_info(get_name(), "RX STOPPED", UVM_LOW)
                        if(i == stop_bit_count - 1) begin
                            rx_state = IDLE;
                            rx_counter = 0;
                        end
                        $display("rx: %b", u_uart_intf.rx);
                        repeat (baud_divisor) @(posedge u_uart_intf.clk);
                    end
                end
                previous_rx = u_uart_intf.rx;
            end

        end
    endtask

endclass

    