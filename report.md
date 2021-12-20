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

# Part A: Register File Module 
The Register File was implemented such that within a given cycle, any two registers may be read and any register may be written. However, if the register write occurs at the same time as a read, the old value needs to be read, and not the one being written. This was accomplished by separating the initializing of the reads and the writes. Register reads occurred with an "always @(*)" initialization, whereas  

```Verilog
