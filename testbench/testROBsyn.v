/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  testbench.v                                         //
//                                                                     //
//  Description :  Testbench module for ROB                            //
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

// Registers and wires used in the testbench
reg         reset;
reg         clock;
integer     wb_fileno;

reg         cdb_valid1;
reg         cdb_valid2;

reg  [63:0] NPC1_in;
reg  [63:0] PC1_in;
reg   [6:0] dest_PRN1_in;
reg   [6:0] dest_PRN_old1_in;
reg   [4:0] dest_ARN1_in;
reg         br_pred1_in;
reg         br_actual1_in;
reg  [63:0] target_addr1_in;
reg   [5:0] num1_in;
reg         wr_mem1_in;
reg         instr_valid1_in;

reg  [63:0] NPC2_in;
reg  [63:0] PC2_in;
reg   [6:0] dest_PRN2_in;
reg   [6:0] dest_PRN_old2_in;
reg   [4:0] dest_ARN2_in;
reg         br_pred2_in;
reg         br_actual2_in;
reg  [63:0] target_addr2_in;
reg   [5:0] num2_in;
reg         wr_mem2_in;
reg         instr_valid2_in;

wire  [6:0] to_RRAT_PRN1_out;
wire  [4:0] to_RRAT_ARN1_out;
wire  [6:0] to_PRF_PRN_old1_out;
wire [63:0] to_fetch_target_addr1_out;
wire        mis_predict1_out;
wire        valid1_out;
wire  [5:0] ROB_num1_out;

wire  [6:0] to_RRAT_PRN2_out;
wire  [4:0] to_RRAT_ARN2_out;
wire  [6:0] to_PRF_PRN_old2_out;
wire [63:0] to_fetch_target_addr2_out;
wire        mis_predict2_out;
wire        valid2_out;
wire  [5:0] ROB_num2_out;

wire        stall_out;

ROB rob64(
           // inputs:
           .reset(reset),
           .clock(clock),

           .ROB_NPC1_in(NPC1_in),
           .ROB_PC1_in(PC1_in),
           .ROB_dest_PRN1_in(dest_PRN1_in),
           .ROB_dest_PRN_old1_in(dest_PRN_old1_in),
           .ROB_dest_ARN1_in(dest_ARN1_in),
           .ROB_br_pred1_in(br_pred1_in),
           .ROB_br_actual1_in(br_actual1_in),
           .ROB_target_addr1_in(target_addr1_in),
           .ROB_num1_in(num1_in),
           .ROB_cdb_valid1_in(cdb_valid1),
           .ROB_wr_mem1_in(wr_mem1_in),
           .ROB_instr_valid1_in(instr_valid1_in),

           .ROB_NPC2_in(NPC2_in),
           .ROB_PC2_in(PC2_in),
           .ROB_dest_PRN2_in(dest_PRN2_in),
           .ROB_dest_PRN_old2_in(dest_PRN_old2_in),
           .ROB_dest_ARN2_in(dest_ARN2_in),
           .ROB_br_pred2_in(br_pred2_in),
           .ROB_br_actual2_in(br_actual2_in),
           .ROB_target_addr2_in(target_addr2_in),
           .ROB_num2_in(num2_in),
           .ROB_cdb_valid2_in(cdb_valid2),
           .ROB_wr_mem2_in(wr_mem2_in),
           .ROB_instr_valid2_in(instr_valid2_in),

           // outputs:
           .ROB_to_RRAT_PRN1_out(to_RRAT_PRN1_out),
           .ROB_to_RRAT_ARN1_out(to_RRAT_ARN1_out),
           .ROB_to_PRF_PRN_old1_out(to_PRF_PRN_old1_out),
           .ROB_to_fetch_target_addr1_out(to_fetch_target_addr1_out),
           .ROB_mis_predict1_out(mis_predict1_out),
           .ROB_valid1_out(valid1_out),
           .ROB_rs_ROB_num1_out(ROB_num1_out),

           .ROB_to_RRAT_PRN2_out(to_RRAT_PRN2_out),
           .ROB_to_RRAT_ARN2_out(to_RRAT_ARN2_out),
           .ROB_to_PRF_PRN_old2_out(to_PRF_PRN_old2_out),
           .ROB_to_fetch_target_addr2_out(to_fetch_target_addr2_out),
           .ROB_mis_predict2_out(mis_predict2_out),
           .ROB_valid2_out(valid2_out),
           .ROB_rs_ROB_num2_out(ROB_num2_out),

           .ROB_stall_out(stall_out)
          );
