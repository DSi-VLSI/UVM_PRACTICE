
`include "apb/typedef.svh"


interface apb_interface(input bit pclk);

    import base_pkg::apb_req_t;
    import base_pkg::apb_resp_t;

    apb_req_t  apb_req;
    apb_resp_t apb_resp;

    logic      presetn;
    
    // modports for master/driver
    modport master(input apb_resp, output apb_req);
    modport slave(input apb_req, output apb_resp);
    
endinterface //apb_interface