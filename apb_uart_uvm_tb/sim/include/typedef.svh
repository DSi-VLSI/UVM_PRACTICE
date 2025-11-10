
`ifndef MY_TYPEDEF_SVH_
`define MY_TYPEDEF_SVH_


`define APB_REQ_TYPEDEF(apb_req_t, addr_t, data_t, strb_t)  \
    typedef struct packed {                           \
        logic  penable_i;                               \
        logic psel_i;                                   \
        logic pwrite_i;                                 \
        addr_t paddr_i;                                 \
        data_t pwdata_i;                                \
        strb_t pstrb_i;                                   \
    } apb_req_t;


`define APB_RESP_TYPEDEF(apb_resp_t, data_t)          \
    typedef struct packed {                     \
        logic  pready_o;                          \
        data_t prdata_o;                          \
        logic  pslverr_o;                          \
    } apb_resp_t;


`define APB_ALL_TYPEDEF(name, addr_t, data_t, strb_t) \
    `APB_REQ_TYPEDEF(name``_req_t, addr_t, data_t, strb_t) \
    `APB_RESP_TYPEDEF(name``_resp_t, data_t)


`endif