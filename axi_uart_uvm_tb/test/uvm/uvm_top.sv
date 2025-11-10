`include "dependencies.svh"

module uvm_top;

    logic clk, rst_n;

    axi_intf #(
        .axi_req_t  (uvm_tb_axi_req_t),
        .axi_resp_t (uvm_tb_axi_resp_t)
    ) u_axi_intf (
        .clk        (clk),
        .rst_n      (rst_n)
    );

    uart_intf u_uart_intf (
        .clk        (clk)
    );

    uart_top #(
        .req_t      (uvm_tb_axi_req_t),
        .resp_t     (uvm_tb_axi_resp_t)
    ) u_dut (
        .arst_ni    (rst_n),
        .clk_i      (clk),  
        .req_i      (u_axi_intf.axi_req),  
        .resp_o     (u_axi_intf.axi_resp),
        .tx_o       (u_uart_intf.tx),
        .rx_i       (u_uart_intf.rx),
        .irq_o      (u_uart_intf.irq)  
    );

    task automatic start_clk(int clk_freq_MHz);
        real time_period;
        time_period = 1000 / clk_freq_MHz;
        fork
            forever begin
                clk <= '0;
                #(time_period / 2);
                clk <= '1;
                #(time_period / 2);
            end
        join_none
    endtask

    initial begin
        string testname;
        $value$plusargs("TESTNAME=%s", testname);
        uvm_config_db #(virtual axi_intf #(uvm_tb_axi_req_t, uvm_tb_axi_resp_t))::set(null, "*", "axi_intf_1", u_axi_intf);
        uvm_config_db #(virtual uart_intf)::set(null, "*", "uart_intf_1", u_uart_intf);

        start_clk(100);

        run_test(testname);
    end

endmodule