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

reg  [63:0] NPC1_in;
reg  [63:0] PC1_in;
reg   [6:0] dest_PRN1_in;
reg   [6:0] dest_PRN_old1_in;
reg   [4:0] dest_ARN1_in;
reg         br_pred1_in;
reg         br_actual1_in;
reg  [63:0] target_addr1_in;
reg         load1_in;
reg   [6:0] cdb_dest_PRN1_in;
reg   [6:0] num1_in;
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
reg         load2_in;
reg   [6:0] cdb_dest_PRN2_in;
reg   [6:0] num2_in;
reg         wr_mem2_in;
reg         instr_valid2_in;

wire        flush1;
wire        flush2;

wire  [6:0] to_RRAT_PRN1_out;
wire  [5:0] to_RRAT_ARN1_out;
wire  [6:0] to_PRF_PRN_old1_out;
wire [63:0] to_fetch_target_addr1_out;

wire  [6:0] to_RRAT_PRN2_out;
wire  [5:0] to_RRAT_ARN2_out;
wire  [6:0] to_PRF_PRN_old2_out;
wire [63:0] to_fetch_target_addr2_out;

ROB rob64(
           // inputs:
           .reset(reset),
           .clock(clock),

           .ROB_load1_in(load1_in),
           .ROB_load2_in(load2_in),

           .ROB_NPC1_in(NPC1_in),
           .ROB_PC1_in(PC1_in),
           .ROB_dest_PRN1_in(dest_PRN1_in),
           .ROB_dest_PRN_old1_in(dest_PRN_old1_in),
           .ROB_dest_ARN1_in(dest_ARN1_in),
           .ROB_br_pred1_in(br_pred1_in),
           .ROB_br_actual1_in(br_actual1_in),
           .ROB_target_addr1_in(target_addr1_in),
           .ROB_cdb_dest_PRN1_in(cdb_dest_PRN1_in),
           .ROB_num1_in(num1_in),
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
           .ROB_cdb_dest_PRN2_in(cdb_dest_PRN2_in),
           .ROB_num2_in(num2_in),
           .ROB_wr_mem2_in(wr_mem2_in),
           .ROB_instr_valid2_in(instr_valid2_in),

           // outputs:
           .ROB_flush1(flush1),
           .ROB_flush2(flush2),

           .ROB_to_RRAT_PRN1_out(to_RRAT_PRN1_out),
           .ROB_to_RRAT_ARN1_out(to_RRAT_ARN1_out),
           .ROB_to_PRF_PRN_old1_out(to_PRF_PRN_old1_out),
           .ROB_to_fetch_target_addr1_out(to_fetch_target_addr1_out),
           .ROB_mis_predict1_out(mis_predict1_out),

           .ROB_to_RRAT_PRN2_out(to_RRAT_PRN2_out),
           .ROB_to_RRAT_ARN2_out(to_RRAT_ARN2_out),
           .ROB_to_PRF_PRN_old2_out(to_PRF_PRN_old2_out),
           .ROB_to_fetch_target_addr2_out(to_fetch_target_addr2_out),
           .ROB_mis_predict2_out(mis_predict2_out)
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

  // Pulse the reset signal
  $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
  reset = 1'b1;
  @(negedge clock);

  `SD;
  // This reset is at an odd time to avoid the pos & neg clock edges

  reset = 1'b0;
  $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
/*
  wb_fileno = $fopen("writeback.out");
  
  //Open header AFTER throwing the reset otherwise the reset state is displayed
  print_rs_header("============================================================================\n");
  print_rs_header("|                             ROB Data flow Result                         |\n");
  print_rs_header("============================================================================\n");

  //$monitor("H1:%d H2:%d NH1:%d T1:%d T2:%d NT1:&d ex_done1:%d, ex_done2:%d", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);


  //@(posedge clock);

  $display("control input");

  // test control
  NPC1_in = 16;
  PC1_in = 12;
  dest_PRN1_in = 2;
  dest_PRN_old1_in = 7;
  dest_ARN1_in = 1;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 24;
  load1_in = 1;
  cdb_dest_PRN1_in = 12;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 16;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 1;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 24;
  load2_in = 1;
  cdb_dest_PRN2_in = 12;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 1;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%b | rob_num2:%b | ex_done1:%b | ex_done2:%b |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  //@(negedge clock);
  @(negedge clock);

  $display("one instruction invalid");

  // test for one of the instr invalid
  NPC1_in = 16;
  PC1_in = 12;
  dest_PRN1_in = 2;
  dest_PRN_old1_in = 7;
  dest_ARN1_in = 1;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 24;
  load1_in = 1;
  cdb_dest_PRN1_in = 12;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 16;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 1;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 24;
  load2_in = 1;
  cdb_dest_PRN2_in = 12;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 0;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

 // @(negedge clock);
  @(negedge clock);

 $display("the other instruction invalid");

  NPC1_in = 16;
  PC1_in = 12;
  dest_PRN1_in = 2;
  dest_PRN_old1_in = 7;
  dest_ARN1_in = 1;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 24;
  load1_in = 1;
  cdb_dest_PRN1_in = 12;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 0;

  NPC2_in = 16;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 1;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 24;
  load2_in = 1;
  cdb_dest_PRN2_in = 12;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 1;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

 // @(negedge clock);
  @(negedge clock);

 $display("both instructions stores");

  // test for 2 STQ inst
  NPC1_in = 16;
  PC1_in = 12;
  dest_PRN1_in = 2;
  dest_PRN_old1_in = 7;
  dest_ARN1_in = 1;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 24;
  load1_in = 1;
  cdb_dest_PRN1_in = 12;
  wr_mem1_in = 1;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 16;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 1;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 24;
  load2_in = 1;
  cdb_dest_PRN2_in = 12;
  wr_mem2_in = 1;    // not STQ
  instr_valid2_in = 1;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

 // @(negedge clock);
  @(negedge clock);

 $display("branch misprediction");

  // test for branch mispred
  NPC1_in = 16;
  PC1_in = 12;
  dest_PRN1_in = 2;
  dest_PRN_old1_in = 7;
  dest_ARN1_in = 1;
  br_pred1_in = 1;
  br_actual1_in = 1;
  target_addr1_in = 24;
  load1_in = 1;
  cdb_dest_PRN1_in = 12;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 1;

  NPC2_in = 16;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 1;
  br_pred2_in = 0;
  br_actual2_in = 1;
  target_addr2_in = 24;
  load2_in = 1;
  cdb_dest_PRN2_in = 12;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 1;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  $display("0 and 1 are ready for commit");

  @(negedge clock);

 $display("the other instruction invalid");

  NPC1_in = 16;
  PC1_in = 12;
  dest_PRN1_in = 2;
  dest_PRN_old1_in = 7;
  dest_ARN1_in = 1;
  br_pred1_in = 0;
  br_actual1_in = 0;
  target_addr1_in = 24;
  load1_in = 1;
  cdb_dest_PRN1_in = 12;
  wr_mem1_in = 0;    // not STQ
  instr_valid1_in = 0;

  NPC2_in = 16;
  PC2_in = 12;
  dest_PRN2_in = 2;
  dest_PRN_old2_in = 7;
  dest_ARN2_in = 1;
  br_pred2_in = 0;
  br_actual2_in = 0;
  target_addr2_in = 24;
  load2_in = 1;
  cdb_dest_PRN2_in = 12;
  wr_mem2_in = 0;    // not STQ
  instr_valid2_in = 0;

  num1_in = 0;
  num2_in = 1;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  $display("2 and 3 are ready for commit");

  @(negedge clock);

  num1_in = 2;
  num2_in = 3;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  $display("4 and 5 are ready for commit");

  @(negedge clock);

  num1_in = 4;
  num2_in = 5;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  $display("6 and 7 are ready for commit");

  @(negedge clock);

  num1_in = 6;
  num2_in = 7;

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  @(negedge clock);

  num1_in = 8;
  num2_in = 9;

  $display("posedge clock");

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  @(negedge clock);

  $display("posedge clock");

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  @(negedge clock);

  $display("posedge clock");

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  @(negedge clock);

  $display("posedge clock");

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  @(negedge clock);

  $display("posedge clock");

  $display("| H1:%d | H2:%d | NH1:%d | T1:%d | T2:%d | NT1:%d | load1:%d | load2:%d | rob_num1:%d | rob_num2:%d | ex_done1:%d | ex_done2:%d |", ROB.ROB_head_pointer1, ROB.ROB_head_pointer2, ROB.next_ROB_head_pointer1, ROB.ROB_tail_pointer1, ROB.ROB_tail_pointer2, ROB.next_ROB_tail_pointer1, ROB.ROB_load_allowed1_in, ROB.ROB_load_allowed2_in, ROB.ROB_num1_in, ROB.ROB_num2_in, ROB.ex_done[ROB.ROB_head_pointer1], ROB.ex_done[ROB.ROB_head_pointer2]);

  @(negedge clock);
*/
  $finish;
end

endmodule  // module testbench

