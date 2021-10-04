---
title: "Assignment 1: ALU"
date: 2021-10-03
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
In this lab, our team create a DIV and MOD module for the LC4. We then designed an ALU module, which integrated the previously made LC4 division and modulo module and standard operands to complete basic ALU operations. 

# Part A: DIV/MOD Module Code 
As stated above, the first part of this assignment had us create a functioning division and modulo module. Written below is our Verilog code:

```Verilog
`timescale 1ns / 1ps

module lc4_divider(dividend_in, divisor_in, remainder_out, quotient_out);

   input [15:0] dividend_in, divisor_in;
   output [15:0] remainder_out, quotient_out;
   // input clk;
   
   /*** YOUR CODE HERE ***/
   wire [15:0] dividend_in, divisor_in;
   wire [15:0] remainder_out, quotient_out;
   
   wire [15:0] d01, d02, d03, d04, d05, d06, d07, d08, d09, d10, d11, d12, d13, d14, d15, d_out;
   wire [15:0] r01, r02, r03, r04, r05, r06, r07, r08, r09, r10, r11, r12, r13, r14, r15, r_out;
   wire [15:0] q01, q02, q03, q04, q05, q06, q07, q08, q09, q10, q11, q12, q13, q14, q15, q_out;

   lc4_divider_one_iter div_01(.DIVDI(dividend_in), .DIVS(divisor_in), .REMI(16'd0), .QUOI(16'd0), .DIVDO(d01), .REMO(r01), .QUOO(q01));
   lc4_divider_one_iter div_02(.DIVDI(d01), .DIVS(divisor_in), .REMI(r01), .QUOI(q01), .DIVDO(d02), .REMO(r02), .QUOO(q02));
   lc4_divider_one_iter div_03(.DIVDI(d02), .DIVS(divisor_in), .REMI(r02), .QUOI(q02), .DIVDO(d03), .REMO(r03), .QUOO(q03));
   lc4_divider_one_iter div_04(.DIVDI(d03), .DIVS(divisor_in), .REMI(r03), .QUOI(q03), .DIVDO(d04), .REMO(r04), .QUOO(q04));
   lc4_divider_one_iter div_05(.DIVDI(d04), .DIVS(divisor_in), .REMI(r04), .QUOI(q04), .DIVDO(d05), .REMO(r05), .QUOO(q05));
   lc4_divider_one_iter div_06(.DIVDI(d05), .DIVS(divisor_in), .REMI(r05), .QUOI(q05), .DIVDO(d06), .REMO(r06), .QUOO(q06));
   lc4_divider_one_iter div_07(.DIVDI(d06), .DIVS(divisor_in), .REMI(r06), .QUOI(q06), .DIVDO(d07), .REMO(r07), .QUOO(q07));
   lc4_divider_one_iter div_08(.DIVDI(d07), .DIVS(divisor_in), .REMI(r07), .QUOI(q07), .DIVDO(d08), .REMO(r08), .QUOO(q08));
   lc4_divider_one_iter div_09(.DIVDI(d08), .DIVS(divisor_in), .REMI(r08), .QUOI(q08), .DIVDO(d09), .REMO(r09), .QUOO(q09));
   lc4_divider_one_iter div_10(.DIVDI(d09), .DIVS(divisor_in), .REMI(r09), .QUOI(q09), .DIVDO(d10), .REMO(r10), .QUOO(q10));
   lc4_divider_one_iter div_11(.DIVDI(d10), .DIVS(divisor_in), .REMI(r10), .QUOI(q10), .DIVDO(d11), .REMO(r11), .QUOO(q11));
   lc4_divider_one_iter div_12(.DIVDI(d11), .DIVS(divisor_in), .REMI(r11), .QUOI(q11), .DIVDO(d12), .REMO(r12), .QUOO(q12));
   lc4_divider_one_iter div_13(.DIVDI(d12), .DIVS(divisor_in), .REMI(r12), .QUOI(q12), .DIVDO(d13), .REMO(r13), .QUOO(q13));
   lc4_divider_one_iter div_14(.DIVDI(d13), .DIVS(divisor_in), .REMI(r13), .QUOI(q13), .DIVDO(d14), .REMO(r14), .QUOO(q14));
   lc4_divider_one_iter div_15(.DIVDI(d14), .DIVS(divisor_in), .REMI(r14), .QUOI(q14), .DIVDO(d15), .REMO(r15), .QUOO(q15));
   lc4_divider_one_iter div_16(.DIVDI(d15), .DIVS(divisor_in), .REMI(r15), .QUOI(q15), .DIVDO(d_out), .REMO(remainder_out), .QUOO(quotient_out));
   // lc4_divider_one_iter(.dividend_in(), .DIVS(), .REMI(), .QUOI(), .DIVDO(), .remainder_out(), .quotient_out());

   
endmodule

module lc4_divider_one_iter(DIVDI, DIVS, REMI, QUOI,
                            DIVDO, REMO, QUOO);
                            
   input [15:0] DIVDI, DIVS, REMI, QUOI;
   output [15:0] DIVDO, REMO, QUOO;
   
   wire [15:0] remain_tmp = (REMI << 1) | (DIVDI >> 15) & 1'b1;
   wire condition = (remain_tmp < DIVS);
   
   assign QUOO = condition ? (QUOI << 1) | 1'b0 : (QUOI << 1) | 1'b1;
   assign REMO = condition ? remain_tmp : remain_tmp - DIVS;
   assign DIVDO = DIVDI << 1;
endmodule 
```
# DIV/MOD Module Algorithm
The module takes as input two 16-bit data values (dividend and divisor) and outputs two 16-bit values (remainder and quotient). It calculates using the following algorithm:

```Verilog
int divide(int dividend, int divisor)
{
  int quotient = 0;
  int remainder = 0;

  if (divisor == 0) {
    return 0;
  }

  for (int i = 0; i < 16; i++) {
    remainder = (remainder << 1) | ((dividend >> 15) & 0x1);
    if (remainder < divisor) {
      quotient = (quotient << 1) | 0x0;
    } else {
      quotient = (quotient << 1) | 0x1;
      remainder = remainder - divisor;
    }
    dividend = dividend << 1;
  }

  return quotient;
}
```
# Part B: ALU Module
The LC4 ALU module performs all of the arithmetic and logical operations for the various instructions. In this lab you'll build a self-contained ALU datapath with the corresponding control signals.

## ALU Schematic
Below is a picture of our ALU Schematic

![ALU_final_](https://user-images.githubusercontent.com/16892369/135794910-83c71d4c-06b7-4a0d-9984-67f5c112a52b.png)

## ALU Verilog Code

# Questions
> Q: What other problems, if any, did you encounter while doing this lab?
A: Our unfamiliarity with Verilog was the biggest general problem during this lab. While the concepts covered here were not difficult in after some thought, converting our knowledge with high-level, general-purpose programming to Verilog, a hardware based description language was more difficult than anticipated.

> Q: How many hours did it take you to complete this assignment?
A: An estimated total of ~60 hours were spend between the group to complete this assignment. Much of this time was spent figuring out the syntax of Verilog trying to get things to work properly. 

> Q: On a scale of 1 (least) to 5 (most), how difficult was this assignment?
A: 3.5 - 4

> Q: What was the group division of labor on this assignment, in both hours and functional and debugging tasks?
A: ... 
Christian
Devin: 
Keola: 
Tyler: Part A writing and debugging. 13 hours total writing 3 different instantiations of DIV/MOD module before settling with one, 2 hours debugging/troubleshooting.
