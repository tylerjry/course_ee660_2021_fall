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
   
   /*** YOUR CODE HERE ***/
   wire [15:0] dividend_in, divisor_in;
   wire [15:0] remainder_out, quotient_out;
   
   // wires connecting modules to the input of the subsequent modules
   wire [15:0] d01, d02, d03, d04, d05, d06, d07, d08, d09, d10, d11, d12, d13, d14, d15, d_out;
   wire [15:0] r01, r02, r03, r04, r05, r06, r07, r08, r09, r10, r11, r12, r13, r14, r15, r_out;
   wire [15:0] q01, q02, q03, q04, q05, q06, q07, q08, q09, q10, q11, q12, q13, q14, q15, q_out;
   
   // instantiate 16 copies of the lc4_divider_one_iter module to perform a full 16-bit division
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

// 
module lc4_divider_one_iter(DIVDI, DIVS, REMI, QUOI,
                            DIVDO, REMO, QUOO);
                            
   input [15:0] DIVDI, DIVS, REMI, QUOI;     // dividend_in, divisor, remainder_in, quotient_in
   output [15:0] DIVDO, REMO, QUOO;          // dividend_out, remainder_out, quotient_out
   
   wire [15:0] remain_tmp = (REMI << 1) | (DIVDI >> 15) & 1'b1;         // 
   wire condition = (remain_tmp < DIVS);                                // conditional value signaling whether to update remainder_out or not
   
   assign QUOO = condition ? (QUOI << 1) | 1'b0 : (QUOI << 1) | 1'b1;   // perform OR operation on 15-bits of the 16-bit quotient_in value with a bit-wise 0 or 1 depending on the value of the condition
   assign REMO = condition ? remain_tmp : remain_tmp - DIVS;            // if the condition is false, update the value of remainder_out, otherwise use the remain_tmp value
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
![ALU_final_ (1)](https://user-images.githubusercontent.com/16892369/135826188-17835dd8-da29-48bd-b625-7d9bf51a843d.png)

## ALU Verilog Code

```Verilog 
`timescale 1ns / 1ps

module lc4_alu(insn, pc, r1data, r2data, out);
   
   input        [15:0] insn, pc, r1data, r2data;
   output reg   [15:0] out;
   
   reg          [15:0] module_select;
   //reg          [16:0] temp;
   wire         [15:0] math_out, cmp_out, jsr_out, logic_out, rti_out, shift_out, jump_out;
   wire         [3:0]  control_out;
   
   math_unit lc4_math (insn, r1data, r2data, module_select[1], math_out);           //determines math operation outpput
   cmp_unit lc4_cmp (insn, r1data, r2data, module_select[2], cmp_out);              //returns a comare value
   jsr_unit lc4_jsr (insn, pc, r1data, module_select[3], jsr_out);                  // returns JSR value
   logic_unit lc4_logic (insn, r1data, r2data, module_select[4], logic_out);        // like math_unit, insn[5:3] is subcode and insn[4:0] is imm5 for case insn[5] == 1 (ANDI)
   shift_unit lc4_shift (insn, r1data, r2data, module_select[9], shift_out);        // return shifted value 
   jmp_unit lc4_jump (insn, pc, r1data, r2data, module_select[10], jmp_out);        //return jump PC value 
   
   // case to chose the output of the ALU
   always @ (insn) begin
        case(insn[15:12])
            4'b0000: begin                                                          // BRANCH
                        module_select = 16'b0000000000000001;
                        case(insn[11:9])
                            3'b000  : out = 16'b0000000000000000; 
                            default : begin
                                        out = pc + 1'b1 + {insn[8], insn[8], insn[8], insn[8], insn[8], insn[8], insn[8], insn[8:0]};
                                      end
                         endcase
                      end
            4'b0001: begin
                        out = math_out;                                             // MATH unit
                        module_select = 16'b0000000000000010;
                     end
            4'b0010: begin
                        out = cmp_out;                                              // COMP unit
                        module_select = 16'b0000000000000100;
                     end
            4'b0100: begin
                        out = jsr_out;                                              // jsr unit
                        module_select = 16'b0000000000001000;
                     end
            4'b0101: begin
                        out = logic_out;                                            // LOGIC unit
                        module_select = 16'b0000000000010000;
                     end
            4'b0110: begin
                        out = r1data + {10'b0000000000, insn[5:0]};                 // ldr_out
                        module_select = 16'b0000000000100000;
                     end 
            4'b0111: begin
                        out = r1data + {10'b0000000000, insn[5:0]};                 // str_out
                        module_select = 16'b0000000001000000;
                     end
            4'b1000: begin
                        out = 16'b0;                                                // rti_unit
                        module_select = 16'b0000000010000000;
                     end
            4'b1001: begin
                        out = {7'b0, insn[8:0]};                                    // const_out
                        module_select = 16'b0000000100000000;
                     end
            4'b1010: begin
                        out = shift_out;                                            // shift_unit
                        module_select = 16'b0000001000000000;
                     end
            4'b1100: begin
                        out = jump_out;                                             // jump_unit
                        module_select = 16'b0000010000000000;
                     end
            4'b1101: begin
                        out = (r1data & 2'hFF) | (insn[7:0]<<8);                    // hi_const_out
                        module_select = 16'b0000100000000000;
                     end 
            4'b1111: begin
                        out = 4'h8000 | insn[7:0];                                  // trap_out
                        module_select = 16'b0001000000000000;
                     end
            default : out = 16'b000000000000000;  
        endcase
   end
endmodule

// --------------------------------------------------------------------------------------------------------------------------------
// MATH UNIT - ADD, MUL, SUB, DIV
// --------------------------------------------------------------------------------------------------------------------------------
module math_unit (insn, r1data, r2data, enable, math_out);
    input       [15:0]  insn, r1data, r2data;
    input               enable;
    output reg  [15:0]  math_out;
    
    reg         [4:0]   imm5;  // immediate bit
    reg         [2:0]   subcode;
    
    wire        [15:0]  rem_out, quo_out;   // remainder_out and quotient_out for lc4_divider module
    
    // instantiate the divider module to determine DIV output
    lc4_divider div01 (.dividend_in(r1data), .divisor_in(r2data), .remainder_out(rem_out), .quotient_out(quo_out)); 
    
    always @ (*) begin 
        subcode = insn[5:3];        
        imm5 = insn[4:0];        // As in LC4 Register File, if insn[5] is 1, then operand is ADDI, in which case insn[4:0] contains the imm5 value
    
        // use subcode to determine whihc instruction operand to use for math output  
        case (subcode) //begin
            3'b000: math_out = r1data + r2data;
            3'b001: math_out = r1data * r2data;
            3'b010: math_out = r1data - r2data;
            3'b011: math_out = quo_out;
            default: math_out = r1data +  imm5;    // add a signed r1data with the immediate value, case insn[5] == 1
        endcase
    end 
endmodule

// --------------------------------------------------------------------------------------------------------------------------------
// LOGIC Unit - AND, NOT, OR, XOR, ANDI
// --------------------------------------------------------------------------------------------------------------------------------
module logic_unit (insn, r1data, r2data, enable, logic_out);

    input       [15:0]  insn;
    input       [15:0]  r1data, r2data;
    output reg  [15:0]  logic_out;
    input           enable;

    reg         [5:3]   subcode;
    reg         [4:0]   imm5; // immediate bit    
    
    always @ (enable) begin
        subcode = insn[5:3];
        case(subcode)
            3'b000: logic_out = r1data & r2data;
            3'b001: logic_out = ~r1data;
            3'b010: logic_out = r1data | r2data;
            3'b011: logic_out = r1data ^ r2data;
            default: logic_out = r1data & imm5;
        endcase
    end
endmodule

// --------------------------------------------------------------------------------------------------------------------------------
// JSR Unit - JSR, JSRR
// --------------------------------------------------------------------------------------------------------------------------------
module jsr_unit (insn, pc, r1data, enable, jsr_out);
    input       [15:0]  insn;
    input       [15:0]  pc, r1data;
    input               enable;
    output reg  [15:0]  jsr_out;
    
    reg                 subcode;
    reg         [10:0]  imm11;
    
    always @ (enable) begin
        subcode = insn[11];
        case(subcode)
            1'b0: jsr_out = (pc & 4'h8000) | (imm11 < 4);
            default: jsr_out = r1data;
        endcase
    end
endmodule

// --------------------------------------------------------------------------------------------------------------------------------
// JMP Unit - JMPR, JMPI
// --------------------------------------------------------------------------------------------------------------------------------
module jmp_unit (insn, pc, r1data, r2data, enable, jmp_out);
    input       [15:0]  insn;
    input       [15:0]  pc, r1data, r2data;
    input               enable;
    output reg  [15:0]  jmp_out;
    
    reg                 subcode;
    
    always @(enable) begin
        subcode = insn[11];
        case(subcode)
            1'b0    :   jmp_out = r1data;                            // JMPR
            default :   jmp_out = pc + 0'b1 + {5'b0, insn[10:0]};    // JMPI
        endcase
    end
endmodule
//endmodule

// --------------------------------------------------------------------------------------------------------------------------------
// SHIFT Unit - SLL, SRL, SRA, MOD
// --------------------------------------------------------------------------------------------------------------------------------
module shift_unit (insn, A, B, enable, shift_out);
    // Implements the 16-bit barrel shifter
    // if subcode is 2'b00 this module will perform a logical left shift, which will be the barrel shifter's normal operation
    // if subcode is 2'b01 this module will perform a logical right shift x bits, which will be a circular left shift of WIDTH-x
    // if subcode is 2'b10 this module will perform an arithmetic right shift because if we right shfit we want to preserve the sign bit
    // if subcode is 2'b11 this module will perform the modulo between two values by instantiating the DIV/MOD module and taking rem_out

    /*
        Can make a case statement based on how much we want to shift
        then we can determine what kind of shift we'll be doing
        then perform the actual shift by assigning the output to the shifted input
        We can default to a right shift and then if it's an arithmetic right shift then we just set the MSB equal to the MSB of r1data
    */

    input       [15:0]  insn, A, B;
    input               enable;
    output reg  [15:0]  shift_out;

    reg         [3:0]   S;
    wire        [15:0]  rem_out, quo_out;

    lc4_divider div01 (.dividend_in(A), .divisor_in(B), .remainder_out(rem_out), .quotient_out(quo_out)); 

    always @(enable) begin
        S = insn[3:0];
        case(S)
            4'b0000 :   begin   // No shift
                            shift_out = A;
                        end
            4'b0001 :   begin   // Shift by 1
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[14:0], 1'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {1'b0, A[15:1]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], A[15:1]};
                                end
                            end
                        end
            4'b0010 :   begin   // Shift by 2
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[13:0], 2'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {2'b0, A[15:2]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 1'b0, A[15:2]};
                                end
                            end
                        end
            4'b0011 :   begin   // Shift by 3
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[12:0], 3'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {3'b0, A[15:3]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 2'b0, A[15:3]};
                                end
                            end
                        end
            4'b0100 :   begin   // Shift by 4
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[11:0], 4'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {4'b0, A[15:4]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 3'b0, A[15:4]};
                                end
                            end
                        end
            4'b0101 :   begin   // Shift by 5
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[10:0], 5'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {5'b0, A[15:5]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 4'b0, A[15:5]};
                                end
                            end
                        end
            4'b0110 :   begin   // Shift by 6
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[9:0], 6'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {6'b0, A[15:6]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 5'b0, A[15:6]};
                                end
                            end
                        end
            4'b0111 :   begin   // Shift by 7
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[8:0], 7'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {7'b0, A[15:8]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 6'b0, A[15:7]};
                                end
                            end
                        end
            4'b1000 :   begin   // Shift by 8
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[7:0], 8'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {8'b0, A[15:8]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 7'b0, A[15:8]};
                                end
                            end
                        end
            4'b1001 :   begin   // Shift by 9
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[6:0], 9'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {9'b0, A[15:9]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 8'b0, A[15:9]};
                                end
                            end
                        end
            4'b1010 :   begin   // Shift by 10
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[5:0], 10'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {10'b0, A[15:10]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 9'b0, A[15:10]};
                                end
                            end
                        end
            4'b1011 :   begin   // Shift by 11
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[4:0], 11'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {11'b0, A[15:11]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 10'b0, A[15:11]};
                                end
                            end
                        end
            4'b1100 :   begin   // Shift by 12
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[3:0], 12'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {12'b0, A[15:12]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 11'b0, A[15:11]};
                                end
                            end
                        end
            4'b1101 :   begin   // Shift by 13
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[2:0], 13'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {13'b0, A[15:13]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 12'b0, A[15:13]};
                                end
                            end
                        end
            4'b1110 :   begin   // Shift by 14
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[1:0], 14'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {14'b0, A[15:14]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 13'b0, A[15:14]};
                                end
                            end
                        end
            4'b1111 :   begin   // Shift by 15
                            if (insn[5:4] == 2'b00) begin           
                                // Logical left shift
                                shift_out = {A[0], 15'b0};
                            end else begin
                                // Logical right shift
                                shift_out = {15'b0, A[15]};
                                if (insn[5:4] == 2'b10) begin
                                    // Arithmetic right shift
                                    shift_out = {A[15], 14'b0, A[15]};
                                end
                            end
                        end
            default :   shift_out = rem_out;  // Default modulo
        endcase
    end
endmodule

// --------------------------------------------------------------------------------------------------------------------------------
// COMP Unit - CMP, CMPU, CMPI, CMPIU
// --------------------------------------------------------------------------------------------------------------------------------
module cmp_unit (insn, r1data, r2data, enable, cmp_out);
    input       [15:0]  insn, r1data, r2data;
    input               enable; 
    output reg  [15:0]  cmp_out;
    
    reg         [16:0]  r1sign, r2sign, immsign; //signed registers with room for overflowo
    reg                 result; //sign of the result
    
   always @ (enable) begin    //instruction and enable bit
      case(insn[8:7])   //chose case
        2'b00: begin    //compare signed registers
                    r1sign = {r1data[15], 1'b0, r1data[14:0]}; //shift sign and make room for overflow
                    r2sign = {r2data[15], 1'b0, r2data[14:0]}; 
                    if (r2sign[16] == r1sign[16]) //if the signs of our numbers are the same
                         if ((r2sign[15:0]>r1sign[15:0])) begin //if the second register has a greater abs val
                            result = !r2sign[16]; //resulting sign will be opposite of larger value
                            if (result == 0) // if positive number
                                cmp_out = 16'b00000000000000001;
                            else //if negative number
                                cmp_out = 16'b1111111111111111;
                         end else if ((r2sign[15:0]<r1sign[15:0])) begin //if first register has greater absval
                            result = r1sign[16]; //sign is first register
                            if (result == 0) //if positive number
                                cmp_out = 16'b00000000000000001;
                            else //if negative number
                                cmp_out = 16'b1111111111111111;
                         end else //if abs vals are equal
                            cmp_out = 16'b000000000000000000;
                    else //if they have differing signs
                            result = r1sign[16]; //sign of first register
                            if (result == 0) //positive number
                                cmp_out = 16'b00000000000000001; 
                            else //negative number
                                cmp_out = 16'b1111111111111111;
                             // no case for them being equal because signs are different
                end         
        2'b01: //unsigned register ops
                begin 
                    if ((r1data - r2data)>0) //if first register is bigger
                        cmp_out = 16'b0000000000000001;
                    else if ((r1data - r2data < 0))
                        cmp_out = 16'b1;
                    else  
                        cmp_out = 16'b0; 
                end   
        2'b10: begin //compare signed register and immediate value
                    r1sign = {r1data[15], 1'b0, r1data[14:0]};
                    immsign = {insn[6], 10'b0, insn[5:0]}; 
                    if (immsign[16] == r1sign[16])
                         if ((immsign[15:0]>r1sign[15:0])) begin
                            result = !immsign[16];
                            if (result == 0)
                                cmp_out = 16'b00000000000000001;
                            else
                                cmp_out = 16'b1111111111111111;
                         end else if ((immsign[15:0]<r1sign[15:0])) begin
                            result = r1sign[16];
                            if (result == 0)
                                cmp_out = 16'b00000000000000001;
                            else
                                cmp_out = 16'b1111111111111111;
                         end else 
                            cmp_out = 16'b000000000000000000;
                    else begin
                            result = r1sign[16];
                            if (result == 0)
                                cmp_out = 16'b00000000000000001;
                            else
                                cmp_out = 16'b1111111111111111;
                    end  
                end   
        2'b11: begin                                     //unsigned immediate compare
                    if ((r1data - insn[6:0])>0)
                        cmp_out = 16'b0000000000000001;
                    else if ((r1data - insn[6:0] < 0))
                        cmp_out = 16'b1;
                    else  
                    cmp_out = 16'b0; 
                end   
        default: cmp_out = 16'b0000000000000001;
      endcase
   end
endmodule
```
# Questions
> Q: What other problems, if any, did you encounter while doing this lab?

A: Our unfamiliarity with Verilog was the biggest general problem during this lab. While the concepts covered here were not difficult in after some thought, converting our knowledge with high-level, general-purpose programming to Verilog, a hardware based description language was more difficult than anticipated.

> Q: How many hours did it take you to complete this assignment?

A: An estimated total of ~60 hours were spend between the group to complete this assignment. Much of this time was spent figuring out the syntax of Verilog trying to get things to work properly. 

> Q: On a scale of 1 (least) to 5 (most), how difficult was this assignment?

A: 3.5 - 4

> Q: What was the group division of labor on this assignment, in both hours and functional and debugging tasks?

A: ... 
Christian: Part B COMP (comparator) unit design, mux selection design and overal ALU module planning and troubleshooting; 17 hours
Devin: Part A writing and debugging; 9 hours. Part B writing and debugging the shift unit for logical and arithmetic shifts, memory unit; 8 hours. Github actions; 1 hour.
Keola: ALU Schematic Design, 2 hours. Part B coding and troubleshooting, for JSR, Jump, RTI, and overal ALU design, 15 hours.
Tyler: Part A writing and debugging, 14 hours including debugging/troubleshooting. Early ALU math and logic unit design, 2 hours. Report, 1 hour.
