---
title: "Assignment 2: Single-Cycle LC4 Processor"
date: 2021-09-01
type: book
commentable: true

summary: "The first assignment for EE260, fall, 2021."

tags:
- teaching
- ee660
- assignment
---

***
## Executive Summary
In this lab, you'll complete a single-cycle [LC4](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/LC4.pdf) processor. We're giving you the data and instruction memories (including all the I/O devices) . You'll use the ALU from the previous lab, implement a register file, and design other needed components. The end result is a fully functional [LC4](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/LC4.pdf) processor complete with video output.

## Project Files
A skeleton implementation, including Verilog code for the memory and all of the devices, pin constraints, and various memory images on which your processor will be tested is included in the compressed tarball [labfiles.tar.gz](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/labfiles.tar.gz). To extract the tarball, type 'tar -xvzf labfiles.tar.gz' at the eniac command line.

## Register File Module
The register file module will be in the file [lc4_regfile.v](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/lc4_regfile.v):

```Verilog
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
```

In a given cycle, any two registers may be read and any register may be written. A register write occurs only when the we signal is high. If the same register is read and written in the same cycle, the old value will be read (not the new value being written).

### Register File Schematic
First draw a detailed schematic (by hand or computerized) of the hardware design, including signal names, sub-modules, etc. Only once you have the design on paper in schematic form, then translate it directly to Verilog. That is, your Verilog should correspond to the schematic exactly.

### Register File Implementation
You'll build the register file out of a N-bit parametrized register module provided for you, [register.v](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/register.v):

```Verilog
`timescale 1ns / 1ps

/* A parameterized-width positive-edge-trigged register, with synchronous reset.
   The value to take on after a reset is the 2nd parameter. */

module Nbit_reg(in, out, clk, we, gwe, rst);
   parameter n = 1;
   parameter r = 0;

   output [n-1:0] out;
   input [n-1:0]  in;
   input          clk;
   input          we;
   input          gwe;
   input          rst;

   reg [n-1:0] state;

   assign #(1) out = state;

   always @(posedge clk)
     begin
       if (gwe & rst)
         state = r;
       else if (gwe & we)
         state = in;
     end
endmodule
```

> The "gwe" signal is a global write-enable (one write enable signal that controls every state variable in the design). For now, just pass this along into the N-bit register. There is more information about this below.

### Register File Testing
The testbench for the register file is [test_lc4_regfile.tf](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/test_lc4_regfile.tf) and the input trace is [test_lc4_regfile.input](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/test_lc4_regfile.input).

## Single-Cycle LC4 Processor
Below is a digram of a LC4 single-cycle datapath using the register file, ALU, and branch unit.

![](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/lc4_datapath.png)

Click on the image for a larger version. It is also available as: [lc4_datapath.pdf](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/lc4_datapath.pdf) and [lc4_datapath.pptx](https://github.com/gustybear-teaching/course_ee660_2021_fall/raw/main/week_13/files/lc4_datapath.pptx)

