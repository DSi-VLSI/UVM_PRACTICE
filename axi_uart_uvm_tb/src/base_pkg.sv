`include "axi/typedef.svh"

package base_pkg;

  `ifdef USE_AXI
  `AXI_TYPEDEF_ALL(axi, logic [31:0], logic [3:0], logic [63:0], logic [7:0], logic [7:0])
  `elsif USE_APB
  `APB_TYPEDEF_ALL(apb, logic [31:0], logic [63:0], logic [7:0])
  `endif

endpackage
