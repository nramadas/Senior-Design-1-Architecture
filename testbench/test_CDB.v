/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  test_cdb.v                                          //
//                                                                     //
//  Description :  Testbench module for CDB                            //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

extern void print_header(string str);
extern void print_rs_header(string str);
extern void print_cycles();
extern void print_stage(string div, int inst, int npc, int valid_inst);
extern void print_reg(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                      int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
extern void print_membus(int proc2mem_command, int mem2proc_response,
                         int proc2mem_addr_hi, int proc2mem_addr_lo,
                         int proc2mem_data_hi, int proc2mem_data_lo);
extern void print_rs(int inst, int inuse, int ready, int opa1, int opa1_valid,
                     int opb1, int opb1_valid, int destPRN1, int ROB1_num, int opa2,
                     int opa2_valid, int opb2, int opb2_valid, int destPRN2,
                     int ROB2_num);
extern void print_close();

module testbench;

reg           clock;
reg           reset;

reg    [63:0] cdb_mult1_result;
reg     [5:0] cdb_ROB1_mult;
reg     [6:0] cdb_dest_PRN1_mult;
reg    [63:0] cdb_mult2_result;
reg     [5:0] cdb_ROB2_mult;
reg     [6:0] cdb_dest_PRN2_mult;

reg    [63:0] cdb_alu1_result;
reg     [5:0] cdb_ROB1_alu;
reg     [6:0] cdb_dest_PRN1_alu;
reg    [63:0] cdb_alu2_result;
reg     [5:0] cdb_ROB2_alu;
reg     [6:0] cdb_dest_PRN2_alu;

reg    [63:0] cdb_lsq1_result;
reg     [5:0] cdb_ROB1_lsq;
reg     [6:0] cdb_dest_PRN1_lsq;
reg    [63:0] cdb_lsq2_result;
reg     [5:0] cdb_ROB2_lsq;
reg     [6:0] cdb_dest_PRN2_lsq;

reg           cdb1_take_branch;
reg           cdb2_take_branch;

reg           alu0_valid;
reg           alu1_valid;

reg           mult0_done;
reg           mult1_done;

reg           lsq0_valid;
reg           lsq1_valid;

wire   [63:0] cdb1_result_out;
wire    [5:0] cdb1_ROB_out;
wire    [6:0] cdb1_PRN_out;
wire          cdb1_take_branch_out;
   
wire   [63:0] cdb2_result_out;
wire    [5:0] cdb2_ROB_out;
wire    [6:0] cdb2_PRN_out;
wire          cdb2_take_branch;

wire    [5:0] disable_vector_out;

cdb cdb_0(
      //inputs
      .clock(clock),
      .reset(reset),

      .cdb_alu1_result_in(cdb_alu1_result),
      .cdb_alu2_result_in(cdb_alu2_result),
      .cdb_ROB2_alu_in(cdb_ROB2_alu),
      .cdb_ROB1_alu_in(cdb_ROB1_alu),
      .cdb_dest_PRN1_alu_in(cdb_dest_PRN1_alu),
      .cdb_dest_PRN2_alu_in(cdb_dest_PRN2_alu),
      .alu0_valid(alu0_valid),
      .alu1_valid(alu1_valid),
   
      .cdb_mult1_result_in(cdb_mult1_result),
      .cdb_mult2_result_in(cdb_mult2_result),
      .cdb_ROB2_mult_in(cdb_ROB2_mult),
      .cdb_ROB1_mult_in(cdb_ROB1_mult),
      .cdb_dest_PRN1_mult_in(cdb_dest_PRN1_mult),
      .cdb_dest_PRN2_mult_in(cdb_dest_PRN2_mult),
      .cdb1_take_branch_in(cdb1_take_branch),
      .cdb2_take_branch_in(cdb2_take_branch),
      .mult0_done(mult0_done),
      .mult1_done(mult1_done),

      .cdb_lsq1_result_in(cdb_lsq1_result),
      .cdb_ROB1_lsq_in(cdb_ROB1_lsq),
      .cdb_dest_PRN1_lsq_in(cdb_dest_PRN1_lsq),
      .cdb_lsq2_result_in(cdb_lsq2_result),
      .cdb_ROB2_lsq_in(cdb_ROB2_lsq),
      .cdb_dest_PRN2_lsq_in(cdb_dest_PRN2_lsq),
      .lsq0_valid(lsq0_valid),
      .lsq1_valid(lsq1_valid),
   
      //outputs
      .cdb1_result_out(cdb1_result_out),
      .cdb1_ROB_out(cdb1_ROB_out),
      .cdb1_PRN_out(cdb1_PRN_out),
      .cdb1_take_branch(cdb1_take_branch_out),
   
      .cdb2_result_out(cdb2_result_out),
      .cdb2_ROB_out(cdb2_ROB_out),
      .cdb2_PRN_out(cdb2_PRN_out),
      .cdb2_take_branch(cdb2_take_branch_out),

      .disable_vector(disable_vector)
     );

always
begin
  #20;
  #20;
  clock = ~clock;
end

initial
begin
  clock = 1'b0;
  reset = 1'b1;

  // Pulse the reset signal
  $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
  reset = 1'b1;
  @(negedge clock);

  `SD;
  // This reset is at an odd time to avoid the pos & neg clock edges

  reset = 1'b0;
  $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
  $display("@@ Post Reset:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);

  @(negedge clock);

  cdb_mult1_result = 1;
  cdb_ROB1_mult = 2;
  cdb_dest_PRN1_mult = 1;
  cdb_mult2_result = 4;
  cdb_ROB2_mult = 3;
  cdb_dest_PRN2_mult = 2;

  cdb_alu1_result = 9;
  cdb_ROB1_alu = 4;
  cdb_dest_PRN1_alu = 3;
  cdb_alu2_result = 16;
  cdb_ROB2_alu = 5;
  cdb_dest_PRN2_alu = 4;

  cdb_lsq1_result = 25;
  cdb_ROB1_lsq = 0;
  cdb_dest_PRN1_lsq = 5;
  cdb_lsq2_result = 36;
  cdb_ROB2_lsq = 1;
  cdb_dest_PRN2_lsq = 6;

  cdb1_take_branch = 1;
  cdb2_take_branch = 0;

  alu0_valid = 1;
  alu1_valid = 1;

  mult0_done = 1;
  mult1_done = 1;

  lsq0_valid = 1;
  lsq1_valid = 1;

  $display("@@ All SIX units want cdb:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);


  @(negedge clock);

  cdb_mult1_result = 1;
  cdb_ROB1_mult = 2;
  cdb_dest_PRN1_mult = 1;
  cdb_mult2_result = 4;
  cdb_ROB2_mult = 3;
  cdb_dest_PRN2_mult = 2;

  cdb_alu1_result = 9;
  cdb_ROB1_alu = 4;
  cdb_dest_PRN1_alu = 3;
  cdb_alu2_result = 16;
  cdb_ROB2_alu = 5;
  cdb_dest_PRN2_alu = 4;

  cdb_lsq1_result = 25;
  cdb_ROB1_lsq = 0;
  cdb_dest_PRN1_lsq = 5;
  cdb_lsq2_result = 36;
  cdb_ROB2_lsq = 1;
  cdb_dest_PRN2_lsq = 6;

  cdb1_take_branch = 1;
  cdb2_take_branch = 0;

  alu0_valid = 1;
  alu1_valid = 1;

  mult0_done = 1;
  mult1_done = 1;

  lsq0_valid = 0;
  lsq1_valid = 0;

  $display("@@ Mult and alu want cdb:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);


  @(negedge clock);

  cdb_mult1_result = 1;
  cdb_ROB1_mult = 2;
  cdb_dest_PRN1_mult = 1;
  cdb_mult2_result = 4;
  cdb_ROB2_mult = 3;
  cdb_dest_PRN2_mult = 2;

  cdb_alu1_result = 9;
  cdb_ROB1_alu = 4;
  cdb_dest_PRN1_alu = 3;
  cdb_alu2_result = 16;
  cdb_ROB2_alu = 5;
  cdb_dest_PRN2_alu = 4;

  cdb_lsq1_result = 25;
  cdb_ROB1_lsq = 0;
  cdb_dest_PRN1_lsq = 5;
  cdb_lsq2_result = 36;
  cdb_ROB2_lsq = 1;
  cdb_dest_PRN2_lsq = 6;

  cdb1_take_branch = 1;
  cdb2_take_branch = 0;

  alu0_valid = 1;
  alu1_valid = 1;

  mult0_done = 0;
  mult1_done = 0;

  lsq0_valid = 0;
  lsq1_valid = 0;

  $display("@@ Alu wants cdb:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);

  @(negedge clock);

  cdb_mult1_result = 1;
  cdb_ROB1_mult = 2;
  cdb_dest_PRN1_mult = 1;
  cdb_mult2_result = 4;
  cdb_ROB2_mult = 3;
  cdb_dest_PRN2_mult = 2;

  cdb_alu1_result = 9;
  cdb_ROB1_alu = 4;
  cdb_dest_PRN1_alu = 3;
  cdb_alu2_result = 16;
  cdb_ROB2_alu = 5;
  cdb_dest_PRN2_alu = 4;

  cdb_lsq1_result = 25;
  cdb_ROB1_lsq = 0;
  cdb_dest_PRN1_lsq = 5;
  cdb_lsq2_result = 36;
  cdb_ROB2_lsq = 1;
  cdb_dest_PRN2_lsq = 6;

  cdb1_take_branch = 1;
  cdb2_take_branch = 0;

  alu0_valid = 1;
  alu1_valid = 1;

  mult0_done = 1;
  mult1_done = 1;

  lsq0_valid = 1;
  lsq1_valid = 0;

  $display("@@ All but top lsq wants cdb:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);


  @(negedge clock);

  cdb_mult1_result = 1;
  cdb_ROB1_mult = 2;
  cdb_dest_PRN1_mult = 1;
  cdb_mult2_result = 4;
  cdb_ROB2_mult = 3;
  cdb_dest_PRN2_mult = 2;

  cdb_alu1_result = 9;
  cdb_ROB1_alu = 4;
  cdb_dest_PRN1_alu = 3;
  cdb_alu2_result = 16;
  cdb_ROB2_alu = 5;
  cdb_dest_PRN2_alu = 4;

  cdb_lsq1_result = 25;
  cdb_ROB1_lsq = 0;
  cdb_dest_PRN1_lsq = 5;
  cdb_lsq2_result = 36;
  cdb_ROB2_lsq = 1;
  cdb_dest_PRN2_lsq = 6;

  cdb1_take_branch = 1;
  cdb2_take_branch = 0;

  alu0_valid = 1;
  alu1_valid = 1;

  mult0_done = 1;
  mult1_done = 0;

  lsq0_valid = 0;
  lsq1_valid = 0;

  $display("One mult and both alu's want cdb:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);


  @(negedge clock);

  cdb_mult1_result = 1;
  cdb_ROB1_mult = 2;
  cdb_dest_PRN1_mult = 1;
  cdb_mult2_result = 4;
  cdb_ROB2_mult = 3;
  cdb_dest_PRN2_mult = 2;

  cdb_alu1_result = 9;
  cdb_ROB1_alu = 4;
  cdb_dest_PRN1_alu = 3;
  cdb_alu2_result = 16;
  cdb_ROB2_alu = 5;
  cdb_dest_PRN2_alu = 4;

  cdb_lsq1_result = 25;
  cdb_ROB1_lsq = 0;
  cdb_dest_PRN1_lsq = 5;
  cdb_lsq2_result = 36;
  cdb_ROB2_lsq = 1;
  cdb_dest_PRN2_lsq = 6;

  cdb1_take_branch = 1;
  cdb2_take_branch = 0;

  alu0_valid = 1;
  alu1_valid = 0;

  mult0_done = 0;
  mult1_done = 0;

  lsq0_valid = 0;
  lsq1_valid = 1;

  $display("@@ One lsq and one alu want cdb:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);


  @(negedge clock);

  $display("@@ Next clock:");
  $display("@@ INPUTS:\n@@ | cdb_mult1_result:%d | cdb_ROB1_mult:%d | cdb_dest_PRN1_mult:%d | cdb_mult2_result:%d | cdb_ROB2_mult:%d | cdb_dest_PRN2_mult:%d | \n@@ | cdb_alu1_result: %d | cdb_ROB1_alu: %d | cdb_dest_PRN1_alu: %d | cdb_alu2_result: %d | cdb_ROB2_alu: %d | cdb_dest_PRN2_alu: %d | \n@@ | cdb_lsq1_result: %d | cdb_ROB1_lsq: %d | cdb_dest_PRN1_lsq: %d | cdb_lsq2_result: %d | cdb_ROB2_lsq: %d | cdb_dest_PRN2_lsq: %d | \n@@ | cdb1_take_branch:                   %d | cdb2_take_branch:                       %d |\n@@ | alu0_valid:                         %d | alu1_valid:                             %d |\n@@ | mult0_done:                         %d | mult1_done:                             %d |\n@@ | lsq0_valid:                         %d | lsq1_valid:                             %d |\n@@ OUTPUTS:\n@@ | cdb1_result_out: %d | cdb1_ROB_out: %d | cdb1_PRN_out:      %d | cdb1_take_branch_out:               %d |\n@@ | cdb2_result_out: %d | cdb2_ROB_out: %d | cdb2_PRN_out:      %d | cdb2_take_branch_out:               %d |\n@@ | disable_vector_out:%d |\n", cdb_mult1_result, cdb_ROB1_mult, cdb_dest_PRN1_mult, cdb_mult2_result, cdb_ROB2_mult, cdb_dest_PRN2_mult, cdb_alu1_result, cdb_ROB1_alu, cdb_dest_PRN1_alu, cdb_alu2_result, cdb_ROB2_alu, cdb_dest_PRN2_alu, cdb_lsq1_result, cdb_ROB1_lsq, cdb_dest_PRN1_lsq, cdb_lsq2_result, cdb_ROB2_lsq, cdb_dest_PRN2_lsq, cdb1_take_branch, cdb2_take_branch, alu0_valid, alu1_valid, mult0_done, mult1_done, lsq0_valid, lsq1_valid, cdb1_result_out, cdb1_ROB_out, cdb1_PRN_out, cdb1_take_branch_out, cdb2_result_out, cdb2_ROB_out, cdb2_PRN_out, cdb2_take_branch, disable_vector_out);


  @(negedge clock);

  @(negedge clock);

  $finish;
end

endmodule  // module testbench



