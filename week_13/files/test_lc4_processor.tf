`timescale 1ns / 1ps

`define EOF 32'hFFFF_FFFF
`define NEWLINE 10
`define NULL 0

`ifndef INPUT
`define INPUT "code/house.trace"
`endif
               
`ifndef OUTPUT
`define OUTPUT "code/house.output"
`endif

module testbench_v;

   integer     input_file, output_file, errors, linenum;
   integer     num_cycles;
   integer     num_A_exec, num_A_branch_stall, num_A_load_stall, num_A_ss_stall;
   integer     num_B_exec, num_B_branch_stall, num_B_load_stall, num_B_ss_stall;

   integer     next_instruction, pipe_A;   
   
   // Inputs
   reg clk;
   reg rst;
   wire [15:0] imem1_out, imem2_out;
   wire [15:0] dmem_out;

   // Outputs
   wire [15:0] imem1_addr, imem2_addr;
   wire [15:0] dmem_addr;
   wire [15:0] dmem_in;
   wire        dmem_we;

   wire [1:0]  test_A_stall, test_B_stall;       // Testbench: is this is stall cycle? (don't compare the test values)
   wire [15:0] test_A_pc, test_B_pc;          // Testbench: program counter
   wire [15:0] test_A_insn, test_B_insn;        // Testbench: instruction bits
   wire        test_A_regfile_we, test_B_regfile_we;  // Testbench: register file write enable
   wire [2:0]  test_A_regfile_reg, test_B_regfile_reg; // Testbench: which register to write in the register file 
   wire [15:0] test_A_regfile_in, test_B_regfile_in;  // Testbench: value to write into the register file
   wire        test_A_nzp_we, test_B_nzp_we;      // Testbench: NZP condition codes write enable
   wire [2:0]  test_A_nzp_in, test_B_nzp_in;      // Testbench: value to write to NZP bits
   wire        test_A_dmem_we, test_B_dmem_we;     // Testbench: data memory write enable
   wire [15:0] test_A_dmem_addr, test_B_dmem_addr;   // Testbench: address to write memory
   wire [15:0] test_A_dmem_value, test_B_dmem_value;  // Testbench: value to write memory

   reg  [15:0] test_pc;          // Testbench: program counter
   reg  [15:0] test_insn;        // Testbench: instruction bits
   reg         test_regfile_we;  // Testbench: register file write enable
   reg  [2:0]  test_regfile_reg; // Testbench: which register to write in the register file 
   reg  [15:0] test_regfile_in;  // Testbench: value to write into the register file
   reg         test_nzp_we;      // Testbench: NZP condition codes write enable
   reg  [2:0]  test_nzp_in;      // Testbench: value to write to NZP bits
   reg         test_dmem_we;     // Testbench: data memory write enable
   reg  [15:0] test_dmem_addr;   // Testbench: address to write memory
   reg  [15:0] test_dmem_value;  // Testbench: value to write memory

   reg  [15:0] verify_pc;
   reg  [15:0] verify_insn;
   reg         verify_regfile_we;
   reg  [2:0]  verify_regfile_reg;
   reg  [15:0] verify_regfile_in;
   reg         verify_nzp_we;
   reg  [2:0]  verify_nzp_in;
   reg         verify_dmem_we;
   reg  [15:0] verify_dmem_addr;
   reg  [15:0] verify_dmem_value;
   reg [15:0]  file_status;
   
   wire [15:0] vout_dummy;  // video out
   

   always #5 clk <= ~clk;
   
   // Produce gwe and other we signals using same modules as lc4_system
   wire        i1re, i2re, dre, gwe;
   lc4_we_gen we_gen(.clk(clk),
		     .i1re(i1re),
		     .i2re(i2re),
		     .dre(dre),
		     .gwe(gwe));
  
   
   // Data and video memory block 
   bram memory (.idclk(clk),
		.i1re(i1re),
		.i2re(i2re),
		.dre(dre),
		.gwe(gwe),
		.rst(rst),
                .i1addr(imem1_addr),
		.i2addr(imem2_addr),
                .i1out(imem1_out),
		.i2out(imem2_out),
                .daddr(dmem_addr),
		.din(dmem_in),
                .dout(dmem_out),
                .dwe(dmem_we),
                .vclk(1'b0),
                .vaddr(16'h0000),
                .vout(vout_dummy));
   
   
   // Instantiate the Unit Under Test (UUT)
   lc4_processor proc_inst(.clk(clk),
			   .rst(rst),
			   .gwe(gwe),
			   .imem_addr(imem1_addr),
			   .A_imem_out(imem1_out),
			   .B_imem_out(imem2_out),
			   .dmem_addr(dmem_addr),
			   .dmem_out(dmem_out),
			   .dmem_we(dmem_we),
			   .dmem_in(dmem_in),
			   .test_A_stall(test_A_stall),
			   .test_B_stall(test_B_stall),
			   .test_A_pc(test_A_pc),
			   .test_B_pc(test_B_pc),
			   .test_A_insn(test_A_insn),
			   .test_B_insn(test_B_insn),
			   .test_A_regfile_we(test_A_regfile_we),
			   .test_B_regfile_we(test_B_regfile_we),
			   .test_A_regfile_reg(test_A_regfile_reg),
			   .test_B_regfile_reg(test_B_regfile_reg),
			   .test_A_regfile_in(test_A_regfile_in),
			   .test_B_regfile_in(test_B_regfile_in),
			   .test_A_nzp_we(test_A_nzp_we),
			   .test_B_nzp_we(test_B_nzp_we),
			   .test_A_nzp_in(test_A_nzp_in),
			   .test_B_nzp_in(test_B_nzp_in),
			   .test_A_dmem_we(test_A_dmem_we),
			   .test_B_dmem_we(test_B_dmem_we),
			   .test_A_dmem_addr(test_A_dmem_addr),
			   .test_B_dmem_addr(test_B_dmem_addr),
			   .test_A_dmem_value(test_A_dmem_value),
			   .test_B_dmem_value(test_B_dmem_value),
			   .switch_data(8'd0)
                           ); 
   
   assign imem2_addr = imem1_addr + 16'd1;
	
   // always #5 $display("%d: %d %d %d %h", $time, clk, gwe, rst, test_pc);
		
   initial begin
      // Initialize Inputs
      clk = 0;
      rst = 1;
      linenum = 0;
      errors = 0;
      num_cycles = 1;
      num_A_exec = 0;
      num_B_exec = 0;
      num_A_branch_stall = 0;
      num_B_branch_stall = 0;
      num_A_load_stall = 0;
      num_B_load_stall = 0;
      num_A_ss_stall = 0;
      num_B_ss_stall = 0;
      file_status = 10;
      
      
      // open the test inputs
      input_file = $fopen(`INPUT, "r");
      if (input_file == `NULL) begin
         $display("Error opening file: %s", `INPUT);
         $finish;
      end

      // open the output file
`ifdef OUTPUT
      output_file = $fopen(`OUTPUT, "w");
      if (output_file == `NULL) begin
         $display("Error opening file: %s", `OUTPUT);
         $finish;
      end
`endif


      #80
      // Wait for global reset to finish
      rst = 0;
      #32;
  
      pipe_A = 1; // true
      while (10 == $fscanf(input_file, "%h %b %h %h %h %h %h %h %h %h", 
                           verify_pc,
                           verify_insn,
                           verify_regfile_we,
                           verify_regfile_reg,
                           verify_regfile_in,
                           verify_nzp_we,
                           verify_nzp_in,
                           verify_dmem_we,
                           verify_dmem_addr,
                           verify_dmem_value)) begin

         linenum = linenum + 1;
         
         if (output_file) begin
            $fdisplay(output_file, "%h %b %h %h %h %h %h %h %h %h",
                      verify_pc,
                      verify_insn,
                      verify_regfile_we,
                      verify_regfile_reg,
                      verify_regfile_in,
                      verify_nzp_we,
                      verify_nzp_in,
                      verify_dmem_we,
                      verify_dmem_addr,
                      verify_dmem_value);
         end
   
         next_instruction = 0;  // false
         while (!next_instruction) begin
            
            if (pipe_A) begin
               if (test_A_stall === 2'd0) begin
                  num_A_exec = num_A_exec + 1;

                  next_instruction = 1;  // true

                  test_pc =          test_A_pc;
                  test_insn =        test_A_insn;
                  test_regfile_we =  test_A_regfile_we;
                  test_regfile_reg = test_A_regfile_reg;
                  test_regfile_in =  test_A_regfile_in;
                  test_nzp_we =      test_A_nzp_we;
                  test_nzp_in =      test_A_nzp_in;
                  test_dmem_we =     test_A_dmem_we;
                  test_dmem_addr =   test_A_dmem_addr;
                  test_dmem_value =  test_A_dmem_value;
                  
               end
               
               if (test_A_stall === 2'd1) begin
                  num_A_branch_stall = num_A_branch_stall + 1;
               end
               
               if (test_A_stall === 2'd2) begin
                  num_A_load_stall = num_A_load_stall + 1;
               end

               if (test_A_stall === 2'd3) begin
                  num_A_ss_stall = num_A_ss_stall + 1;
               end
               
               
            end
            
            if (!pipe_A) begin
               
               if (test_B_stall === 2'd0) begin
                  num_B_exec = num_B_exec + 1;

                  next_instruction = 1;  // true

                  test_pc =          test_B_pc;
                  test_insn =        test_B_insn;
                  test_regfile_we =  test_B_regfile_we;
                  test_regfile_reg = test_B_regfile_reg;
                  test_regfile_in =  test_B_regfile_in;
                  test_nzp_we =      test_B_nzp_we;
                  test_nzp_in =      test_B_nzp_in;
                  test_dmem_we =     test_B_dmem_we;
                  test_dmem_addr =   test_B_dmem_addr;
                  test_dmem_value =  test_B_dmem_value;
                  
               end
               
               if (test_B_stall === 2'd1) begin
                  num_B_branch_stall = num_B_branch_stall + 1;
               end
               
               if (test_B_stall === 2'd2) begin
                  num_B_load_stall = num_B_load_stall + 1;
               end

               if (test_B_stall === 2'd3) begin
                  num_B_ss_stall = num_B_ss_stall + 1;
               end
               
            end 
            
            if (next_instruction) begin
               
               // Check it before fetching the next instruction
               
               // pc
               if (verify_pc !== test_pc) begin
                  $display( "Error at line %d: pc should be %h (but was %h)", 
                            linenum, verify_pc, test_pc);    
                  errors = errors + 1;
                  $finish;
               end
               
               // insn
               if (verify_insn !== test_insn) begin
                  $display( "Error at line %d: insn should be %h (but was %h)", 
                            linenum, verify_insn, test_insn);    
                  errors = errors + 1;
                  $finish;
               end
               
               // regfile_we
               if (verify_regfile_we !== test_regfile_we) begin
                  $display( "Error at line %d: regfile_we should be %h (but was %h)", 
                         linenum, verify_regfile_we, test_regfile_we);    
                  errors = errors + 1;
                  $finish;
               end
               
               // regfile_reg
               if (verify_regfile_we && verify_regfile_reg !== test_regfile_reg) begin
                  $display( "Error at line %d: regfile_reg should be %h (but was %h)", 
                            linenum, verify_regfile_reg, test_regfile_reg);    
                  errors = errors + 1;
                  $finish;
               end
               
               // regfile_in
               if (verify_regfile_we && verify_regfile_in !== test_regfile_in) begin
                  $display( "Error at line %d: regfile_in should be %h (but was %h)", 
                            linenum, verify_regfile_in, test_regfile_in);    
                  errors = errors + 1;
                  $finish;
               end
               
               // verify_nzp_we
               if (verify_nzp_we !== test_nzp_we) begin
                  $display( "Error at line %d: nzp_we should be %h (but was %h)", 
                            linenum, verify_nzp_we, test_nzp_we);    
                  errors = errors + 1;
                  $finish;
               end
               
               // verify_nzp_in
               if (verify_nzp_we && verify_nzp_in !== test_nzp_in) begin
                  $display( "Error at line %d: nzp_in should be %h (but was %h)", 
                            linenum, verify_nzp_in, test_nzp_in);    
                  errors = errors + 1;
                  $finish;
               end
               
               // verify_dmem_we
               if (verify_dmem_we !== test_dmem_we) begin
                  $display( "Error at line %d: dmem_we should be %h (but was %h)", 
                            linenum, verify_dmem_we, test_dmem_we);    
                  errors = errors + 1;
                  $finish;
               end
               
               // dmem_addr
               if (verify_dmem_addr !== test_dmem_addr) begin
                  $display( "Error at line %d: dmem_addr should be %h (but was %h)", 
                            linenum, verify_dmem_addr, test_dmem_addr);    
                  errors = errors + 1;
                  $finish;
               end
               
               // dmem_value
               if (verify_dmem_value !== test_dmem_value) begin
                  $display( "Error at line %d: dmem_value should be %h (but was %h)", 
                            linenum, verify_dmem_value, test_dmem_value);    
                  errors = errors + 1;
                  $finish;
               end
               
            end

            // Advanced to the next cycle
            if (!pipe_A) begin
               num_cycles = num_cycles + 1;
	       #40;  // Next cycle
            end

            pipe_A = !pipe_A;  // toggle which pipe to look at next
            
         end // while (!next_instruction)

      end // while (10 == $fscanf(input_file, "%h %b %h %h %h %h %h %h %h %h",...
      
         
      if (input_file) $fclose(input_file); 
      if (output_file) $fclose(output_file);
      $display("Simulation finished: %d test cases %d errors [%s]", linenum, errors, `INPUT);
      
      if (linenum != num_cycles) begin
         $display("  Instructions:         %d", linenum);
         $display("  Total Cycles:         %d", num_cycles);
         $display("  CPI x 1000: %d", 1000 * num_cycles / linenum);
         $display("  IPC x 1000: %d", 1000 * linenum / num_cycles);
         
         $display("  A Execution:          %d", num_A_exec);
	 $display("  A Branch stalls:      %d", num_A_branch_stall);
	 $display("  A Load stalls:        %d", num_A_load_stall);
      end
      
      if (num_B_exec != 0) begin
         $display("  A Superscalar stalls: %d", num_A_ss_stall);
         $display("  B Execution:          %d", num_B_exec);
         $display("  B Branch stalls:      %d", num_B_branch_stall);
	 $display("  B Load stalls:        %d", num_B_load_stall);
         $display("  B Superscalar stalls: %d", num_B_ss_stall);

      end
      
      $finish;
   end // initial begin
   
endmodule

