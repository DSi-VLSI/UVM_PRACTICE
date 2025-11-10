
`ifndef CONSTANTS_SVH_
`define CONSTANTS_SVH_

parameter MEM_SIZE = 6;
parameter DATA_WIDTH = 32;

typedef logic [MEM_SIZE-1:0] addr_width_t;
typedef logic [DATA_WIDTH-1:0] data_width_t;
typedef logic [(DATA_WIDTH/8)-1:0] strb_width_t;

`endif