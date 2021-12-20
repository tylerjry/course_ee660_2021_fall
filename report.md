---
title: "Report 2: Single-Cycle LC4 Processor"
date: 2021-12-19
type: book
commentable: true

summary: "The second assignment for EE660, fall, 2021."

tags:
- teaching
- ee660
- assignment
---

***
## Executive Summary
In this lab, our team implemented an LC4 Register File, and integrated it with other code to complete a single-cycle LC4 processor. We integrated an ALU verilog code that was made in another assignment. 

# Register File Module 
The Register File was implemented such that within a given cycle, any two registers may be read and any register may be written. However, if the register write occurs at the same time as a read, the old value needs to be read, and not the one being written. This was accomplished by separating the initializing of the reads and the writes. Register reads occurred with an "always @(*)" initialization (the same as the testbench given with the assignement), whereas Writes were initialized on every clock cycle. This ensured, while testing, that all read data was not updated too soon. 

## Register File Schematic
The image below shows how the Register File Module was implemented. 
![Register File (1)](https://user-images.githubusercontent.com/16892369/146723154-d1d40349-aa42-4157-b79a-5bc9e3e62edb.jpg)

## Register File Code
Written below is the verilog code for the Register File:

```Verilog
`timescale 1ns / 1ps

module lc4_regfile(clk, gwe, rst, r1sel, r1data, r2sel, r2data, wsel, wdata, we);
   parameter n = 16;
   
   input clk, gwe, rst;
   input [2:0] r1sel, r2sel, wsel;
   
   input [n-1:0] wdata;
   input we;
   output reg [n-1:0] r1data, r2data;
   
   wire [n-1:0] r0out, r1out, r2out, r3out, r4out, r5out, r6out, r7out;

   /*** YOUR CODE HERE ***/
   reg [n-1:0] r0, r1, r2, r3, r4, r5, r6, r7;  // registers in Register file
   reg flag = 1'b0;     // used to initialize register values (to 16'b0) once Write Enable is set high
   
   wire [2:0] state;        // holds value of register to be written to (in the case of a write)
   reg [n-1:0] wdata_reg;   // register used to contain Write data, and properly write data to registers at the correct time
   reg we_reg;              // Used to hold write enable value 
   
   Nbit_reg Nreg (wsel, state, clk, we, gwe, rst);
   
   // assign output register wires to the registers being written to
   assign r0out = r0;
   assign r1out = r1;
   assign r2out = r2;
   assign r3out = r3;
   assign r4out = r4;
   assign r5out = r5;
   assign r6out = r6;
   assign r7out = r7;

   always @(*) begin 
    // Write data and write enable saved in register for timing purposes
    wdata_reg = wdata;
    we_reg = we;
    
     // set read data 1
     case (r1sel)
       3'b000 : r1data = r0out;
       3'b001 : r1data = r1out;
       3'b010 : r1data = r2out;
       3'b011 : r1data = r3out;
       3'b100 : r1data = r4out;
       3'b101 : r1data = r5out;
       3'b110 : r1data = r6out;
       3'b111 : r1data = r7out;
       default: r1data = 16'h0;
     endcase
     // set read data 2
     case (r2sel)
       3'b000 : r2data = r0out;
       3'b001 : r2data = r1out;
       3'b010 : r2data = r2out;
       3'b011 : r2data = r3out;
       3'b100 : r2data = r4out;
       3'b101 : r2data = r5out;
       3'b110 : r2data = r6out;
       3'b111 : r2data = r7out;
       default: r2data = 16'h0;
     endcase
     
     if (we & !flag) begin
       r0 = 16'h0;
       r1 = 16'h0;
       r2 = 16'h0;
       r3 = 16'h0; 
       r4 = 16'h0; 
       r5 = 16'h0; 
       r6 = 16'h0; 
       r7 = 16'h0; 
       flag = 1'b1;
     end
   end

  always @(posedge clk) begin
    #2 // Set to delay write till after Read occurs
    
    if (we_reg & gwe) begin // If global write is and Write is enabled, Write the wdata to the register responding to state
       case (state) // State (corresponding to register) determined by Nbit_reg program (and write select value, wsel)
         3'b000 : r0 = wdata_reg;
         3'b001 : r1 = wdata_reg;
         3'b010 : r2 = wdata_reg;
         3'b011 : r3 = wdata_reg;
         3'b100 : r4 = wdata_reg;
         3'b101 : r5 = wdata_reg;
         3'b110 : r6 = wdata_reg;
         3'b111 : r7 = wdata_reg;
       endcase 
     end
  end
