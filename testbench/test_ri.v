/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  test_ri.v                                           //
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

reg         clock;
reg         reset;

reg  [31:0] id_rename_IR1;
reg  [31:0] id_rename_IR2;
reg   [4:0] rename_dest_reg_idx_in1;
reg   [4:0] rename_dest_reg_idx_in2;
reg         rename_valid_IR1;
reg         rename_valid_IR2;

reg         copy1;
reg         copy2;

reg  [63:0] rename_cdb1_in;
reg   [6:0] rename_cdb1_tag;
reg         rename_cdb1_valid;
reg  [63:0] rename_cdb2_in;
reg   [6:0] rename_cdb2_tag;
reg         rename_cdb2_valid;
 
reg   [6:0] ROB_to_RRAT_PRN1_in;
reg   [4:0] ROB_to_RRAT_ARN1_in;
reg   [6:0] ROB_to_PRF_PRN_old1_in;
reg   [6:0] ROB_to_RRAT_PRN2_in;
reg   [4:0] ROB_to_RRAT_ARN2_in;
reg   [6:0] ROB_to_PRF_PRN_old2_in;
reg         ROB_valid1_in;
reg         ROB_valid2_in;

wire  [6:0] rename_dest_PRN1_out;
wire [63:0] rename_opa1_out;
wire  [6:0] rename_PRNa1_out;
wire        rename_opa1_valid;
wire [63:0] rename_opb1_out;
wire  [6:0] rename_PRNb1_out;
wire        rename_opb1_valid; 

wire  [6:0] rename_dest_PRN2_out;
wire [63:0] rename_opa2_out;
wire  [6:0] rename_PRNa2_out;
wire        rename_opa2_valid;
wire [63:0] rename_opb2_out;
wire  [6:0] rename_PRNb2_out;
wire        rename_opb2_valid;

//wire [95:0] test1;
//wire [95:0] test2;

