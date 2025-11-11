
`include "uvm_macros.svh"
import uvm_pkg::*;
import test_pkg::*;

module apb_tb_top;

    bit clk;

    initial forever #5 clk = ~clk;

    // Interface instances
    apb_interface   apb_inf (.pclk(clk));
    uart_interface  uart_inf (.pclk(clk));

    // DUT instantiation
    uart_top DUT(
        .arst_ni(apb_inf.presetn),
        .clk_i(apb_inf.pclk),
        .req_i(apb_inf.apb_req),
        .resp_o(apb_inf.apb_resp),
        .tx_o(uart_inf.tx_o),
        .rx_i(uart_inf.rx_i),
        .irq_o(uart_inf.irq_o)
    );



    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, apb_tb_top);


        uvm_config_db #(virtual apb_interface)::set(null, "*", "apb_inf", apb_inf); 
        uvm_config_db #(virtual uart_interface)::set(null, "*", "uart_inf", uart_inf); 

        
        run_test();
    end



    
endmodule