always
begin
  #20;
  #20;
  clock = ~clock;
end

// Task to display # of elapsed clock edges

initial
begin
  clock = 1'b0;
  reset = 1'b0;

  @(negedge clock);
  // Pulse the reset signal
  $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
  reset = 1'b1;
  @(negedge clock);

  `SD;
  `SD;
  // This reset is at an odd time to avoid the pos & neg clock edges

  reset = 1'b0;
  $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);

  wb_fileno = $fopen("ROB.out");

  cdb_valid1=0;
  cdb_valid2=0;

  instr_valid1_in = 0;
  instr_valid2_in = 0;

  //NPC1_in = 0;
  //PC1_in = 0;
  /*dest_PRN1_in = 0;
  dest_PRN_old1_in = 0;
  dest_ARN1_in = 0;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 0;*/
  wr_mem1_in = 0;    // not STQ


  //NPC2_in = 0;
  //PC2_in = 0;
/*  dest_PRN2_in = 0;
  dest_PRN_old2_in = 0;
  dest_ARN2_in = 0;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 0;*/
  wr_mem2_in = 0;    // not STQ

  @(negedge clock);

  // Test for inserting two valid regular alu instrs
  NPC1_in = 10;
  PC1_in = 12;
  dest_PRN1_in = 1;
  dest_PRN_old1_in = 2;
  dest_ARN1_in = 1;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 10;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 11;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 3;
  dest_ARN2_in = 2;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 11;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 1;
  $display("| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);


  // test for one of the instr invalid
  NPC1_in = 12;
  PC1_in = 12;
  dest_PRN1_in = 3;
  dest_PRN_old1_in = 4;
  dest_ARN1_in = 3;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 12;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 13;
  PC2_in = 12;
  dest_PRN2_in = 4;
  dest_PRN_old2_in = 5;
  dest_ARN2_in = 4;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 13;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 0;
  $display("| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);


  NPC1_in = 14;
  PC1_in = 12;
  dest_PRN1_in = 5;
  dest_PRN_old1_in = 6;
  dest_ARN1_in = 5;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 14;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 0;

  NPC2_in = 15;
  PC2_in = 12;
  dest_PRN2_in = 6;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 6;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 15;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 1;
  $display("| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  // test for 2 STQ inst
  NPC1_in = 16;
  PC1_in = 12;
  dest_PRN1_in = 7;
  dest_PRN_old1_in = 8;
  dest_ARN1_in = 7;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 16;
  wr_mem1_in = 1;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 17;
  PC2_in = 12;
  dest_PRN2_in = 8; 
  dest_PRN_old2_in = 9;
  dest_ARN2_in = 8;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 17;
  wr_mem2_in = 1;    // not STQ
  instr_valid2_in = 1;
  $display("| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  // test for branch mispred
  NPC1_in = 18;
  PC1_in = 12;
  dest_PRN1_in = 9;
  dest_PRN_old1_in = 10;
  dest_ARN1_in = 9;
  br_pred1_in = 0;
  br_actual1_in = 1;
  target_addr1_in = 18;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 19;
  PC2_in = 12;
  dest_PRN2_in = 10;
  dest_PRN_old2_in = 11;
  dest_ARN2_in = 10;
  br_pred2_in = 1;
  br_actual2_in = 1;
  target_addr2_in = 19;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 0;
  $display("| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  NPC1_in = 20;
  PC1_in = 12;
  dest_PRN1_in = 2;
  dest_PRN_old1_in = 7;
  dest_ARN1_in = 1;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 20;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 0;

  NPC2_in = 21;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 1;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 21;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 0;

  cdb_valid1 = 1;
  cdb_valid2 = 1;

  num1_in = 0;
  num2_in = 1;

  $display("@@ | to_RRAT_PRN1_out:  %d | to_RRAT_ARN1_out:  %d | to_PRF_PRN_old1_out:          %d |\n@@ | to_fetch_target_addr1_out:%d | mis_predict1_out:%d | valid1_out:%d |\n@@ | to_RRAT_PRN2_out:  %d | to_RRAT_ARN2_out:  %d | to_PRF_PRN_old2_out:          %d |\n@@ | to_fetch_target_addr2_out:%d | mis_predict2_out:%d | valid2_out:%d |\n| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    to_RRAT_PRN1_out, to_RRAT_ARN1_out, to_PRF_PRN_old1_out,
    to_fetch_target_addr1_out, mis_predict1_out, valid1_out,
    to_RRAT_PRN2_out, to_RRAT_ARN2_out, to_PRF_PRN_old2_out,
    to_fetch_target_addr2_out, mis_predict2_out, valid2_out,
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  num1_in = 2;
  num2_in = 3;

  $display("@@ | to_RRAT_PRN1_out:  %d | to_RRAT_ARN1_out:  %d | to_PRF_PRN_old1_out:          %d |\n@@ | to_fetch_target_addr1_out:%d | mis_predict1_out:%d | valid1_out:%d |\n@@ | to_RRAT_PRN2_out:  %d | to_RRAT_ARN2_out:  %d | to_PRF_PRN_old2_out:          %d |\n@@ | to_fetch_target_addr2_out:%d | mis_predict2_out:%d | valid2_out:%d |\n| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    to_RRAT_PRN1_out, to_RRAT_ARN1_out, to_PRF_PRN_old1_out,
    to_fetch_target_addr1_out, mis_predict1_out, valid1_out,
    to_RRAT_PRN2_out, to_RRAT_ARN2_out, to_PRF_PRN_old2_out,
    to_fetch_target_addr2_out, mis_predict2_out, valid2_out,
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  num1_in = 4;
  num2_in = 5;

  if(~(to_RRAT_PRN1_out===1
    && to_RRAT_ARN1_out===1
    && to_PRF_PRN_old1_out===2
    && to_fetch_target_addr1_out===10
    && mis_predict1_out===0
    && valid1_out===1
    && to_RRAT_PRN2_out===2
    && to_RRAT_ARN2_out===2
    && to_PRF_PRN_old2_out===3
    && to_fetch_target_addr2_out===11
    && mis_predict2_out===0
    && valid2_out===1))
  begin
    $display("@@                               **********");
    $display("@@                               * Failed1 *");
    $display("@@                               **********\n@@");
    //$finish;
  end

  $display("@@ | to_RRAT_PRN1_out:  %d | to_RRAT_ARN1_out:  %d | to_PRF_PRN_old1_out:          %d |\n@@ | to_fetch_target_addr1_out:%d | mis_predict1_out:%d | valid1_out:%d |\n@@ | to_RRAT_PRN2_out:  %d | to_RRAT_ARN2_out:  %d | to_PRF_PRN_old2_out:          %d |\n@@ | to_fetch_target_addr2_out:%d | mis_predict2_out:%d | valid2_out:%d |\n| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    to_RRAT_PRN1_out, to_RRAT_ARN1_out, to_PRF_PRN_old1_out,
    to_fetch_target_addr1_out, mis_predict1_out, valid1_out,
    to_RRAT_PRN2_out, to_RRAT_ARN2_out, to_PRF_PRN_old2_out,
    to_fetch_target_addr2_out, mis_predict2_out, valid2_out,
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  num1_in = 6;
  num2_in = 7;

  if(~(to_RRAT_PRN1_out===3
    && to_RRAT_ARN1_out===3
    && to_PRF_PRN_old1_out===4
    && to_fetch_target_addr1_out===12
    && mis_predict1_out===0
    && valid1_out===1
    && to_RRAT_PRN2_out===6
    && to_RRAT_ARN2_out===6
    && to_PRF_PRN_old2_out===7
    && to_fetch_target_addr2_out===15
    && mis_predict2_out===0
    && valid2_out===1))
  begin
    $display("@@                               **********");
    $display("@@                               * Failed2 *");
    $display("@@                               **********\n@@");
    //$finish;
  end

  $display("@@ | to_RRAT_PRN1_out:  %d | to_RRAT_ARN1_out:  %d | to_PRF_PRN_old1_out:          %d |\n@@ | to_fetch_target_addr1_out:%d | mis_predict1_out:%d | valid1_out:%d |\n@@ | to_RRAT_PRN2_out:  %d | to_RRAT_ARN2_out:  %d | to_PRF_PRN_old2_out:          %d |\n@@ | to_fetch_target_addr2_out:%d | mis_predict2_out:%d | valid2_out:%d |\n| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    to_RRAT_PRN1_out, to_RRAT_ARN1_out, to_PRF_PRN_old1_out,
    to_fetch_target_addr1_out, mis_predict1_out, valid1_out,
    to_RRAT_PRN2_out, to_RRAT_ARN2_out, to_PRF_PRN_old2_out,
    to_fetch_target_addr2_out, mis_predict2_out, valid2_out,
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  num1_in = 8;
  num2_in = 9;

  if(~(to_RRAT_PRN1_out===7
    && to_RRAT_ARN1_out===7
    && to_PRF_PRN_old1_out===8
    && to_fetch_target_addr1_out===16
    && mis_predict1_out===0
    && valid1_out===1
    && to_RRAT_PRN2_out===0
    && to_RRAT_ARN2_out===0
    && to_PRF_PRN_old2_out===0
    && to_fetch_target_addr2_out===0
    && mis_predict2_out===0
    && valid2_out===0))
  begin
    $display("@@                               **********");
    $display("@@                               * Failed3 *");
    $display("@@                               **********\n@@");
    //$finish;
  end

  $display("@@ | to_RRAT_PRN1_out:  %d | to_RRAT_ARN1_out:  %d | to_PRF_PRN_old1_out:          %d |\n@@ | to_fetch_target_addr1_out:%d | mis_predict1_out:%d | valid1_out:%d |\n@@ | to_RRAT_PRN2_out:  %d | to_RRAT_ARN2_out:  %d | to_PRF_PRN_old2_out:          %d |\n@@ | to_fetch_target_addr2_out:%d | mis_predict2_out:%d | valid2_out:%d |\n| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    to_RRAT_PRN1_out, to_RRAT_ARN1_out, to_PRF_PRN_old1_out,
    to_fetch_target_addr1_out, mis_predict1_out, valid1_out,
    to_RRAT_PRN2_out, to_RRAT_ARN2_out, to_PRF_PRN_old2_out,
    to_fetch_target_addr2_out, mis_predict2_out, valid2_out,
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  if(~(to_RRAT_PRN1_out===8
    && to_RRAT_ARN1_out===8
    && to_PRF_PRN_old1_out===9
    && to_fetch_target_addr1_out===17
    && mis_predict1_out===0
    && valid1_out===1
    && to_RRAT_PRN2_out===9
    && to_RRAT_ARN2_out===9
    && to_PRF_PRN_old2_out===10
    && to_fetch_target_addr2_out===18
    && mis_predict2_out===1
    && valid2_out===1))
  begin
    $display("@@                               **********");
    $display("@@                               * Failed4 *");
    $display("@@                               **********\n@@");
    //$finish;
  end

  $display("@@ | to_RRAT_PRN1_out:  %d | to_RRAT_ARN1_out:  %d | to_PRF_PRN_old1_out:          %d |\n@@ | to_fetch_target_addr1_out:%d | mis_predict1_out:%d | valid1_out:%d |\n@@ | to_RRAT_PRN2_out:  %d | to_RRAT_ARN2_out:  %d | to_PRF_PRN_old2_out:          %d |\n@@ | to_fetch_target_addr2_out:%d | mis_predict2_out:%d | valid2_out:%d |\n| ROB num 1 out: %d |\n| ROB num 2 out: %d |\n",
    to_RRAT_PRN1_out, to_RRAT_ARN1_out, to_PRF_PRN_old1_out,
    to_fetch_target_addr1_out, mis_predict1_out, valid1_out,
    to_RRAT_PRN2_out, to_RRAT_ARN2_out, to_PRF_PRN_old2_out,
    to_fetch_target_addr2_out, mis_predict2_out, valid2_out,
    ROB_num1_out, ROB_num2_out);

  @(negedge clock);

  $display("@@                               **********");
  $display("@@                               * Passed *");
  $display("@@                               **********\n@@");

  @(negedge clock);

  $finish;
end

endmodule  // module testbench

