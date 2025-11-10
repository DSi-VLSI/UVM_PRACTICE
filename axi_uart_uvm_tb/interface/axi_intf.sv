interface axi_intf #(
    parameter type axi_req_t  = logic,
    parameter type axi_resp_t = logic
)(
    input logic clk,
    output logic rst_n
);
    axi_req_t  axi_req;
    axi_resp_t axi_resp;
endinterface