`ifndef DEPENDENCIES_SVH
`define DEPENDENCIES_SVH

`include "axi/typedef.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;
import axi_pkg::*;

 `AXI_TYPEDEF_ALL(uvm_tb_axi, logic [31:0], logic [3:0], logic [31:0], logic [3:0], logic [3:0])

import axi_uart_tb_pkg::*;

`endif