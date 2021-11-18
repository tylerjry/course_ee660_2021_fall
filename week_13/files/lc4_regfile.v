`timescale 1ns / 1ps

module lc4_regfile(clk, gwe, rst, r1sel, r1data, r2sel, r2data, wsel, wdata, we);
   parameter n = 16;
   
   input clk, gwe, rst;
   input [2:0] r1sel, r2sel, wsel;
   
   input [n-1:0] wdata;
   input we;
   output [n-1:0] r1data, r2data;
   
   wire [n-1:0] r0out, r1out, r2out, r3out, r4out, r5out, r6out, r7out;

   /*** YOUR CODE HERE ***/

endmodule


