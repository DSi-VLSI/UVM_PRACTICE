module uart_top #(
`ifdef USE_AXI
    parameter type req_t  = base_pkg::axi_req_t,
    parameter type resp_t = base_pkg::axi_resp_t,
`elsif USE_APB
    parameter type req_t  = base_pkg::apb_req_t,
    parameter type resp_t = base_pkg::apb_resp_t,
`endif
  localparam int MEM_SIZE = 6,
  localparam int DATA_WIDTH = 32
) (
    input  logic  arst_ni,
    input  logic  clk_i,
    input  req_t  req_i,
    output resp_t resp_o
);

  logic                    mem_we;
  logic [    MEM_SIZE-1:0] mem_waddr;
  logic [  DATA_WIDTH-1:0] mem_wdata;
  logic [DATA_WIDTH/8-1:0] mem_wstrb;
  logic [             1:0] mem_wresp;

  logic                    mem_re;
  logic [    MEM_SIZE-1:0] mem_raddr;
  logic [  DATA_WIDTH-1:0] mem_rdata;
  logic [             1:0] mem_rresp;

  logic ctrl_clk_en;
  logic tx_fifo_flush;
  logic rx_fifo_flush;

  logic cfg_parity_en;
  logic cfg_parity_type;
  logic cfg_stop_bits;
  logic cfg_rx_int_en;

  logic [DATA_WIDTH-1:0] clk_div;
  logic [DATA_WIDTH-1:0] tx_fifo_count;
  logic [DATA_WIDTH-1:0] rx_fifo_count;

  logic [7:0] tx_fifo_data;
  logic       tx_fifo_data_valid;
  logic       tx_fifo_data_ready;

  logic [7:0] rx_fifo_data;
  logic       rx_fifo_data_valid;
  logic       rx_fifo_data_ready;

  logic slow_clk;

`ifdef USE_AXI
  axi_to_simple_if
`elsif USE_APB
  apb_to_simple_if
`endif
  #(
      .req_t(req_t),
      .resp_t(resp_t),
      .MEM_BASE(0),
      .MEM_SIZE(MEM_SIZE)
  ) u_cvtr (
      .arst_ni(arst_ni),
      .clk_i(clk_i),
      .req_i(req_i),
      .resp_o(resp_o),
      .mem_we_o(mem_we),
      .mem_waddr_o(mem_waddr),
      .mem_wdata_o(mem_wdata),
      .mem_wstrb_o(mem_wstrb),
      .mem_wresp_i(mem_wresp),
      .mem_re_o(mem_re),
      .mem_raddr_o(mem_raddr),
      .mem_rdata_i(mem_rdata),
      .mem_rresp_i(mem_rresp)
  );

  uart_reg_if u_reg_if (
      .arst_ni(arst_ni),
      .clk_i(clk_i),
      .mem_we_i(mem_we),
      .mem_waddr_i(mem_waddr),
      .mem_wdata_i(mem_wdata),
      .mem_wstrb_i(mem_wstrb),
      .mem_wresp_o(mem_wresp),
      .mem_re_i(mem_re),
      .mem_raddr_i(mem_raddr),
      .mem_rdata_o(mem_rdata),
      .mem_rresp_o(mem_rresp),
      .ctrl_clk_en_o(ctrl_clk_en),
      .tx_fifo_flush_o(tx_fifo_flush),
      .rx_fifo_flush_o(rx_fifo_flush),
      .cfg_parity_en_o(cfg_parity_en),
      .cfg_parity_type_o(cfg_parity_type),
      .cfg_stop_bits_o(cfg_stop_bits),
      .cfg_rx_int_en_o(cfg_rx_int_en),
      .clk_div_o(clk_div),
      .tx_fifo_count_i(tx_fifo_count),
      .rx_fifo_count_i(rx_fifo_count),
      .tx_fifo_data_o(tx_fifo_data),
      .tx_fifo_data_valid_o(tx_fifo_data_valid),
      .tx_fifo_data_ready_i(tx_fifo_data_ready),
      .rx_fifo_data_i(rx_fifo_data),
      .rx_fifo_data_valid_i(rx_fifo_data_valid),
      .rx_fifo_data_ready_o(rx_fifo_data_ready)
  );

  clk_div #(
      .DIV_WIDTH(32)
  ) u_clk_div (
      .arst_ni(arst_ni),
      .clk_i(clk_i),
      .div_i(clk_div),
      .clk_o(slow_clk)
  );

  cdc_fifo #(
      .ELEM_WIDTH (8),
      .FIFO_SIZE  (2)
  ) u_tx_fifo (
      .arst_ni(arst_ni),
      .elem_in_i(tx_fifo_data),
      .elem_in_clk_i(clk_i),
      .elem_in_valid_i(tx_fifo_data_valid),
      .elem_in_ready_o(tx_fifo_data_ready),
      .elem_out_o(), // TODO
      .elem_out_clk_i(slow_clk),
      .elem_out_valid_o(), // TODO
      .elem_out_ready_i() // TODO
  );

  cdc_fifo #(
      .ELEM_WIDTH (8),
      .FIFO_SIZE  (2)
  ) u_rx_fifo (
      .arst_ni(arst_ni),
      .elem_in_i(), // TODO
      .elem_in_clk_i(slow_clk),
      .elem_in_valid_i(), // TODO
      .elem_in_ready_o(), // TODO
      .elem_out_o(rx_fifo_data),
      .elem_out_clk_i(clk_i),
      .elem_out_valid_o(rx_fifo_data_valid),
      .elem_out_ready_i(rx_fifo_data_ready)
  );

endmodule
