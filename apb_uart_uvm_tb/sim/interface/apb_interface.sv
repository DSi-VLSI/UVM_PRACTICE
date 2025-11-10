
`include "typedef.svh"


interface apb_interface(input pclk);

    `APB_ALL_TYPEDEF(apb, logic [31:0], logic [31:0], logic [3:0])

    apb_req_t  apb_req;
    apb_resp_t apb_resp;

    logic      presetn_i;
    
    
endinterface //apb_interface