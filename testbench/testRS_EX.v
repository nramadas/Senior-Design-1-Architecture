/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  testbench.v                                         //
//                                                                     //
//  Description :  Testbench module for the verisimple pipeline;       //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

extern void print_header(string str);
extern void print_cycles();
extern void print_stage(string div, int inst, int npc, int valid_inst);
extern void print_reg(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                      int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
extern void print_commit(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                  int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
extern void print_membus(int proc2mem_command, int mem2proc_response,
                         int proc2mem_addr_hi, int proc2mem_addr_lo,
                         int proc2mem_data_hi, int proc2mem_data_lo);
extern void print_close();
// New stuff
extern void reg_close();
extern void check_reset(int);
extern void print_reg_header();

module testbench;

// Registers and wires ufile:///usr/share/doc/HTML/en-US/index.htmlsed in the testbench
reg  [31:0]  clock_count;
reg  [31:0]  instr_count;
integer      wb_fileno;
integer      wb_filen1;
integer      wb_filen2;
reg          correct;

reg   [3:0]  rs_complete_inst;

reg          reset;                       // reset signal 
reg          clock;                       // the clock 

reg   [6:0]  rs_dest_PRN1_in;             // The destination of this instruction 
reg   [6:0]  is_ooc_dest_PRN1_old_in;
reg   [4:0]  is_ooc_dest_ARN1_in;
reg  [63:0]  rs_opa1_in;                  // Operand a from Rename  
reg   [6:0]  rs_PRNa1_in;                 // Physical Register Number for opA
reg          rs_opa1_valid;               // Is Opa a Tag or immediate data
reg  [63:0]  rs_opb1_in;                  // Operand a from Rename 
reg   [6:0]  rs_PRNb1_in;                 // Physical Register Number for opB
reg          rs_opb1_valid;               // Is Opb a tag or immediate data
reg          rs_cond_branch1_in;
reg          rs_uncond_branch1_in;
reg          is_ooc_branch_pred1_in;
reg  [63:0]  rs_issue_NPC1_in;            // Next PC from issue stage
reg  [63:0]  is_ooc_issue_PC1_in;
reg  [31:0]  rs_issue_IR1_in;             // instruction from issue stage
reg   [4:0]  rs_alu_func1_in;             // alu opcode from issue stage
reg   [5:0]  rs_ROB1_in;                  // ROB entry number
reg   [1:0]  rs_opa_select1_in;
reg   [1:0]  rs_opb_select1_in;
reg          rs_rd_mem1_in;
reg          rs_wr_mem1_in;
reg          rs_instr_valid1_in;

reg   [6:0]  rs_dest_PRN2_in;             // The destination of this instruction 
reg   [6:0]  is_ooc_dest_PRN2_old_in;
reg   [4:0]  is_ooc_dest_ARN2_in;
reg  [63:0]  rs_opa2_in;                  // Operand a from Rename  
reg   [6:0]  rs_PRNa2_in;                 // Physical Register Number for opA
reg          rs_opa2_valid;               // Is Opa a Tag or immediate data
reg  [63:0]  rs_opb2_in;                  // Operand a from Rename 
reg   [6:0]  rs_PRNb2_in;                 // Physical Register Number for opB
reg          rs_opb2_valid;               // Is Opb a tag or immediate data
reg          rs_cond_branch2_in;
reg          rs_uncond_branch2_in;
reg          is_ooc_branch_pred2_in;
reg  [63:0]  rs_issue_NPC2_in;            // Next PC from issue stage
reg  [63:0]  is_ooc_issue_PC2_in;
reg  [31:0]  rs_issue_IR2_in;             // instruction from issue stage
reg   [4:0]  rs_alu_func2_in;             // alu opcode from issue stage
reg   [5:0]  rs_ROB2_in;                  // ROB entry number
reg   [1:0]  rs_opa_select2_in;
reg   [1:0]  rs_opb_select2_in;
reg          rs_rd_mem2_in;
reg          rs_wr_mem2_in;
reg          rs_instr_valid2_in;

reg          cdb_mult_tag1;
reg          cdb_mult_tag2;
reg          cdb_alu_tag1;
reg          cdb_alu_tag2;

reg  [63:0]  opA1_alu;
reg  [63:0]  opB1_alu;
reg  [63:0]  opA2_alu;
reg  [63:0]  opB2_alu;
reg   [6:0]  destPRN1_alu;
reg   [6:0]  destPRN2_alu;
reg   [5:0]  rob1;

reg  [63:0]  opA1_mult;
reg  [63:0]  opB1_mult;
reg  [63:0]  opA2_mult;
reg  [63:0]  opB2_mult;
reg   [6:0]  destPRN1_mult;
reg   [6:0]  destPRN2_mult;
reg   [5:0]  rob2;

wire [63:0]  ex_alu1_result_out;
wire  [5:0]  ex_ROB1_alu_out;
wire  [6:0]  ex_dest_PRN1_alu_out;
wire [63:0]  ex_alu2_result_out;
wire  [5:0]  ex_ROB2_alu_out;
wire  [6:0]  ex_dest_PRN2_alu_out;
wire         ex1_take_branch_out;  // is this a taken branch?
wire         ex2_take_branch_out;

wire         alu0_valid_out;
wire         alu1_valid_out;

wire [63:0]  ex_mult1_result_out;
wire  [5:0]  ex_ROB1_mult_out;
wire  [6:0]  ex_dest_PRN1_mult_out;
wire [63:0]  ex_mult2_result_out;
wire  [5:0]  ex_ROB2_mult_out;
wire  [6:0]  ex_dest_PRN2_mult_out;

wire         mult0_done;
wire         mult1_done;

wire  [6:0]  ooc_ROB_to_RRAT_PRN1_out;
wire  [4:0]  ooc_ROB_to_RRAT_ARN1_out;
wire  [6:0]  ooc_ROB_to_PRF_PRN_old1_out;
wire [63:0]  ooc_ROB_to_fetch_target_addr1_out;
wire         ooc_ROB_mis_predict1_out;
wire         ooc_ROB_valid1_out;

wire  [6:0]  ooc_ROB_to_RRAT_PRN2_out;
wire  [4:0]  ooc_ROB_to_RRAT_ARN2_out;
wire  [6:0]  ooc_ROB_to_PRF_PRN_old2_out;
wire [63:0]  ooc_ROB_to_fetch_target_addr2_out;
wire         ooc_ROB_mis_predict2_out;
wire         ooc_ROB_valid2_out;

wire [63:0]  cdb1_result_out;
wire  [6:0]  cdb1_PRN_out;
wire         cdb1_valid_out;

wire [63:0]  cdb2_result_out;
wire  [6:0]  cdb2_PRN_out;
wire         cdb2_valid_out;

wire         rs_stall_out;
wire         ROB_stall_out;

ooc   OOF(// inputs:
          .reset(reset),
          .clock(clock),

          // input : instruction 1 from the issue stage
          .is_ooc_dest_PRN1_in(rs_dest_PRN1_in),
          .is_ooc_dest_PRN1_old_in(is_ooc_dest_PRN1_old_in),
          .is_ooc_dest_ARN1_in(is_ooc_dest_ARN1_in),
          .is_ooc_opa1_in(rs_opa1_in),
          .is_ooc_PRNa1_in(rs_PRNa1_in),
          .is_ooc_opa1_valid(rs_opa1_valid),
          .is_ooc_opb1_in(rs_opb1_in),
          .is_ooc_PRNb1_in(rs_PRNb1_in),
          .is_ooc_opb1_valid(rs_opb1_valid), 
          .is_ooc_cond_branch1_in(rs_cond_branch1_in),
          .is_ooc_uncond_branch1_in(rs_uncond_branch1_in),
          .is_ooc_branch_pred1_in(is_ooc_branch_pred1_in),
          .is_ooc_issue_NPC1_in(rs_issue_NPC1_in),
          .is_ooc_issue_PC1_in(is_ooc_issue_PC1_in),
          .is_ooc_issue_IR1_in(rs_issue_IR1_in),
          .is_ooc_alu_func1_in(rs_alu_func1_in),
          //.is_ooc_ROB1_in(rs_ROB1_in),
          .is_ooc_opa_select1_in(rs_opa_select1_in),
          .is_ooc_opb_select1_in(rs_opb_select1_in),
          .is_ooc_rd_mem1_in(rs_rd_mem1_in),
          .is_ooc_wr_mem1_in(rs_wr_mem1_in),
          .is_ooc_instr_valid1_in(rs_instr_valid1_in),

          // input : instruction 2 from the issue stage
          .is_ooc_dest_PRN2_in(rs_dest_PRN2_in),
          .is_ooc_dest_PRN2_old_in(is_ooc_dest_PRN2_old_in),
          .is_ooc_dest_ARN2_in(is_ooc_dest_ARN2_in),
          .is_ooc_opa2_in(rs_opa2_in),
          .is_ooc_PRNa2_in(rs_PRNa2_in),
          .is_ooc_opa2_valid(rs_opa2_valid),
          .is_ooc_opb2_in(rs_opb2_in),
          .is_ooc_PRNb2_in(rs_PRNb2_in),
          .is_ooc_opb2_valid(rs_opb2_valid), 
          .is_ooc_cond_branch2_in(rs_cond_branch2_in),
          .is_ooc_uncond_branch2_in(rs_uncond_branch2_in),
          .is_ooc_branch_pred2_in(is_ooc_branch_pred2_in),
          .is_ooc_issue_NPC2_in(rs_issue_NPC2_in),
          .is_ooc_issue_PC2_in(is_ooc_issue_PC2_in),
          .is_ooc_issue_IR2_in(rs_issue_IR2_in),
          .is_ooc_alu_func2_in(rs_alu_func2_in),
          //.is_ooc_ROB2_in(rs_ROB2_in),
          .is_ooc_opa_select2_in(rs_opa_select2_in),
          .is_ooc_opb_select2_in(rs_opb_select2_in),
          .is_ooc_rd_mem2_in(rs_rd_mem2_in),
          .is_ooc_wr_mem2_in(rs_wr_mem2_in),
          .is_ooc_instr_valid2_in(rs_instr_valid2_in),

          // outputs from RS
          .rs_stall_out(rs_stall_out),

          // outputs from RS
          .ROB_stall_out(ROB_stall_out),

          //outputs from alu FU
          .ex_alu1_result_out(ex_alu1_result_out),
          .ex_alu2_result_out(ex_alu2_result_out),
          .ex_ROB1_alu_out(ex_ROB1_alu_out),
          .ex_ROB2_alu_out(ex_ROB2_alu_out),
          .ex_dest_PRN1_alu_out(ex_dest_PRN1_alu_out),
          .ex_dest_PRN2_alu_out(ex_dest_PRN2_alu_out),
          .ex1_take_branch_out(ex1_take_branch_out),
          .ex2_take_branch_out(ex2_take_branch_out),

          .alu0_valid_out(alu0_valid_out),
          .alu1_valid_out(alu1_valid_out),

          // output from mult FU
          .ex_mult1_result_out(ex_mult1_result_out),
          .ex_mult2_result_out(ex_mult2_result_out),
          .ex_ROB2_mult_out(ex_ROB2_mult_out),
          .ex_ROB1_mult_out(ex_ROB1_mult_out),
          .ex_dest_PRN1_mult_out(ex_dest_PRN1_mult_out),
          .ex_dest_PRN2_mult_out(ex_dest_PRN2_mult_out),

          .mult0_done(mult0_done),
          .mult1_done(mult1_done),

          // output from ROB
          .ooc_ROB_to_RRAT_PRN1_out(ooc_ROB_to_RRAT_PRN1_out),
          .ooc_ROB_to_RRAT_ARN1_out(ooc_ROB_to_RRAT_ARN1_out),
          .ooc_ROB_to_PRF_PRN_old1_out(ooc_ROB_to_PRF_PRN_old1_out),
          .ooc_ROB_to_fetch_target_addr1_out(ooc_ROB_to_fetch_target_addr1_out),
          .ooc_ROB_mis_predict1_out(ooc_ROB_mis_predict1_out),
          .ooc_ROB_valid1_out(ooc_ROB_valid1_out),

          .ooc_ROB_to_RRAT_PRN2_out(ooc_ROB_to_RRAT_PRN2_out),
          .ooc_ROB_to_RRAT_ARN2_out(ooc_ROB_to_RRAT_ARN2_out),
          .ooc_ROB_to_PRF_PRN_old2_out(ooc_ROB_to_PRF_PRN_old2_out),
          .ooc_ROB_to_fetch_target_addr2_out(ooc_ROB_to_fetch_target_addr2_out),
          .ooc_ROB_mis_predict2_out(ooc_ROB_mis_predict2_out),
          .ooc_ROB_valid2_out(ooc_ROB_valid2_out),

          //outputs from CDB to PRF
          .cdb1_result_out(cdb1_result_out),
          .cdb1_PRN_out(cdb1_PRN_out),
          .cdb1_valid_out(cdb1_valid_out),

          .cdb2_result_out(cdb2_result_out),
          .cdb2_PRN_out(cdb2_PRN_out),
          .cdb2_valid_out(cdb2_valid_out));

always
begin
  #(`VERILOG_CLOCK_PERIOD/2.0);
  clock = ~clock;
end

task print_result;
begin
  //
end
endtask

task show_clk_count;
  real cpi;
  begin
  cpi = (clock_count + 1.0) / instr_count;
    $display("@@");
    $display("@@  %0d cycles / %0d instrs = %f CPI\n@@",
             clock_count+1, instr_count, cpi);
    $display("@@  %4.2f ns total time to execute\n@@\n",
                  clock_count*`VIRTUAL_CLOCK_PERIOD);
  end
endtask  // task show_clk_count 

task print_RS;
begin
  `ifdef SIM
  $fdisplay(wb_fileno, "============================================[ ALU RS ]===============================================");
  $fdisplay(wb_fileno, "[00] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[15], OOF.rs32.rs_avail_out_alu[15],
            OOF.rs32.rs_table_alu[15].OPaValid, OOF.rs32.rs_table_alu[15].OPa,
            OOF.rs32.rs_table_alu[15].OPbValid, OOF.rs32.rs_table_alu[15].OPb,
            OOF.rs32.rs_table_alu[15].DestTag);
  $fdisplay(wb_fileno, "[01] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[14], OOF.rs32.rs_avail_out_alu[14],
            OOF.rs32.rs_table_alu[14].OPaValid, OOF.rs32.rs_table_alu[14].OPa,
            OOF.rs32.rs_table_alu[14].OPbValid, OOF.rs32.rs_table_alu[14].OPb,
            OOF.rs32.rs_table_alu[14].DestTag);
  $fdisplay(wb_fileno, "[02] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[13], OOF.rs32.rs_avail_out_alu[13],
            OOF.rs32.rs_table_alu[13].OPaValid, OOF.rs32.rs_table_alu[13].OPa,
            OOF.rs32.rs_table_alu[13].OPbValid, OOF.rs32.rs_table_alu[13].OPb,
            OOF.rs32.rs_table_alu[13].DestTag);
  $fdisplay(wb_fileno, "[03] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[12], OOF.rs32.rs_avail_out_alu[12],
            OOF.rs32.rs_table_alu[12].OPaValid, OOF.rs32.rs_table_alu[12].OPa,
            OOF.rs32.rs_table_alu[12].OPbValid, OOF.rs32.rs_table_alu[12].OPb,
            OOF.rs32.rs_table_alu[12].DestTag);
  $fdisplay(wb_fileno, "[04] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[11], OOF.rs32.rs_avail_out_alu[11],
            OOF.rs32.rs_table_alu[11].OPaValid, OOF.rs32.rs_table_alu[11].OPa,
            OOF.rs32.rs_table_alu[11].OPbValid, OOF.rs32.rs_table_alu[11].OPb,
            OOF.rs32.rs_table_alu[11].DestTag);
  $fdisplay(wb_fileno, "[05] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[10], OOF.rs32.rs_avail_out_alu[10],
            OOF.rs32.rs_table_alu[10].OPaValid, OOF.rs32.rs_table_alu[10].OPa,
            OOF.rs32.rs_table_alu[10].OPbValid, OOF.rs32.rs_table_alu[10].OPb,
            OOF.rs32.rs_table_alu[10].DestTag);
  $fdisplay(wb_fileno, "[06] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[9], OOF.rs32.rs_avail_out_alu[9],
            OOF.rs32.rs_table_alu[9].OPaValid, OOF.rs32.rs_table_alu[9].OPa,
            OOF.rs32.rs_table_alu[9].OPbValid, OOF.rs32.rs_table_alu[9].OPb,
            OOF.rs32.rs_table_alu[9].DestTag);
  $fdisplay(wb_fileno, "[07] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[8], OOF.rs32.rs_avail_out_alu[8],
            OOF.rs32.rs_table_alu[8].OPaValid, OOF.rs32.rs_table_alu[8].OPa,
            OOF.rs32.rs_table_alu[8].OPbValid, OOF.rs32.rs_table_alu[8].OPb,
            OOF.rs32.rs_table_alu[8].DestTag);
  $fdisplay(wb_fileno, "[08] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[7], OOF.rs32.rs_avail_out_alu[7],
            OOF.rs32.rs_table_alu[7].OPaValid, OOF.rs32.rs_table_alu[7].OPa,
            OOF.rs32.rs_table_alu[7].OPbValid, OOF.rs32.rs_table_alu[7].OPb,
            OOF.rs32.rs_table_alu[7].DestTag);
  $fdisplay(wb_fileno, "[09] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[6], OOF.rs32.rs_avail_out_alu[6],
            OOF.rs32.rs_table_alu[6].OPaValid, OOF.rs32.rs_table_alu[6].OPa,
            OOF.rs32.rs_table_alu[6].OPbValid, OOF.rs32.rs_table_alu[6].OPb,
            OOF.rs32.rs_table_alu[6].DestTag);
  $fdisplay(wb_fileno, "[10] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[5], OOF.rs32.rs_avail_out_alu[5],
            OOF.rs32.rs_table_alu[5].OPaValid, OOF.rs32.rs_table_alu[5].OPa,
            OOF.rs32.rs_table_alu[5].OPbValid, OOF.rs32.rs_table_alu[5].OPb,
            OOF.rs32.rs_table_alu[5].DestTag);
  $fdisplay(wb_fileno, "[11] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[4], OOF.rs32.rs_avail_out_alu[4],
            OOF.rs32.rs_table_alu[4].OPaValid, OOF.rs32.rs_table_alu[4].OPa,
            OOF.rs32.rs_table_alu[4].OPbValid, OOF.rs32.rs_table_alu[4].OPb,
            OOF.rs32.rs_table_alu[4].DestTag);
  $fdisplay(wb_fileno, "[12] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[3], OOF.rs32.rs_avail_out_alu[3],
            OOF.rs32.rs_table_alu[3].OPaValid, OOF.rs32.rs_table_alu[3].OPa,
            OOF.rs32.rs_table_alu[3].OPbValid, OOF.rs32.rs_table_alu[3].OPb,
            OOF.rs32.rs_table_alu[3].DestTag);
  $fdisplay(wb_fileno, "[13] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[2], OOF.rs32.rs_avail_out_alu[2],
            OOF.rs32.rs_table_alu[2].OPaValid, OOF.rs32.rs_table_alu[2].OPa,
            OOF.rs32.rs_table_alu[2].OPbValid, OOF.rs32.rs_table_alu[2].OPb,
            OOF.rs32.rs_table_alu[2].DestTag);
  $fdisplay(wb_fileno, "[14] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[1], OOF.rs32.rs_avail_out_alu[1],
            OOF.rs32.rs_table_alu[1].OPaValid, OOF.rs32.rs_table_alu[1].OPa,
            OOF.rs32.rs_table_alu[1].OPbValid, OOF.rs32.rs_table_alu[1].OPb,
            OOF.rs32.rs_table_alu[1].DestTag);
  $fdisplay(wb_fileno, "[15] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_alu[0], OOF.rs32.rs_avail_out_alu[0],
            OOF.rs32.rs_table_alu[0].OPaValid, OOF.rs32.rs_table_alu[0].OPa,
            OOF.rs32.rs_table_alu[0].OPbValid, OOF.rs32.rs_table_alu[0].OPb,
            OOF.rs32.rs_table_alu[0].DestTag);
  $fdisplay(wb_fileno, "============================================[ MUL RS ]===============================================");
  $fdisplay(wb_fileno, "[00] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[15], OOF.rs32.rs_avail_out_mult[15],
            OOF.rs32.rs_table_mult[15].OPaValid, OOF.rs32.rs_table_mult[15].OPa,
            OOF.rs32.rs_table_mult[15].OPbValid, OOF.rs32.rs_table_mult[15].OPb,
            OOF.rs32.rs_table_mult[15].DestTag);
  $fdisplay(wb_fileno, "[01] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[14], OOF.rs32.rs_avail_out_mult[14],
            OOF.rs32.rs_table_mult[14].OPaValid, OOF.rs32.rs_table_mult[14].OPa,
            OOF.rs32.rs_table_mult[14].OPbValid, OOF.rs32.rs_table_mult[14].OPb,
            OOF.rs32.rs_table_mult[14].DestTag);
  $fdisplay(wb_fileno, "[02] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[13], OOF.rs32.rs_avail_out_mult[13],
            OOF.rs32.rs_table_mult[13].OPaValid, OOF.rs32.rs_table_mult[13].OPa,
            OOF.rs32.rs_table_mult[13].OPbValid, OOF.rs32.rs_table_mult[13].OPb,
            OOF.rs32.rs_table_mult[13].DestTag);
  $fdisplay(wb_fileno, "[03] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[12], OOF.rs32.rs_avail_out_mult[12],
            OOF.rs32.rs_table_mult[12].OPaValid, OOF.rs32.rs_table_mult[12].OPa,
            OOF.rs32.rs_table_mult[12].OPbValid, OOF.rs32.rs_table_mult[12].OPb,
            OOF.rs32.rs_table_mult[12].DestTag);
  $fdisplay(wb_fileno, "[04] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[11], OOF.rs32.rs_avail_out_mult[11],
            OOF.rs32.rs_table_mult[11].OPaValid, OOF.rs32.rs_table_mult[11].OPa,
            OOF.rs32.rs_table_mult[11].OPbValid, OOF.rs32.rs_table_mult[11].OPb,
            OOF.rs32.rs_table_mult[11].DestTag);
  $fdisplay(wb_fileno, "[05] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[10], OOF.rs32.rs_avail_out_mult[10],
            OOF.rs32.rs_table_mult[10].OPaValid, OOF.rs32.rs_table_mult[10].OPa,
            OOF.rs32.rs_table_mult[10].OPbValid, OOF.rs32.rs_table_mult[10].OPb,
            OOF.rs32.rs_table_mult[10].DestTag);
  $fdisplay(wb_fileno, "[06] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[9], OOF.rs32.rs_avail_out_mult[9],
            OOF.rs32.rs_table_mult[9].OPaValid, OOF.rs32.rs_table_mult[9].OPa,
            OOF.rs32.rs_table_mult[9].OPbValid, OOF.rs32.rs_table_mult[9].OPb,
            OOF.rs32.rs_table_mult[9].DestTag);
  $fdisplay(wb_fileno, "[07] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[8], OOF.rs32.rs_avail_out_mult[8],
            OOF.rs32.rs_table_mult[8].OPaValid, OOF.rs32.rs_table_mult[8].OPa,
            OOF.rs32.rs_table_mult[8].OPbValid, OOF.rs32.rs_table_mult[8].OPb,
            OOF.rs32.rs_table_mult[8].DestTag);
  $fdisplay(wb_fileno, "[08] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[7], OOF.rs32.rs_avail_out_mult[7],
            OOF.rs32.rs_table_mult[7].OPaValid, OOF.rs32.rs_table_mult[7].OPa,
            OOF.rs32.rs_table_mult[7].OPbValid, OOF.rs32.rs_table_mult[7].OPb,
            OOF.rs32.rs_table_mult[7].DestTag);
  $fdisplay(wb_fileno, "[09] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[6], OOF.rs32.rs_avail_out_mult[6],
            OOF.rs32.rs_table_mult[6].OPaValid, OOF.rs32.rs_table_mult[6].OPa,
            OOF.rs32.rs_table_mult[6].OPbValid, OOF.rs32.rs_table_mult[6].OPb,
            OOF.rs32.rs_table_mult[6].DestTag);
  $fdisplay(wb_fileno, "[10] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[5], OOF.rs32.rs_avail_out_mult[5],
            OOF.rs32.rs_table_mult[5].OPaValid, OOF.rs32.rs_table_mult[5].OPa,
            OOF.rs32.rs_table_mult[5].OPbValid, OOF.rs32.rs_table_mult[5].OPb,
            OOF.rs32.rs_table_mult[5].DestTag);
  $fdisplay(wb_fileno, "[11] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[4], OOF.rs32.rs_avail_out_mult[4],
            OOF.rs32.rs_table_mult[4].OPaValid, OOF.rs32.rs_table_mult[4].OPa,
            OOF.rs32.rs_table_mult[4].OPbValid, OOF.rs32.rs_table_mult[4].OPb,
            OOF.rs32.rs_table_mult[4].DestTag);
  $fdisplay(wb_fileno, "[12] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[3], OOF.rs32.rs_avail_out_mult[3],
            OOF.rs32.rs_table_mult[3].OPaValid, OOF.rs32.rs_table_mult[3].OPa,
            OOF.rs32.rs_table_mult[3].OPbValid, OOF.rs32.rs_table_mult[3].OPb,
            OOF.rs32.rs_table_mult[3].DestTag);
  $fdisplay(wb_fileno, "[13] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[2], OOF.rs32.rs_avail_out_mult[2],
            OOF.rs32.rs_table_mult[2].OPaValid, OOF.rs32.rs_table_mult[2].OPa,
            OOF.rs32.rs_table_mult[2].OPbValid, OOF.rs32.rs_table_mult[2].OPb,
            OOF.rs32.rs_table_mult[2].DestTag);
  $fdisplay(wb_fileno, "[14] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[1], OOF.rs32.rs_avail_out_mult[1],
            OOF.rs32.rs_table_mult[1].OPaValid, OOF.rs32.rs_table_mult[1].OPa,
            OOF.rs32.rs_table_mult[1].OPbValid, OOF.rs32.rs_table_mult[1].OPb,
            OOF.rs32.rs_table_mult[1].DestTag);
  $fdisplay(wb_fileno, "[15] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            OOF.rs32.rs_avail_out_mult[0], OOF.rs32.rs_avail_out_mult[0],
            OOF.rs32.rs_table_mult[0].OPaValid, OOF.rs32.rs_table_mult[0].OPa,
            OOF.rs32.rs_table_mult[0].OPbValid, OOF.rs32.rs_table_mult[0].OPb,
            OOF.rs32.rs_table_mult[0].DestTag);
  $fdisplay(wb_fileno, "=====================================================================================================");
  $fdisplay(wb_fileno, "");
  $fdisplay(wb_fileno, "");
  `endif
end
endtask

task print_rs_FU;
begin
  /*opA1_alu = 64'b0;
  opB1_alu = 64'b0;
  opA2_alu = 64'b0;
  opB2_alu = 64'b0;
  opA1_mult = 64'b0;
  opB1_mult = 64'b0;
  opA2_mult = 64'b0;
  opB2_mult = 64'b0;
  destPRN1_alu = 7'b0;
  destPRN2_alu = 7'b0;
  destPRN1_mult = 7'b0;
  destPRN2_mult = 7'b0;

  if(~rs_instr_valid1_in)
  begin
    opA1_alu = 64'b0;
    opB1_alu = 64'b0;
    opA1_mult = 64'b0;
    opB1_mult = 64'b0;
    destPRN1_alu = 64'b0;
    destPRN1_mult = 64'b0;
  end
  else if(rs_alu_func1_in != `ALU_MULQ)
  begin
    opA1_alu = rs_opa1_in;
    opB1_alu = rs_opb1_in;
    destPRN1_alu = rs_dest_PRN1_in;
  end 
  else
  begin
    opA1_mult = rs_opa1_in;
    opB1_mult = rs_opb1_in;
    destPRN1_mult = rs_dest_PRN1_in;
  end

  if(~rs_instr_valid2_in)
  begin
    opA2_alu = 64'b0;
    opB2_alu = 64'b0;
    opA2_mult = 64'b0;
    opB2_mult = 64'b0;
    destPRN2_alu = 64'b0;
    destPRN2_mult = 64'b0;
  end
  else if(rs_alu_func2_in != `ALU_MULQ)
  begin
    opA2_alu = rs_opa2_in;
    opB2_alu = rs_opb2_in;
    destPRN2_alu = rs_dest_PRN2_in;
  end
  else
  begin
    opA2_mult = rs_opa2_in;
    opB2_mult = rs_opb2_in;
    destPRN2_mult = rs_dest_PRN2_in;
  end
*/
  $fdisplay(wb_filen2, "[cycle : %0d]", clock_count+1);
  $fdisplay(wb_filen2, "=========================================================================================================");
/*
  rob1 = 6'b0;
  if(alu0_valid_out)
    rob1 = ex_ROB1_alu_out;
  if(mult0_done) 
    rob1 = ex_ROB1_mult_out;

  rob2 = 6'b0;
  if(alu1_valid_out)
    rob2 = ex_ROB2_alu_out;
  if(mult1_done) 
    rob2 = ex_ROB2_mult_out;

  if(alu0_valid_out)
  begin
    $fdisplay(wb_filen2, "ALU[1] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
              destPRN1_alu, opA1_alu, opB1_alu, ex_alu1_result_out, ex_ROB1_alu_out);
  end else if(rs_alu_func1_in != `ALU_MULQ)
  begin
    $fdisplay(wb_filen2, "ALU[1] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN1_alu, opA1_alu, opB1_alu);
  end else
  begin
    $fdisplay(wb_filen2, "MUL[1] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN1_alu, opA1_alu, opB1_alu);
  end

  if(mult0_done)
  begin
    $fdisplay(wb_filen2, "MUL[1] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
              destPRN1_mult, opA1_mult, opB1_mult, ex_mult1_result_out, ex_ROB1_mult_out);
  end else if(rs_alu_func1_in != `ALU_MULQ)
  begin
    $fdisplay(wb_filen2, "MUL[1] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN1_mult, opA1_mult, opB1_mult);
  end else
  begin
    $fdisplay(wb_filen2, "MUL[1] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN1_mult, opA1_mult, opB1_mult);
  end


  if(alu1_valid_out)
  begin
    $fdisplay(wb_filen2, "ALU[2] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
              destPRN2_alu, opA2_alu, opB2_alu, ex_alu2_result_out, ex_ROB2_alu_out);
  end else if(rs_alu_func2_in != `ALU_MULQ)
  begin
    $fdisplay(wb_filen2, "ALU[2] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN2_alu, opA2_alu, opB2_alu);
  end else
  begin
    $fdisplay(wb_filen2, "ALU[2] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN2_alu, opA2_alu, opB2_alu);
  end

  if(mult1_done)
  begin
    $fdisplay(wb_filen2, "MUL[2] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
              destPRN2_mult, opA2_mult, opB2_mult, ex_mult2_result_out, ex_ROB2_mult_out);
  end else if(rs_alu_func2_in != `ALU_MULQ)
  begin
    $fdisplay(wb_filen2, "MUL[2] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN2_mult, opA2_mult, opB2_mult);
  end else
  begin
    $fdisplay(wb_filen2, "MUL[2] | PRN:%d | A:%d | B:%d | result: NOT rdy", 
              destPRN2_mult, opA2_mult, opB2_mult);
  end*/
  $fdisplay(wb_filen2, "ALU[1] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
            rs_dest_PRN1_in, rs_opa1_in, rs_opb1_in, ex_alu1_result_out, ex_ROB1_alu_out);
  $fdisplay(wb_filen2, "MUL[1] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
            rs_dest_PRN1_in, rs_opa1_in, rs_opb1_in, ex_mult1_result_out, ex_ROB1_mult_out);
  $fdisplay(wb_filen2, "ALU[2] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
            rs_dest_PRN2_in, rs_opa2_in, rs_opb2_in, ex_alu2_result_out, ex_ROB2_alu_out);
  $fdisplay(wb_filen2, "MUL[2] | PRN:%d | A:%d | B:%d | result:%d | ROB#:%d", 
            rs_dest_PRN2_in, rs_opa2_in, rs_opb2_in, ex_mult2_result_out, ex_ROB2_mult_out);


  $fdisplay(wb_filen2, "=========================================================================================================");
  if(cdb1_valid_out) 
    $fdisplay(wb_filen2, "CDB[1] | result:%d | PRN:%d | valid:%b",
              cdb1_result_out, cdb1_PRN_out, cdb1_valid_out);
  else
    $fdisplay(wb_filen2, "CDB[1] | NOT IN USE");

  if(cdb2_valid_out)
    $fdisplay(wb_filen2, "CDB[2] | result:%d | PRN:%d | valid:%b",
              cdb2_result_out, cdb2_PRN_out, cdb2_valid_out);
  else
    $fdisplay(wb_filen2, "CDB[2] | NOT IN USE");

  $fdisplay(wb_filen2, "=========================================================================================================\n");

end
endtask

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

  wb_fileno = $fopen("rs.out");
  wb_filen1 = $fopen("writeback.out");
  wb_filen2 = $fopen("rs_ex.out");

  //Open header AFTER throwing the reset otherwise the reset state is displayed
  $fdisplay(wb_fileno, "====================================================================================================");
  $fdisplay(wb_fileno, "|                                Reservation Station Data flow Result                              |");
  $fdisplay(wb_fileno, "====================================================================================================\n");
  $monitor("ALU1out:%d, ALU1 avail:%b\nALU2out:%d, ALU2 avail:%b\nMUL1out:%d, MUL1 avail:%d\nMUL2out:%d, MUL2 avail:%b\n[CDB 1] result:%d, PRN:%d, valid:%b\n[CDB 2] result:%d, PRN:%d, valid:%b\n==============[ROB entry ]==============\n[ROB-RRAT] PRN1:%d, ARN1:%d PRN1old:%d\n[ROB-IF] TargetAddr:%d\nBr mispredicted:%d, ROB1 valid:%d\n==============[ROB entry]==============\n[ROB-RRAT] PRN2:%d, ARN2:%d PRN2old:%d\n[ROB-IF] TargetAddr:%d\nBr mispredicted:%d, ROB2 valid:%d\n=========================================\n"/*RS_alu_ROBnum1:%d, RS_alu_ROBnum2:%d\nFU_alu_ROBnum1:%d, FU_alu_ROBnum2:%d\nRS_mul_ROBnum1:%d, RS_mul_ROBnum2:%d\nFU_mul_ROBnum1:%d, FU_mul_ROBnum2:%d\n\n"*/,
  ex_alu1_result_out,  alu0_valid_out,
  ex_alu2_result_out,  alu1_valid_out,
  ex_mult1_result_out, mult0_done,
  ex_mult2_result_out, mult1_done,

  cdb1_result_out, cdb1_PRN_out, cdb1_valid_out,
  cdb2_result_out, cdb2_PRN_out, cdb2_valid_out,

  ooc_ROB_to_RRAT_PRN1_out, ooc_ROB_to_RRAT_ARN1_out, ooc_ROB_to_PRF_PRN_old1_out,
  ooc_ROB_to_fetch_target_addr1_out, ooc_ROB_mis_predict1_out, ooc_ROB_valid1_out,
  ooc_ROB_to_RRAT_PRN2_out, ooc_ROB_to_RRAT_ARN2_out, ooc_ROB_to_PRF_PRN_old2_out,
  ooc_ROB_to_fetch_target_addr2_out, ooc_ROB_mis_predict2_out, ooc_ROB_valid2_out);

  /*`ifdef SIM
  $monitor("A:%d, B:%d, ALU1out:%d, ALU1 avail:%b, destPRN1:%d\nA:%d, B:%d, ALU2out:%d, ALU2 avail:%b, destPRN2:%d\nA:%d, B:%d, MUL1out:%d, MUL1 avail:%d, destPRN1:%d\nA:%d, B:%d, MUL2out:%d, MUL2 avail:%b, destPRN2:%d\n[CDB 1] result:%d, PRN:%d, valid:%b, ROB#:%d\n[CDB 2] result:%d, PRN:%d, valid:%b, ROB#:%d\n==============[ROB entry %d]==============\n[ROB-RRAT] PRN1:%d, ARN1:%d PRN1old:%d\n[ROB-IF] TargetAddr:%d\nBr mispredicted:%d, ROB1 valid:%d\n==============[ROB entry %d]==============\n[ROB-RRAT] PRN2:%d, ARN2:%d PRN2old:%d\n[ROB-IF] TargetAddr:%d\nBr mispredicted:%d, ROB2 valid:%d\n=========================================\n"RS_alu_ROBnum1:%d, RS_alu_ROBnum2:%d\nFU_alu_ROBnum1:%d, FU_alu_ROBnum2:%d\nRS_mul_ROBnum1:%d, RS_mul_ROBnum2:%d\nFU_mul_ROBnum1:%d, FU_mul_ROBnum2:%d\n\n",
  OOF.rs32.rs_opa1_alu_out, OOF.rs32.rs_opb1_alu_out, ex_alu1_result_out, alu0_valid_out,
  OOF.rs32.rs_dest_PRN1_alu_out,

  OOF.rs32.rs_opa2_alu_out, OOF.rs32.rs_opb2_alu_out, ex_alu2_result_out, alu1_valid_out,
  OOF.rs32.rs_dest_PRN2_alu_out,

  OOF.rs32.rs_opa1_mult_out, OOF.rs32.rs_opb1_mult_out, ex_mult1_result_out, mult0_done,
  OOF.rs32.rs_dest_PRN1_mult_out,

  OOF.rs32.rs_opa2_mult_out, OOF.rs32.rs_opb2_mult_out, ex_mult2_result_out, mult1_done,
  OOF.rs32.rs_dest_PRN2_mult_out,

  cdb1_result_out, cdb1_PRN_out, cdb1_valid_out, OOF.cdb1_ROB_out,
  cdb2_result_out, cdb2_PRN_out, cdb2_valid_out, OOF.cdb2_ROB_out,

  OOF.ROB_num1_to_RS_out,
  ooc_ROB_to_RRAT_PRN1_out, ooc_ROB_to_RRAT_ARN1_out, ooc_ROB_to_PRF_PRN_old1_out,
  ooc_ROB_to_fetch_target_addr1_out, ooc_ROB_mis_predict1_out, ooc_ROB_valid1_out,
  OOF.ROB_num2_to_RS_out,
  ooc_ROB_to_RRAT_PRN2_out, ooc_ROB_to_RRAT_ARN2_out, ooc_ROB_to_PRF_PRN_old2_out,
  ooc_ROB_to_fetch_target_addr2_out, ooc_ROB_mis_predict2_out, ooc_ROB_valid2_out);
  `endif*/

  rs_rd_mem1_in = 0;
  rs_rd_mem2_in = 0;
  rs_wr_mem1_in = 0;
  rs_wr_mem2_in = 0;

  rs_instr_valid1_in = 0;
  rs_instr_valid2_in = 0;

  rs_opa_select1_in = 0;
  rs_opb_select1_in = 0;
  rs_opa_select2_in = 0;
  rs_opb_select2_in = 0;
  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;
  
  is_ooc_branch_pred1_in = 0;
  is_ooc_branch_pred2_in = 0;
  
  rs_complete_inst = 0;

  print_RS;
  print_rs_FU;

  @(negedge clock);

  print_result;
  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 808088,  instr2 : opa = 777
  // instr1 : opb = 333992,  instr2 : opb = NOT VALID (PRN: 9)
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 10;
  is_ooc_dest_PRN1_old_in = 9;
  is_ooc_dest_ARN1_in = 7;
  rs_PRNa1_in = 6;  
  rs_opa1_in = 80;
  rs_opa1_valid = 1;   
  rs_opb1_in = 3;
  rs_PRNb1_in = 7;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_ADDQ;
  rs_instr_valid1_in = 1;
  //rs_opa_select1_in = `ALU_OPB_IS_ALU_IMM;
  rs_opa_select1_in = `ALU_OPA_IS_REGA;
  rs_opb_select1_in = `ALU_OPB_IS_REGB;


  rs_dest_PRN2_in = 13;
  is_ooc_dest_PRN2_old_in = 19;
  is_ooc_dest_ARN2_in = 8;
  rs_opa2_in = 666; 
  rs_PRNa2_in = 10;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 600;
  rs_PRNb2_in = 9;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_ADDQ;
  rs_instr_valid2_in = 1;
  rs_opa_select2_in = `ALU_OPA_IS_REGA;
  rs_opb_select2_in = `ALU_OPB_IS_REGB;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_rs_FU;

  @(negedge clock);

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 808088,  instr2 : opa = 777
  // instr1 : opb = 333992,  instr2 : opb = NOT VALID (PRN: 9)
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 85;
  is_ooc_dest_PRN1_old_in = 21;
  is_ooc_dest_ARN1_in = 9;
  rs_PRNa1_in = 10;  
  rs_opa1_in = 150;
  rs_opa1_valid = 1;   
  rs_opb1_in = 350;
  rs_PRNb1_in = 17;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_ADDQ;
  rs_instr_valid1_in = 1;
  rs_opa_select1_in = `ALU_OPA_IS_REGA;
  rs_opb_select1_in = `ALU_OPB_IS_REGB;

  rs_dest_PRN2_in = 87;
  is_ooc_dest_PRN2_old_in = 24;
  is_ooc_dest_ARN2_in = 11;
  rs_opa2_in = 777; 
  rs_PRNa2_in = 10;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 700;
  rs_PRNb2_in = 70;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_SUBQ;
  rs_instr_valid2_in = 1;
  rs_opa_select2_in = `ALU_OPA_IS_REGA;
  rs_opb_select2_in = `ALU_OPB_IS_REGB;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_result;
  print_rs_FU;

  @(negedge clock);

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 7(111 b),  opb = 5(101 b)
  // instr2 : opa = 3777,  opb = 2700
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 40;
  is_ooc_dest_PRN1_old_in = 25;
  is_ooc_dest_ARN1_in = 13;
  rs_PRNa1_in = 24; 
  rs_opa1_in = 7;
  rs_opa1_valid = 1;
  rs_opb1_in = 5;
  rs_PRNb1_in = 37;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_AND;
  rs_instr_valid1_in = 1;
  rs_opa_select1_in = `ALU_OPA_IS_REGA;
  rs_opb_select1_in = `ALU_OPB_IS_REGB;

  rs_dest_PRN2_in = 41;
  is_ooc_dest_PRN2_old_in = 26;
  is_ooc_dest_ARN2_in = 14;
  rs_opa2_in = 3777; 
  rs_PRNa2_in = 32;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 2700;
  rs_PRNb2_in = 30;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_SUBQ;
  rs_instr_valid2_in = 1;
  rs_opa_select2_in = `ALU_OPA_IS_REGA;
  rs_opb_select2_in = `ALU_OPB_IS_REGB;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_result;
  print_rs_FU;

  @(negedge clock);
  // ======================================= M U L T ================================
  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 808088,  instr2 : opa = 777
  // instr1 : opb = 333992,  instr2 : opb = NOT VALID (PRN: 9)
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 81;
  is_ooc_dest_PRN1_old_in = 33;
  is_ooc_dest_ARN1_in = 15;
  rs_PRNa1_in = 6;  
  rs_opa1_in = 80;
  rs_opa1_valid = 1;   
  rs_opb1_in = 3;
  rs_PRNb1_in = 7;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_MULQ;
  rs_instr_valid1_in = 1;

  rs_dest_PRN2_in = 82;
  is_ooc_dest_PRN2_old_in = 34;
  is_ooc_dest_ARN2_in = 16;
  rs_opa2_in = 666; 
  rs_PRNa2_in = 10;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 600;
  rs_PRNb2_in = 9;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_MULQ;
  rs_instr_valid2_in = 1;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_result;
  print_RS;
  print_rs_FU;

  @(negedge clock);

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 808088,  instr2 : opa = 777
  // instr1 : opb = 333992,  instr2 : opb = NOT VALID (PRN: 9)
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 70;
  is_ooc_dest_PRN1_old_in = 35;
  is_ooc_dest_ARN1_in = 17;
  rs_PRNa1_in = 10;  
  rs_opa1_in = 150;
  rs_opa1_valid = 1;   
  rs_opb1_in = 350;
  rs_PRNb1_in = 17;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_MULQ;
  rs_instr_valid1_in = 1;

  rs_dest_PRN2_in = 71;
  is_ooc_dest_PRN2_old_in = 36;
  is_ooc_dest_ARN2_in = 18;
  rs_opa2_in = 777; 
  rs_PRNa2_in = 10;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 700;
  rs_PRNb2_in = 70;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_MULQ;
  rs_instr_valid2_in = 1;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_result;
  print_rs_FU;

  @(negedge clock);

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 808088,  instr2 : opa = 777
  // instr1 : opb = 333992,  instr2 : opb = NOT VALID (PRN: 9)
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 77;
  is_ooc_dest_PRN1_old_in = 37;
  is_ooc_dest_ARN1_in = 19;
  rs_PRNa1_in = 24; 
  rs_opa1_in = 250;
  rs_opa1_valid = 1;
  rs_opb1_in = 450;
  rs_PRNb1_in = 37;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_MULQ;
  rs_instr_valid1_in = 1;

  rs_dest_PRN2_in = 73;
  is_ooc_dest_PRN2_old_in = 38;
  is_ooc_dest_ARN2_in = 20;
  rs_opa2_in = 2777; 
  rs_PRNa2_in = 32;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 2700;
  rs_PRNb2_in = 30;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_MULQ;
  rs_instr_valid2_in = 1;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_result;
  print_rs_FU;

  @(negedge clock);


  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 7(111 b),  opb = 5(101 b)
  // instr2 : opa = 3777,  opb = 2700
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 30;
  is_ooc_dest_PRN1_old_in = 39;
  is_ooc_dest_ARN1_in = 22;
  rs_PRNa1_in = 27; 
  rs_opa1_in = 6;
  rs_opa1_valid = 1;
  rs_opb1_in = 2;
  rs_PRNb1_in = 38;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_AND;
  rs_instr_valid1_in = 1;
  rs_opa_select1_in = `ALU_OPA_IS_REGA;
  rs_opb_select1_in = `ALU_OPB_IS_REGB;

  rs_dest_PRN2_in = 23;
  is_ooc_dest_PRN2_old_in = 42;
  is_ooc_dest_ARN2_in = 21;
  rs_opa2_in = 8000; 
  rs_PRNa2_in = 42;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 2700;
  rs_PRNb2_in = 46;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_SUBQ;
  rs_instr_valid2_in = 1;
  rs_opa_select2_in = `ALU_OPA_IS_REGA;
  rs_opb_select2_in = `ALU_OPB_IS_REGB;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_result;
  print_rs_FU;

  @(negedge clock);


  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 7(111 b),  opb = 5(101 b)
  // instr2 : opa = 3777,  opb = 2700
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 92;
  is_ooc_dest_PRN1_old_in = 43;
  is_ooc_dest_ARN1_in = 23;
  rs_PRNa1_in = 61; 
  rs_opa1_in = 500;
  rs_opa1_valid = 1;
  rs_opb1_in = 700;
  rs_PRNb1_in = 65;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_ADDQ;
  rs_instr_valid1_in = 1;
  rs_opa_select1_in = `ALU_OPA_IS_REGA;
  rs_opb_select1_in = `ALU_OPB_IS_REGB;

  rs_dest_PRN2_in = 93;
  is_ooc_dest_PRN2_old_in = 44;
  is_ooc_dest_ARN2_in = 24;
  rs_opa2_in = 8777; 
  rs_PRNa2_in = 39;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 2777;
  rs_PRNb2_in = 80;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_SUBQ;
  rs_instr_valid2_in = 1;
  rs_opa_select2_in = `ALU_OPA_IS_REGA;
  rs_opb_select2_in = `ALU_OPB_IS_REGB;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_result;
  print_rs_FU;

  @(negedge clock);

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 7(111 b),  opb = 5(101 b)
  // instr2 : opa = 3777,  opb = 2700
  /////////////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 94;
  is_ooc_dest_PRN1_old_in = 45;
  is_ooc_dest_ARN1_in = 25;
  rs_PRNa1_in = 62; 
  rs_opa1_in = 950;
  rs_opa1_valid = 1;
  rs_opb1_in = 750;
  rs_PRNb1_in = 63;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_SUBQ;
  rs_instr_valid1_in = 1;
  rs_opa_select1_in = `ALU_OPA_IS_REGA;
  rs_opb_select1_in = `ALU_OPB_IS_REGB;

  rs_dest_PRN2_in = 95;
  is_ooc_dest_PRN2_old_in = 46;
  is_ooc_dest_ARN2_in = 26;
  rs_opa2_in = 8000; 
  rs_PRNa2_in = 57;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 2500;
  rs_PRNb2_in = 58;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_ADDQ;
  rs_instr_valid2_in = 1;
  rs_opa_select2_in = `ALU_OPA_IS_REGA;
  rs_opb_select2_in = `ALU_OPB_IS_REGB;

  rs_cond_branch1_in = 0;
  rs_cond_branch2_in = 0;
  rs_uncond_branch1_in = 0;
  rs_uncond_branch2_in = 0;

  print_RS;
  print_result;
  print_rs_FU;

  @(negedge clock);

  print_RS;
  print_result;
  print_rs_FU;
  rs_complete_inst = 2;

  rs_instr_valid1_in = 0;
  rs_instr_valid2_in = 0;

  @(negedge clock);

  print_RS;
  print_result;
  print_rs_FU;
  rs_complete_inst = 2;

  @(negedge clock);

  print_RS;
  print_result;
  print_rs_FU;
  rs_complete_inst = 2;

  @(negedge clock);

  print_RS;
  print_result;
  print_rs_FU;
  rs_complete_inst = 2;

  @(negedge clock);

  print_RS;
  print_result;
  print_rs_FU;
  rs_complete_inst = 2;

  @(negedge clock);

  print_RS;
  print_result;
  print_rs_FU;
  rs_complete_inst = 2;

  @(negedge clock);

  print_RS;
  print_result;
  print_rs_FU;
  rs_complete_inst = 2;



/*
  correct = 1;
  if(!correct) 
  begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  rs_cdb2_tag = 9; 
  rs_cdb2_valid = 1;
  rs_cdb2_in = 2222222;

  ///////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 4300,     instr2 : opa = 3877
  // instr1 : opb = 1000000,  instr2 : opb = 14500
  ///////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 70;
  rs_opa1_in = 4300; 
  rs_PRNa1_in = 46;  
  rs_opa1_valid = 1;   
  rs_opb1_in = 1000000;
  rs_PRNb1_in = 47;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_ADDQ;
  rs_ROB1_in = 3;
  rs_instr_valid1_in = 1;

  rs_dest_PRN2_in = 50;
  rs_opa2_in = 3877; 
  rs_PRNa2_in = 30;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 14500;
  rs_PRNb2_in = 39;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_MULQ;
  rs_ROB2_in = 4;
  rs_instr_valid2_in = 1;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 3;
  correct = 1;//(ex_alu0_result_out === 1004300);

  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  ///////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 900,        instr2 : opa = 90070
  // instr1 : opb = NOT VALID,  instr2 : opb = 999000
  ///////////////////////////////////////////////////////////////////////////
  rs_dest_PRN1_in = 20;
  rs_opa1_in = 900; 
  rs_PRNa1_in = 26;  
  rs_opa1_valid = 1;   
  //opb1_in = 120;
  rs_PRNb1_in = 44;
  rs_opb1_valid = 0;
  rs_alu_func1_in = `ALU_MULQ;
  rs_ROB1_in = 8;
  rs_instr_valid1_in = 1;

  rs_dest_PRN2_in = 13;
  rs_opa2_in = 90070; 
  rs_PRNa2_in = 25;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 999000;
  rs_PRNb2_in = 14;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_MULQ;
  rs_ROB2_in = 9;
  rs_instr_valid2_in = 1;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = 1;//((rs_opa1_mult_out === 90070) && (rs_opb1_mult_out === 999000));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  rs_cdb1_tag = 44; 
  rs_cdb1_valid = 1;
  rs_cdb1_in = 440770;

  rs_instr_valid1_in = 0;
  rs_instr_valid2_in = 0;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = 1;//((rs_opa1_mult_out === 900) && (rs_opb1_mult_out === 440770));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");  print_result;
  print_result;

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 900,        instr2 : opa = 90070
  // instr1 : opb = NOT VALID,  instr2 : opb = 999000
  /////////////////////////////////////////////////////////////////////////////////

  rs_instr_valid1_in = 1;
  rs_instr_valid2_in = 1;

  rs_dest_PRN1_in = 30;
  rs_opa1_in = 4040; 
  rs_PRNa1_in = 26;  
  rs_opa1_valid = 1;   
  rs_PRNb1_in = 4400;
  rs_opb1_valid = 0;
  rs_alu_func1_in = `ALU_MULQ;
  rs_ROB1_in = 20;

  rs_dest_PRN2_in = 23;
  rs_opa2_in = 44440; 
  rs_PRNa2_in = 25;  
  rs_opa2_valid = 1;   
  rs_opb2_in = 44545;
  rs_PRNb2_in = 16;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_MULQ;
  rs_ROB2_in = 21;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;

  correct = 1;//((rs_opa1_mult_out === 44440) && (rs_opb1_mult_out === 44545));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  rs_dest_PRN1_in = 30;
  rs_opa1_in = 5050; 
  rs_PRNa1_in = 26;  
  rs_opa1_valid = 1;   
  rs_opb1_in = 5550;
  rs_PRNb1_in = 55;
  rs_opb1_valid = 1;
  rs_alu_func1_in = `ALU_MULQ;
  rs_ROB1_in = 26;

  rs_dest_PRN2_in = 23;
  rs_opa2_in = 55550; 
  rs_PRNa2_in = 25;  
  rs_opa2_valid = 1;
  rs_opb2_in = 577557;
  rs_PRNb2_in = 16;
  rs_opb2_valid = 1;
  rs_alu_func2_in = `ALU_SUBQ;
  rs_ROB2_in = 27;
*/
  show_clk_count;
  $fclose(wb_fileno);
  $fclose(wb_filen1);
  $fclose(wb_filen2);

  $display("@@@ Passed All Test");
  $finish;
end

always @(posedge clock or posedge reset)
begin
  if(reset)
  begin
    clock_count <= `SD 0;
    instr_count <= `SD 0;
  end
  else
  begin
    clock_count <= `SD (clock_count + 1);
    instr_count <= `SD (instr_count + rs_complete_inst);
  end
end  

endmodule  // module testbench