endmodule
```
# Register File Demonstration 

Below are performance results of the code written above. This implementation recieved 0 errors from the testbench and input file given at the beginning of the assignment.

### Image 1 : Register FIle Waveform, 0 ns to 216 ns
![image](https://user-images.githubusercontent.com/16892369/146721580-98d2af78-9f76-477c-b57f-b5eb7cab84d2.png)

### Image 2 : Register File Waveform, 10,000 ns to 10,217 ns
![image](https://user-images.githubusercontent.com/16892369/146721068-9232189e-1f2c-49d3-b08f-de3764a9c9f4.png)

### TCL Console Output
```TCL 
source testbench_v.tcl
# set curr_wave [current_wave_config]
# if { [string length $curr_wave] == 0 } {
#   if { [llength [get_objects]] > 0} {
#     add_wave /
#     set_property needs_save false [current_wave_config]
#   } else {
#      send_msg_id Add_Wave-1 WARNING "No top level signals found. Simulator will start without a wave window. If you want to open a wave window go to 'File->New Waveform Configuration' or type 'create_wave_config' in the TCL console."
#   }
# }
# run 1000ns
INFO: [USF-XSim-96] XSim completed. Design snapshot 'testbench_v_behav' loaded.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
launch_simulation: Time (s): cpu = 00:00:03 ; elapsed = 00:00:08 . Memory (MB): peak = 1246.070 ; gain = 0.000
run all
Simulation finished:        1011 test cases           0 errors [C:/Users/niwc/Documents/School - Yamauchi/ee660/project_2/project_2.srcs/sources_1/imports/Downloads/test_lc4_regfile.input]
$finish called at time : 10217 ns : File "C:/Users/niwc/Documents/School - Yamauchi/ee660/project_2/project_2.srcs/sources_1/imports/Downloads/test_lc4_regfile.tf" Line 118
```
# LC4 Processor Module 

# LC4 Processor Module Demonstration

# Questions
1. Once you had the design working in simulation, did you encounter any problems getting it to run on the FPGA boards? If so, what problems did you encounter?

      We were unable to get our code working with the FPGA in time.

2. What other problems, if any, did you encounter while doing this lab?
      
      The biggest difficulty was figuring out what some of the named wires/registers are for as they aren't all super clearly named/commented in the lab code. A wire/port diagram of the "lc4_system" file would have helped deliniate those processes from the "processor" we were wokring on. That said, we realize system connects to multiple resources so we understand why that was not created.

3. How many hours did it take you to complete this assignment?
  
    Breakdown given below.
  
4. On a scale of 1 (least) to 5 (most), how difficult was this assignment?
      
    This assignment was a 5 difficulty, mostly because of the complexity and the amount of different parts there were to get everything to work.

5. What was the group division of labor on this assignment, in both hours and functional and debugging tasks?
    
    Christian: 
  
    Devin: 
  
    Keola: 
  
    Tyler: 3 hours to create Register File Schematic (time was mostly spent on research and understanding), 12 hours to write and debug Register File module. Debugging was mostly spent on fixing timing issues. For example, the testbench always updated the register value too early, and if too much of a delay was placed, the Write would occur on a new clock cycle, which of course had different values for wdata and Write Enable. The solution was to perform the Write at the very start of a new cycle.