rename_issue rename_issue_test(
   //inputs
   .clock(clock),
   .reset(reset),

   .id_rename_IR1(id_rename_IR1),
   .id_rename_IR2(id_rename_IR2),
   .rename_dest_reg_idx_in1(rename_dest_reg_idx_in1),
   .rename_dest_reg_idx_in2(rename_dest_reg_idx_in2),
   .rename_valid_IR1(rename_valid_IR1),
   .rename_valid_IR2(rename_valid_IR2),
  
   //commit inputs to update PRF Valid Bit(s) for the free register(s), RRAT and Both Free Lists
   .ROB_to_RRAT_PRN1_in(ROB_to_RRAT_PRN1_in),
   .ROB_to_RRAT_ARN1_in(ROB_to_RRAT_ARN1_in),
   .ROB_to_PRF_PRN_old1_in(ROB_to_PRF_PRN_old1_in),
   .ROB_to_RRAT_PRN2_in(ROB_to_RRAT_PRN2_in),
   .ROB_to_RRAT_ARN2_in(ROB_to_RRAT_ARN2_in),
   .ROB_to_PRF_PRN_old2_in(ROB_to_PRF_PRN_old2_in),
   .ROB_valid1_in(ROB_valid1_in),
   .ROB_valid2_in(ROB_valid2_in),
 				
    // ships passing in the night + executed instruction to update PRF      
   .rename_cdb1_in(rename_cdb1_in),
   .rename_cdb1_tag(rename_cdb1_tag),
   .rename_cdb1_valid(rename_cdb1_valid),
   .rename_cdb2_in(rename_cdb2_in),
   .rename_cdb2_tag(rename_cdb2_tag),
   .rename_cdb2_valid(rename_cdb2_valid),
					
   // if branch misprediction
   .copy1(copy1),
   .copy2(copy2),

   //outputs to Rename/Out of Order Pipeline Register for issue
   .rename_dest_PRN1_out(rename_dest_PRN1_out),
   .rename_opa1_out(rename_opa1_out),
   .rename_PRNa1_out(rename_PRNa1_out),
   .rename_opa1_valid(rename_opa1_valid),
   .rename_opb1_out(rename_opb1_out),
   .rename_PRNb1_out(rename_PRNb1_out),
   .rename_opb1_valid(rename_opb1_valid), 

   .rename_dest_PRN2_out(rename_dest_PRN2_out),
   .rename_opa2_out(rename_opa2_out),
   .rename_PRNa2_out(rename_PRNa2_out),
   .rename_opa2_valid(rename_opa2_valid),
   .rename_opb2_out(rename_opb2_out),
   .rename_PRNb2_out(rename_PRNb2_out),
   .rename_opb2_valid(rename_opb2_valid)//,

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
  id_rename_IR1 = 32'h0;
  id_rename_IR2 = 32'h0;
  rename_dest_reg_idx_in1 = 5'd0;
  rename_dest_reg_idx_in2 = 5'd0;
  rename_valid_IR1 = 1'b0;
  rename_valid_IR2 = 1'b0;

  copy1 = 0;
  copy2 = 0;

  rename_cdb1_in = 0;
  rename_cdb1_tag = 0;
  rename_cdb1_valid = 0;
  rename_cdb2_in = 0;
  rename_cdb2_tag = 0;
  rename_cdb2_valid = 0;
 
  ROB_to_RRAT_PRN1_in = 0;
  ROB_to_RRAT_ARN1_in = 0;
  ROB_to_PRF_PRN_old1_in = 0;
  ROB_to_RRAT_PRN2_in = 0;
  ROB_to_RRAT_ARN2_in = 0;
  ROB_to_PRF_PRN_old2_in = 0;
  ROB_valid1_in = 0;
  ROB_valid2_in = 0;

  // Pulse the reset signal
  $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
  reset = 1'b1;
  @(negedge clock);

  `SD;
  // This reset is at an odd time to avoid the pos & neg clock edges

  reset = 1'b0;
  $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
  $display("@@ 0) Post Reset:");
  //$display("@@\n@@ INPUTS:\n@@ | id_rename_IR1:  %h | id_rename_IR2:  %h | rename_dest_reg_idx_in1:%d | rename_dest_reg_idx_in2:%d |\n@@ | rename_valid_IR1:      %d | rename_valid_IR2:      %d |\n@@ | copy1:                 %d | copy2:                 %d |\n@@ | rename_cdb1_in:                %d | rename_cdb1_tag:       %d | rename_cdb1_valid:       %d |\n@@ | rename_cdb2_in:                %d | rename_cdb2_tag:       %d | rename_cdb2_valid:       %d |\n@@ | ROB_to_RRAT_PRN1_in: %d | ROB_to_RRAT_ARN1_in:  %d | ROB_to_PRF_PRN_old1_in:%d | ROB_valid1_in:           %d |\n@@ | ROB_to_RRAT_PRN2_in: %d | ROB_to_RRAT_ARN2_in:  %d | ROB_to_PRF_PRN_old2_in:%d | ROB_valid2_in:           %d |\n@@\n@@ OUTPUTS:\n@@ | rename_dest_PRN1_out:%d |\n@@ | rename_opa1_out:               %d | rename_PRNa1_out:      %d | rename_opa1_valid:       %d |\n@@ | rename_opb1_out:               %d | rename_PRNb1_out:      %d | rename_opb1_valid:       %d |\n@@ | rename_dest_PRN2_out:%d |\n@@ | rename_opa2_out:               %d | rename_PRNa2_out:      %d | rename_opa2_valid:       %d |\n@@ | rename_opb2_out:               %d | rename_PRNb2_out:      %d | rename_opb2_valid:       %d |\n@@", id_rename_IR1, id_rename_IR2, rename_dest_reg_idx_in1, rename_dest_reg_idx_in2, rename_valid_IR1, rename_valid_IR2, copy1, copy2, rename_cdb1_in, rename_cdb1_tag, rename_cdb1_valid, rename_cdb2_in, rename_cdb2_tag, rename_cdb2_valid, ROB_to_RRAT_PRN1_in, ROB_to_RRAT_ARN1_in, ROB_to_PRF_PRN_old1_in, ROB_valid1_in, ROB_to_RRAT_PRN2_in, ROB_to_RRAT_ARN2_in, ROB_to_PRF_PRN_old2_in, ROB_valid2_in, rename_dest_PRN1_out, rename_opa1_out, rename_PRNa1_out, rename_opa1_valid, rename_opb1_out, rename_PRNb1_out, rename_opb1_valid, rename_dest_PRN2_out, rename_opa2_out, rename_PRNa2_out, rename_opa2_valid, rename_opb2_out, rename_PRNb2_out, rename_opb2_valid);

  //$display("@@ LOOK AT ME!:\n@@ RAT_free_list:    %b\n@@ RAT_choose1_list: %b\n@@ RAT_choose2_list: %b\n@@ RRAT_free_list:   %b\n@@", rename_issue_test.RAT_free_list, rename_issue_test.RAT_choose1_list, rename_issue_test.RAT_choose2_list, rename_issue_test.RRAT_free_list);

  @(negedge clock); 

  id_rename_IR1 = 32'h203f0008;
  id_rename_IR2 = 32'h205f27bb;
  rename_dest_reg_idx_in1 = 5'd1;
  rename_dest_reg_idx_in2 = 5'd2;
  rename_valid_IR1 = 1'b1;
  rename_valid_IR2 = 1'b1;

  copy1 = 0;
  copy2 = 0;

  rename_cdb1_in = 578;
  rename_cdb1_tag = 65;
  rename_cdb1_valid = 1;
  rename_cdb2_in = 0;
  rename_cdb2_tag = 0;
  rename_cdb2_valid = 0;
 
  ROB_to_RRAT_PRN1_in = 0;
  ROB_to_RRAT_ARN1_in = 0;
  ROB_to_PRF_PRN_old1_in = 0;
  ROB_to_RRAT_PRN2_in = 0;
  ROB_to_RRAT_ARN2_in = 0;
  ROB_to_PRF_PRN_old2_in = 0;
  ROB_valid1_in = 0;
  ROB_valid2_in = 0;
  $display("rename_dest_PRN1_out:%d,rename_opa1_out:%d, rename_opb1_out:%d,rename_PRNa1_out:%d, rename_PRNb1_out:%d, ", rename_dest_PRN1_out,rename_opa1_out,rename_opb1_out,rename_PRNa1_out,rename_PRNb1_out);
  $display("rename_dest_PRN2_out:%d,rename_opa2_out:%d, rename_opb2_out:%d, rename_PRNa2_out:%d, rename_PRNb2_out:&d\n", rename_dest_PRN2_out,rename_opa2_out,rename_opb2_out,rename_PRNa2_out,rename_PRNb2_out); 

  @(negedge clock)
  $display("@@ 1) lda     $r1,0x8      start:  lda     $r2,0x27bb");  
  
  id_rename_IR1 = 32'h48421722;
  id_rename_IR2 = 32'h201f2ee6;
  rename_dest_reg_idx_in1 = 5'd0;
  rename_dest_reg_idx_in2 = 5'd2;
  rename_valid_IR1 = 1'b1;
  rename_valid_IR2 = 1'b1;

  copy1 = 0;
  copy2 = 0;

  rename_cdb2_in = 34343;
  rename_cdb2_tag = 62;
  rename_cdb2_valid = 1;
  rename_cdb1_in = 0;
  rename_cdb1_tag = 0;
  rename_cdb1_valid = 0;
 
  ROB_to_RRAT_PRN1_in = 0;
  ROB_to_RRAT_ARN1_in = 0;
  ROB_to_PRF_PRN_old1_in = 0;
  ROB_to_RRAT_PRN2_in = 0;
  ROB_to_RRAT_ARN2_in = 0;
  ROB_to_PRF_PRN_old2_in = 0;
  ROB_valid1_in = 0;
  ROB_valid2_in = 0;

  $display("rename_dest_PRN1_out:%d,rename_opa1_out:%d, rename_opb1_out:%d,rename_PRNa1_out:%d, rename_PRNb1_out:%d\n", rename_dest_PRN1_out,rename_opa1_out,rename_opb1_out,rename_PRNa1_out,rename_PRNb1_out);
  $display("rename_dest_PRN2_out:%d,rename_opa2_out:%d, rename_opb2_out:%d, rename_PRNa2_out:%d, rename_PRNb2_out:%d\n", rename_dest_PRN2_out,rename_opa2_out,rename_opb2_out,rename_PRNa2_out,rename_PRNb2_out); 
  $display("@@ 1)sll     $r2,16,$r2  2)lda     $r0,0x2ee6");
  @(negedge clock);
  
    id_rename_IR1 = 32'h44400402;
  id_rename_IR2 = 32'h201f087b;
  rename_dest_reg_idx_in1 = 5'd2;
  rename_dest_reg_idx_in2 = 5'd0;
  rename_valid_IR1 = 1'b1;
  rename_valid_IR2 = 1'b1;

  copy1 = 0;
  copy2 = 0;

  rename_cdb2_in = 34343;
  rename_cdb2_tag = 66;
  rename_cdb2_valid = 1	;
  rename_cdb1_in = 232;
  rename_cdb1_tag = 61;
  rename_cdb1_valid = 1;
 
  ROB_to_RRAT_PRN1_in = 0;
  ROB_to_RRAT_ARN1_in = 0;
  ROB_to_PRF_PRN_old1_in = 0;
  ROB_to_RRAT_PRN2_in = 0;
  ROB_to_RRAT_ARN2_in = 0;
  ROB_to_PRF_PRN_old2_in = 0;
  ROB_valid1_in = 0;
  ROB_valid2_in = 0;

    $display("rename_dest_PRN1_out:%d,rename_opa1_out:%d, rename_opb1_out:%d,rename_PRNa1_out:%d, rename_PRNb1_out:%d\n", rename_dest_PRN1_out,rename_opa1_out,rename_opb1_out,rename_PRNa1_out,rename_PRNb1_out);
  $display("rename_dest_PRN2_out:%d,rename_opa2_out:%d, rename_opb2_out:%d, rename_PRNa2_out:%d, rename_PRNb2_out:%d\n", rename_dest_PRN2_out,rename_opa2_out,rename_opb2_out,rename_PRNa2_out,rename_PRNb2_out); 
  @(negedge clock);

  $display("rename_dest_PRN1_out:%d,rename_opa1_out:%d, rename_opb1_out:%d,rename_PRNa1_out:%d, rename_PRNb1_out:%d\n", rename_dest_PRN1_out,rename_opa1_out,rename_opb1_out,rename_PRNa1_out,rename_PRNb1_out);
  $display("rename_dest_PRN2_out:%d,rename_opa2_out:%d, rename_opb2_out:%d, rename_PRNa2_out:%d, rename_PRNb2_out:%d\n", rename_dest_PRN2_out,rename_opa2_out,rename_opb2_out,rename_PRNa2_out,rename_PRNb2_out); 
  @(negedge clock);

  $display("rename_dest_PRN1_out:%d,rename_opa1_out:%d, rename_opb1_out:%d,rename_PRNa1_out:%d, rename_PRNb1_out:%d\n", rename_dest_PRN1_out,rename_opa1_out,rename_opb1_out,rename_PRNa1_out,rename_PRNb1_out);
  $display("rename_dest_PRN2_out:%d,rename_opa2_out:%d, rename_opb2_out:%d, rename_PRNa2_out:%d, rename_PRNb2_out:%d\n", rename_dest_PRN2_out,rename_opa2_out,rename_opb2_out,rename_PRNa2_out,rename_PRNb2_out); 
  @(negedge clock);

  $display("rename_dest_PRN1_out:%d,rename_opa1_out:%d, rename_opb1_out:%d,rename_PRNa1_out:%d, rename_PRNb1_out:%d\n", rename_dest_PRN1_out,rename_opa1_out,rename_opb1_out,rename_PRNa1_out,rename_PRNb1_out);
  $display("rename_dest_PRN2_out:%d,rename_opa2_out:%d, rename_opb2_out:%d, rename_PRNa2_out:%d, rename_PRNb2_out:%d\n", rename_dest_PRN2_out,rename_opa2_out,rename_opb2_out,rename_PRNa2_out,rename_PRNb2_out); 

   $finish;
end
endmodule
