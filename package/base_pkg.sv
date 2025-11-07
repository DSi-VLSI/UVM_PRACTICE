`include "axi/typedef.svh"
`include "apb/typedef.svh"

package base_pkg;

  `AXI_TYPEDEF_ALL(axi, logic [31:0], logic [3:0], logic [63:0], logic [7:0], logic [7:0])

  `APB_TYPEDEF_ALL(apb, logic [31:0], logic [63:0], logic [7:0])

endpackage
