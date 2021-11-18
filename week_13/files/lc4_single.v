`timescale 1ns / 1ps
module lc4_processor(clk,
                     rst,
                     gwe,
                     imem_addr,
                     A_imem_out,
                     B_imem_out,
                     dmem_addr,
                     dmem_out,
                     dmem_we,
                     dmem_in,
                     test_A_stall,
                     test_B_stall,
                     test_A_pc,
                     test_B_pc,
                     test_A_insn,
                     test_B_insn,
                     test_A_regfile_we,
                     test_B_regfile_we,
                     test_A_regfile_reg,
                     test_B_regfile_reg,
                     test_A_regfile_in,
                     test_B_regfile_in,
                     test_A_nzp_we,
                     test_B_nzp_we,
                     test_A_nzp_in,
                     test_B_nzp_in,
                     test_A_dmem_we, 
                     test_B_dmem_we,
                     test_A_dmem_addr, 
                     test_B_dmem_addr,
                     test_A_dmem_value, 
                     test_B_dmem_value,
                     switch_data,
                     seven_segment_data,
                     led_data
                     );
   
   input         clk;         // main clock
   input         rst;         // global reset
   input         gwe;         // global we for single-step clock
   
   output [15:0] imem_addr;   // Address to read from instruction memory
   input  [15:0] A_imem_out, B_imem_out;    // Output of instruction memory
   output [15:0] dmem_addr;   // Address to read/write from/to data memory
   input  [15:0] dmem_out;    // Output of data memory
   output        dmem_we;     // Data memory write enable
   output [15:0] dmem_in;     // Value to write to data memory
   
   output [1:0]  test_A_stall, test_B_stall;       // Testbench: is this is stall cycle? (don't compare the test values). In superscalar, only 2nd (B) issue datapath will stall
   output [15:0] test_A_pc, test_B_pc;          // Testbench: program counter
   output [15:0] test_A_insn, test_B_insn;        // Testbench: instruction bits
   output        test_A_regfile_we, test_B_regfile_we;  // Testbench: register file write enable
   output [2:0]  test_A_regfile_reg, test_B_regfile_reg; // Testbench: which register to write in the register file 
   output [15:0] test_A_regfile_in, test_B_regfile_in;  // Testbench: value to write into the register file
   output        test_A_nzp_we, test_B_nzp_we;      // Testbench: NZP condition codes write enable
   output [2:0]  test_A_nzp_in, test_B_nzp_in;      // Testbench: value to write to NZP bits
   output        test_A_dmem_we, test_B_dmem_we;     // Testbench: data memory write enable
   output [15:0] test_A_dmem_addr, test_B_dmem_addr;   // Testbench: address to read/write memory
   output [15:0] test_A_dmem_value, test_B_dmem_value;  // Testbench: value read/writen from/to memory
   
   input [7:0]   switch_data;
   output [15:0] seven_segment_data;
   output [7:0]  led_data;
 
 
   // PC
   wire [15:0]   pc;
   wire [15:0]   next_pc;

   Nbit_reg #(16, 16'h8200) pc_reg (.in(next_pc), .out(pc), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

   /*** YOUR CODE HERE ***/

   // Always execute one instruction each cycle
   assign test_A_stall = 2'b0; 
   assign test_B_stall = 2'b1; 


   // For in-simulator debugging, you can use code such as the code
   // below to display the value of signals at each clock cycle.

//`define DEBUG
`ifdef DEBUG
   always @(posedge gwe) begin
      $display("%d %h %b %h", $time, pc, insn, alu_out_pre_mux);
   end
`endif

   // For on-board debugging, the LEDs and segment-segment display can
   // be configured to display useful information.  The below code
   // assigns the four hex digits of the seven-segment display to either
   // the PC or instruction, based on how the switches are set.
   
   assign seven_segment_data = (switch_data[6:0] == 7'd0) ? pc :
                               (switch_data[6:0] == 7'd1) ? A_imem_out :
                               (switch_data[6:0] == 7'd2) ? dmem_addr :
                               (switch_data[6:0] == 7'd3) ? dmem_out :
                               (switch_data[6:0] == 7'd4) ? dmem_in :
                               /*else*/ 16'hDEAD;
   assign led_data = switch_data;
   
endmodule

