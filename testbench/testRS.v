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
                     int ROB2_num, int load1in, int load2in, int PRNa1, int PRNa2,
                     int PRNb1, int PRNb2);
extern void print_close();

module testbench;

// Registers and wires ufile:///usr/share/doc/HTML/en-US/index.htmlsed in the testbench
reg  [31:0]  clock_count;
reg  [31:0]  instr_count;
integer      wb_fileno;
integer      wb_filen1;
integer      wb_filen2;
reg          correct;

reg          clock;
reg          reset;

reg   [3:0]  rs_complete_inst;

reg          mult_free1_in;
reg          mult_free2_in;
reg          alu_free1_in;
reg          alu_free2_in;

reg   [6:0]  dest_PRN1_in;             // The destination of this instruction 
reg  [63:0]  opa1_in;                  // Operand a from Rename  
reg   [6:0]  PRNa1_in;                 // Physical Register Number for opA
reg          opa1_valid;               // Is Opa a Tag or immediate data
reg  [63:0]  opb1_in;                  // Operand a from Rename 
reg   [6:0]  PRNb1_in;                 // Physical Register Number for opB
reg          opb1_valid;               // Is Opb a tag or immediate data
reg  [63:0]  cdb1_in;                  // CDB bus from functional units 
reg   [6:0]  cdb1_tag;                 // CDB tag bus from functional units 
reg          cdb1_valid;               // The data on the CDB is valid 
reg          cond_branch1_in;
reg          uncond_branch1_in;
reg  [63:0]  issue1_NPC_in;            // Next PC from issue stage
reg  [31:0]  issue1_IR_in;             // instruction from issue stage
reg   [4:0]  alu_func1_in;             // alu opcode from issue stage
reg   [5:0]  ROB1_in;                  // ROB entry number
reg   [1:0]  opa_select1_in;
reg   [1:0]  opb_select1_in;
reg          rd_mem1_in;
reg          wr_mem1_in;
reg          instr_valid1_in;

reg   [6:0]  dest_PRN2_in;             // The destination of this instruction 
reg  [63:0]  opa2_in;                  // Operand a from Rename  
reg   [6:0]  PRNa2_in;                 // Physical Register Number for opA
reg          opa2_valid;               // Is Opa a Tag or immediate data
reg  [63:0]  opb2_in;                  // Operand a from Rename 
reg   [6:0]  PRNb2_in;                 // Physical Register Number for opB
reg          opb2_valid;               // Is Opb a tag or immediate data
reg  [63:0]  cdb2_in;                  // CDB bus from functional units 
reg   [6:0]  cdb2_tag;                 // CDB tag bus from functional units 
reg          cdb2_valid;               // The data on the CDB is valid 
reg          cond_branch2_in;
reg          uncond_branch2_in;
reg  [63:0]  issue2_NPC_in;            // Next PC from issue stage
reg  [31:0]  issue2_IR_in;             // instruction from issue stage
reg   [4:0]  alu_func2_in;             // alu opcode from issue stage
reg   [5:0]  ROB2_in;                  // ROB entry number
reg   [1:0]  opa_select2_in;
reg   [1:0]  opb_select2_in;
reg          rd_mem2_in;
reg          wr_mem2_in;
reg          instr_valid2_in;


wire [63:0]  opa1_alu_out;             // This RS' opa 
wire [63:0]  opb1_alu_out;             // This RS' opb 
wire  [6:0]  dest_PRN1_alu_out;        // This RS' destination tag  
wire         cond_branch1_alu_out;
wire         uncond_branch1_alu_out;
wire [63:0]  NPC1_alu_out;             // PC+4 to EX for target address
wire [31:0]  IR1_alu_out;
wire  [4:0]  alu_func1_alu_out;
wire  [5:0]  ROB1_alu_out;             // ROB number passed into the FU
wire  [1:0]  opa_select1_alu_out;
wire  [1:0]  opb_select1_alu_out;
wire         instr_valid1_alu_out;

wire [63:0]  opa2_alu_out;             // This RS' opa 
wire [63:0]  opb2_alu_out;             // This RS' opb 
wire  [6:0]  dest_PRN2_alu_out;        // This RS' destination tag  
wire         cond_branch2_alu_out;
wire         uncond_branch2_alu_out; 
wire [63:0]  NPC2_alu_out;             // PC+4 to EX for target address
wire [31:0]  IR2_alu_out;
wire  [4:0]  alu_func2_alu_out;
wire  [5:0]  ROB2_alu_out;             // ROB number passed into the FU
wire  [1:0]  opa_select2_alu_out;
wire  [1:0]  opb_select2_alu_out;
wire         instr_valid2_alu_out;

wire [63:0]  opa1_mult_out;            // This RS' opa 
wire [63:0]  opb1_mult_out;            // This RS' opb 
wire  [6:0]  dest_PRN1_mult_out;       // This RS' destination tag  
wire         cond_branch1_mult_out;
wire         uncond_branch1_mult_out;
wire [63:0]  NPC1_mult_out;            // PC+4 to EX for target address
wire [31:0]  IR1_mult_out;
wire  [4:0]  alu_func1_mult_out;
wire  [5:0]  ROB1_mult_out;            // ROB number passed into the FU
wire         instr_valid1_mult_out;

wire [63:0]  opa2_mult_out;            // This RS' opa 
wire [63:0]  opb2_mult_out;            // This RS' opb 
wire  [6:0]  dest_PRN2_mult_out;       // This RS' destination tag  
wire         cond_branch2_mult_out;
wire         uncond_branch2_mult_out;
wire [63:0]  NPC2_mult_out;            // PC+4 to EX for target address
wire [31:0]  IR2_mult_out;
wire  [4:0]  alu_func2_mult_out;
wire  [5:0]  ROB2_mult_out;            // ROB number passed into the FU
wire         instr_valid2_mult_out;

wire         stall_out;

rs rs32(// inputs:
          .reset(reset),
          .clock(clock),

          .rs_mult_free1_in(mult_free1_in),
          .rs_mult_free2_in(mult_free2_in),
          .rs_alu_free1_in(alu_free1_in),
          .rs_alu_free2_in(alu_free2_in),

          // instruction 1 from the issue stage
          .rs_dest_PRN1_in(dest_PRN1_in),
          .rs_opa1_in(opa1_in),
          .rs_PRNa1_in(PRNa1_in),
          .rs_opa1_valid(opa1_valid),
          .rs_opb1_in(opb1_in),
          .rs_PRNb1_in(PRNb1_in),
          .rs_opb1_valid(opb1_valid), 
          .rs_cdb1_in(cdb1_in),
          .rs_cdb1_tag(cdb1_tag),
          .rs_cdb1_valid(cdb1_valid),
          .rs_cond_branch1_in(cond_branch1_in),
          .rs_uncond_branch1_in(uncond_branch1_in),
          .rs_issue_NPC1_in(issue1_NPC_in),
          .rs_issue_IR1_in(issue1_IR_in),
          .rs_alu_func1_in(alu_func1_in),
          .rs_ROB1_in(ROB1_in),
          .rs_opa_select1_in(opa_select1_in),
          .rs_opb_select1_in(opb_select1_in),
          .rs_rd_mem1_in(rd_mem1_in),
          .rs_wr_mem1_in(wr_mem1_in),
          .rs_instr_valid1_in(instr_valid1_in),

          // instruction 2 from the issue stage
          .rs_dest_PRN2_in(dest_PRN2_in),
          .rs_opa2_in(opa2_in),
          .rs_PRNa2_in(PRNa2_in),
          .rs_opa2_valid(opa2_valid),
          .rs_opb2_in(opb2_in),
          .rs_PRNb2_in(PRNb2_in),
          .rs_opb2_valid(opb2_valid), 
          .rs_cdb2_in(cdb2_in),
          .rs_cdb2_tag(cdb2_tag),
          .rs_cdb2_valid(cdb2_valid),
          .rs_cond_branch2_in(cond_branch2_in),
          .rs_uncond_branch2_in(uncond_branch2_in),
          .rs_issue_NPC2_in(issue2_NPC_in),
          .rs_issue_IR2_in(issue2_IR_in),
          .rs_alu_func2_in(alu_func2_in),
          .rs_ROB2_in(ROB2_in),
          .rs_opa_select2_in(opa_select2_in),
          .rs_opb_select2_in(opb_select2_in),
          .rs_rd_mem2_in(rd_mem2_in),
          .rs_wr_mem2_in(wr_mem2_in),
          .rs_instr_valid2_in(instr_valid2_in),

          // outputs:
          .rs_stall_out(stall_out),

          // instruction 1 to alu
          .rs_opa1_alu_out(opa1_alu_out),
          .rs_opb1_alu_out(opb1_alu_out),
          .rs_dest_PRN1_alu_out(dest_PRN1_alu_out),
          .rs_cond_branch1_alu_out(cond_branch1_alu_out),
          .rs_uncond_branch1_alu_out(uncond_branch1_alu_out),
          .rs_NPC1_alu_out(NPC1_alu_out), 
          .rs_IR1_alu_out(IR1_alu_out),
          .rs_alu_func1_alu_out(alu_func1_alu_out),
          .rs_ROB1_alu_out(ROB1_alu_out),
          .rs_opa_select1_alu_out(opa_select1_alu_out),
          .rs_opb_select1_alu_out(opb_select1_alu_out),
          .rs_instr_valid1_alu_out(instr_valid1_alu_out),

          // instruction 2 to alu
          .rs_opa2_alu_out(opa2_alu_out),
          .rs_opb2_alu_out(opb2_alu_out),
          .rs_dest_PRN2_alu_out(dest_PRN2_alu_out),
          .rs_cond_branch2_alu_out(cond_branch2_alu_out),
          .rs_uncond_branch2_alu_out(uncond_branch2_alu_out),
          .rs_NPC2_alu_out(NPC2_alu_out), 
          .rs_IR2_alu_out(IR2_alu_out),
          .rs_alu_func2_alu_out(alu_func2_alu_out),
          .rs_ROB2_alu_out(ROB2_alu_out),
          .rs_opa_select2_alu_out(opa_select2_alu_out),
          .rs_opb_select2_alu_out(opb_select2_alu_out),
          .rs_instr_valid2_alu_out(instr_valid2_alu_out),

          // instruction 1 to mult
          .rs_opa1_mult_out(opa1_mult_out),
          .rs_opb1_mult_out(opb1_mult_out),
          .rs_dest_PRN1_mult_out(dest_PRN1_mult_out),
          .rs_cond_branch1_mult_out(cond_branch1_mult_out),
          .rs_uncond_branch1_mult_out(uncond_branch1_mult_out),
          .rs_NPC1_mult_out(NPC1_mult_out), 
          .rs_IR1_mult_out(IR1_mult_out),
          .rs_alu_func1_mult_out(alu_func1_mult_out),
          .rs_ROB1_mult_out(ROB1_mult_out),
          .rs_instr_valid1_mult_out(instr_valid1_mult_out),

          // instruction 2 to mult
          .rs_opa2_mult_out(opa2_mult_out),
          .rs_opb2_mult_out(opb2_mult_out),
          .rs_dest_PRN2_mult_out(dest_PRN2_mult_out),
          .rs_cond_branch2_mult_out(cond_branch2_mult_out),
          .rs_uncond_branch2_mult_out(uncond_branch2_mult_out),
          .rs_NPC2_mult_out(NPC2_mult_out),
          .rs_IR2_mult_out(IR2_mult_out),
          .rs_alu_func2_mult_out(alu_func2_mult_out),
          .rs_ROB2_mult_out(ROB2_mult_out),
          .rs_instr_valid2_mult_out(instr_valid2_mult_out));

always
begin
  #(`VERILOG_CLOCK_PERIOD/2.0);
  clock = ~clock;
end

task print_result;
begin
  $fdisplay(wb_filen1, "[cycle : %0d]", clock_count+1);
  if(alu_free1_in)
    $fdisplay(wb_filen1, "[ALU1] Aout:%d, Bout:%d", opa1_alu_out, opb1_alu_out);
  else if(rd_mem1_in | rd_mem2_in | wr_mem1_in | wr_mem2_in)
    $fdisplay(wb_filen1, "Should Go To LSQ");
  else
    $fdisplay(wb_filen1, "[ALU1] ----------------");

  if(alu_free2_in)
    $fdisplay(wb_filen1, "[ALU2] Aout:%d, Bout:%d", opa2_alu_out, opb2_alu_out);
  else if(rd_mem1_in | rd_mem2_in | wr_mem1_in | wr_mem2_in)
    $fdisplay(wb_filen1, "Should Go To LSQ");
  else
    $fdisplay(wb_filen1, "[ALU1] ----------------");

  if(mult_free1_in)
    $fdisplay(wb_filen1, "[MUL1] Aout:%d, Bout:%d", opa1_mult_out, opb1_mult_out);
  else if(rd_mem1_in | rd_mem2_in | wr_mem1_in | wr_mem2_in)
    $fdisplay(wb_filen1, "Should Go To LSQ");
  else
    $fdisplay(wb_filen1, "[ALU1] ----------------");

  if(mult_free2_in)
    $fdisplay(wb_filen1, "[MUL2] Aout:%d, Bout:%d", opa2_mult_out, opb2_mult_out);
  else if(rd_mem1_in | rd_mem2_in | wr_mem1_in | wr_mem2_in)
    $fdisplay(wb_filen1, "Should Go To LSQ");
  else
    $fdisplay(wb_filen1, "[ALU1] ----------------");
  $fdisplay(wb_filen1,   "===========================================================");
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
            rs32.rs_avail_out_alu[15], rs32.rs_avail_out_alu[15],
            rs32.rs_table_alu[15].OPaValid, rs32.rs_table_alu[15].OPa,
            rs32.rs_table_alu[15].OPbValid, rs32.rs_table_alu[15].OPb,
            rs32.rs_table_alu[15].DestTag);
  $fdisplay(wb_fileno, "[01] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[14], rs32.rs_avail_out_alu[14],
            rs32.rs_table_alu[14].OPaValid, rs32.rs_table_alu[14].OPa,
            rs32.rs_table_alu[14].OPbValid, rs32.rs_table_alu[14].OPb,
            rs32.rs_table_alu[14].DestTag);
  $fdisplay(wb_fileno, "[02] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[13], rs32.rs_avail_out_alu[13],
            rs32.rs_table_alu[13].OPaValid, rs32.rs_table_alu[13].OPa,
            rs32.rs_table_alu[13].OPbValid, rs32.rs_table_alu[13].OPb,
            rs32.rs_table_alu[13].DestTag);
  $fdisplay(wb_fileno, "[03] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[12], rs32.rs_avail_out_alu[12],
            rs32.rs_table_alu[12].OPaValid, rs32.rs_table_alu[12].OPa,
            rs32.rs_table_alu[12].OPbValid, rs32.rs_table_alu[12].OPb,
            rs32.rs_table_alu[12].DestTag);
  $fdisplay(wb_fileno, "[04] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[11], rs32.rs_avail_out_alu[11],
            rs32.rs_table_alu[11].OPaValid, rs32.rs_table_alu[11].OPa,
            rs32.rs_table_alu[11].OPbValid, rs32.rs_table_alu[11].OPb,
            rs32.rs_table_alu[11].DestTag);
  $fdisplay(wb_fileno, "[05] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[10], rs32.rs_avail_out_alu[10],
            rs32.rs_table_alu[10].OPaValid, rs32.rs_table_alu[10].OPa,
            rs32.rs_table_alu[10].OPbValid, rs32.rs_table_alu[10].OPb,
            rs32.rs_table_alu[10].DestTag);
  $fdisplay(wb_fileno, "[06] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[9], rs32.rs_avail_out_alu[9],
            rs32.rs_table_alu[9].OPaValid, rs32.rs_table_alu[9].OPa,
            rs32.rs_table_alu[9].OPbValid, rs32.rs_table_alu[9].OPb,
            rs32.rs_table_alu[9].DestTag);
  $fdisplay(wb_fileno, "[07] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[8], rs32.rs_avail_out_alu[8],
            rs32.rs_table_alu[8].OPaValid, rs32.rs_table_alu[8].OPa,
            rs32.rs_table_alu[8].OPbValid, rs32.rs_table_alu[8].OPb,
            rs32.rs_table_alu[8].DestTag);
  $fdisplay(wb_fileno, "[08] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[7], rs32.rs_avail_out_alu[7],
            rs32.rs_table_alu[7].OPaValid, rs32.rs_table_alu[7].OPa,
            rs32.rs_table_alu[7].OPbValid, rs32.rs_table_alu[7].OPb,
            rs32.rs_table_alu[7].DestTag);
  $fdisplay(wb_fileno, "[09] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[6], rs32.rs_avail_out_alu[6],
            rs32.rs_table_alu[6].OPaValid, rs32.rs_table_alu[6].OPa,
            rs32.rs_table_alu[6].OPbValid, rs32.rs_table_alu[6].OPb,
            rs32.rs_table_alu[6].DestTag);
  $fdisplay(wb_fileno, "[10] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[5], rs32.rs_avail_out_alu[5],
            rs32.rs_table_alu[5].OPaValid, rs32.rs_table_alu[5].OPa,
            rs32.rs_table_alu[5].OPbValid, rs32.rs_table_alu[5].OPb,
            rs32.rs_table_alu[5].DestTag);
  $fdisplay(wb_fileno, "[11] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[4], rs32.rs_avail_out_alu[4],
            rs32.rs_table_alu[4].OPaValid, rs32.rs_table_alu[4].OPa,
            rs32.rs_table_alu[4].OPbValid, rs32.rs_table_alu[4].OPb,
            rs32.rs_table_alu[4].DestTag);
  $fdisplay(wb_fileno, "[12] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[3], rs32.rs_avail_out_alu[3],
            rs32.rs_table_alu[3].OPaValid, rs32.rs_table_alu[3].OPa,
            rs32.rs_table_alu[3].OPbValid, rs32.rs_table_alu[3].OPb,
            rs32.rs_table_alu[3].DestTag);
  $fdisplay(wb_fileno, "[13] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[2], rs32.rs_avail_out_alu[2],
            rs32.rs_table_alu[2].OPaValid, rs32.rs_table_alu[2].OPa,
            rs32.rs_table_alu[2].OPbValid, rs32.rs_table_alu[2].OPb,
            rs32.rs_table_alu[2].DestTag);
  $fdisplay(wb_fileno, "[14] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[1], rs32.rs_avail_out_alu[1],
            rs32.rs_table_alu[1].OPaValid, rs32.rs_table_alu[1].OPa,
            rs32.rs_table_alu[1].OPbValid, rs32.rs_table_alu[1].OPb,
            rs32.rs_table_alu[1].DestTag);
  $fdisplay(wb_fileno, "[15] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_alu[0], rs32.rs_avail_out_alu[0],
            rs32.rs_table_alu[0].OPaValid, rs32.rs_table_alu[0].OPa,
            rs32.rs_table_alu[0].OPbValid, rs32.rs_table_alu[0].OPb,
            rs32.rs_table_alu[0].DestTag);
  $fdisplay(wb_fileno, "============================================[ MUL RS ]===============================================");
  $fdisplay(wb_fileno, "[00] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[15], rs32.rs_avail_out_mult[15],
            rs32.rs_table_mult[15].OPaValid, rs32.rs_table_mult[15].OPa,
            rs32.rs_table_mult[15].OPbValid, rs32.rs_table_mult[15].OPb,
            rs32.rs_table_mult[15].DestTag);
  $fdisplay(wb_fileno, "[01] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[14], rs32.rs_avail_out_mult[14],
            rs32.rs_table_mult[14].OPaValid, rs32.rs_table_mult[14].OPa,
            rs32.rs_table_mult[14].OPbValid, rs32.rs_table_mult[14].OPb,
            rs32.rs_table_mult[14].DestTag);
  $fdisplay(wb_fileno, "[02] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[13], rs32.rs_avail_out_mult[13],
            rs32.rs_table_mult[13].OPaValid, rs32.rs_table_mult[13].OPa,
            rs32.rs_table_mult[13].OPbValid, rs32.rs_table_mult[13].OPb,
            rs32.rs_table_mult[13].DestTag);
  $fdisplay(wb_fileno, "[03] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[12], rs32.rs_avail_out_mult[12],
            rs32.rs_table_mult[12].OPaValid, rs32.rs_table_mult[12].OPa,
            rs32.rs_table_mult[12].OPbValid, rs32.rs_table_mult[12].OPb,
            rs32.rs_table_mult[12].DestTag);
  $fdisplay(wb_fileno, "[04] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[11], rs32.rs_avail_out_mult[11],
            rs32.rs_table_mult[11].OPaValid, rs32.rs_table_mult[11].OPa,
            rs32.rs_table_mult[11].OPbValid, rs32.rs_table_mult[11].OPb,
            rs32.rs_table_mult[11].DestTag);
  $fdisplay(wb_fileno, "[05] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[10], rs32.rs_avail_out_mult[10],
            rs32.rs_table_mult[10].OPaValid, rs32.rs_table_mult[10].OPa,
            rs32.rs_table_mult[10].OPbValid, rs32.rs_table_mult[10].OPb,
            rs32.rs_table_mult[10].DestTag);
  $fdisplay(wb_fileno, "[06] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[9], rs32.rs_avail_out_mult[9],
            rs32.rs_table_mult[9].OPaValid, rs32.rs_table_mult[9].OPa,
            rs32.rs_table_mult[9].OPbValid, rs32.rs_table_mult[9].OPb,
            rs32.rs_table_mult[9].DestTag);
  $fdisplay(wb_fileno, "[07] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[8], rs32.rs_avail_out_mult[8],
            rs32.rs_table_mult[8].OPaValid, rs32.rs_table_mult[8].OPa,
            rs32.rs_table_mult[8].OPbValid, rs32.rs_table_mult[8].OPb,
            rs32.rs_table_mult[8].DestTag);
  $fdisplay(wb_fileno, "[08] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[7], rs32.rs_avail_out_mult[7],
            rs32.rs_table_mult[7].OPaValid, rs32.rs_table_mult[7].OPa,
            rs32.rs_table_mult[7].OPbValid, rs32.rs_table_mult[7].OPb,
            rs32.rs_table_mult[7].DestTag);
  $fdisplay(wb_fileno, "[09] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[6], rs32.rs_avail_out_mult[6],
            rs32.rs_table_mult[6].OPaValid, rs32.rs_table_mult[6].OPa,
            rs32.rs_table_mult[6].OPbValid, rs32.rs_table_mult[6].OPb,
            rs32.rs_table_mult[6].DestTag);
  $fdisplay(wb_fileno, "[10] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[5], rs32.rs_avail_out_mult[5],
            rs32.rs_table_mult[5].OPaValid, rs32.rs_table_mult[5].OPa,
            rs32.rs_table_mult[5].OPbValid, rs32.rs_table_mult[5].OPb,
            rs32.rs_table_mult[5].DestTag);
  $fdisplay(wb_fileno, "[11] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[4], rs32.rs_avail_out_mult[4],
            rs32.rs_table_mult[4].OPaValid, rs32.rs_table_mult[4].OPa,
            rs32.rs_table_mult[4].OPbValid, rs32.rs_table_mult[4].OPb,
            rs32.rs_table_mult[4].DestTag);
  $fdisplay(wb_fileno, "[12] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[3], rs32.rs_avail_out_mult[3],
            rs32.rs_table_mult[3].OPaValid, rs32.rs_table_mult[3].OPa,
            rs32.rs_table_mult[3].OPbValid, rs32.rs_table_mult[3].OPb,
            rs32.rs_table_mult[3].DestTag);
  $fdisplay(wb_fileno, "[13] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[2], rs32.rs_avail_out_mult[2],
            rs32.rs_table_mult[2].OPaValid, rs32.rs_table_mult[2].OPa,
            rs32.rs_table_mult[2].OPbValid, rs32.rs_table_mult[2].OPb,
            rs32.rs_table_mult[2].DestTag);
  $fdisplay(wb_fileno, "[14] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[1], rs32.rs_avail_out_mult[1],
            rs32.rs_table_mult[1].OPaValid, rs32.rs_table_mult[1].OPa,
            rs32.rs_table_mult[1].OPbValid, rs32.rs_table_mult[1].OPb,
            rs32.rs_table_mult[1].DestTag);
  $fdisplay(wb_fileno, "[15] | val:%b | rdy:%b | rdyA:%d | A:%d | rdyB:%d | B:%d | dest:%d |",
            rs32.rs_avail_out_mult[0], rs32.rs_avail_out_mult[0],
            rs32.rs_table_mult[0].OPaValid, rs32.rs_table_mult[0].OPa,
            rs32.rs_table_mult[0].OPbValid, rs32.rs_table_mult[0].OPb,
            rs32.rs_table_mult[0].DestTag);
  $fdisplay(wb_fileno, "=====================================================================================================");
  $fdisplay(wb_fileno, "");
  $fdisplay(wb_fileno, "");
  `endif
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

  //Open header AFTER throwing the reset otherwise the reset state is displayed
  $fdisplay(wb_fileno, "====================================================================================================");
  $fdisplay(wb_fileno, "|                                Reservation Station Data flow Result                              |");
  $fdisplay(wb_fileno, "====================================================================================================\n");
  /*$monitor("ALUa1:%d, ALUb1:%d, ALUa2:%d, ALUb2:%d, MULa1:%d, MULb1:%d, MULa2:%d, MULb2:%d",
           opa1_alu_out, opb1_alu_out, opa2_alu_out, opb2_alu_out,
           opa1_mult_out, opb1_mult_out, opa2_mult_out, opb2_mult_out);*/

  mult_free1_in = 1;
  mult_free2_in = 1;
  alu_free1_in = 1;
  alu_free2_in = 1;

  rd_mem1_in = 0;
  rd_mem2_in = 0;
  wr_mem1_in = 0;
  wr_mem2_in = 0;

  instr_valid1_in = 0;
  instr_valid2_in = 0;

  rs_complete_inst = 0;

  @(negedge clock);
  print_result;

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 808088,  instr2 : opa = 777
  // instr1 : opb = 333992,  instr2 : opb = NOT VALID (PRN: 9)
  /////////////////////////////////////////////////////////////////////////////////
  dest_PRN1_in = 10;
  PRNa1_in = 6;  
  opa1_in = 808088;
  opa1_valid = 1;   
  opb1_in = 333992;
  PRNb1_in = 7;
  opb1_valid = 1;
  alu_func1_in = `ALU_ADDQ;
  ROB1_in = 1;
  instr_valid1_in = 1;

  dest_PRN2_in = 13;
  opa2_in = 777; 
  PRNa2_in = 10;  
  opa2_valid = 1;   
  PRNb2_in = 9;
  opb2_valid = 0;
  alu_func2_in = `ALU_ADDQ;
  ROB2_in = 2;
  instr_valid2_in = 1;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = (opa1_alu_out === 808088) && (opb1_alu_out === 333992);
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  cdb2_tag = 9; 
  cdb2_valid = 1;
  cdb2_in = 2222222;

  ///////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 4300,     instr2 : opa = 3877
  // instr1 : opb = 1000000,  instr2 : opb = 14500
  ///////////////////////////////////////////////////////////////////////////
  dest_PRN1_in = 70;
  opa1_in = 4300; 
  PRNa1_in = 46;  
  opa1_valid = 1;   
  opb1_in = 1000000;
  PRNb1_in = 47;
  opb1_valid = 1;
  alu_func1_in = `ALU_ADDQ;
  ROB1_in = 3;
  instr_valid1_in = 1;

  dest_PRN2_in = 50;
  opa2_in = 3877; 
  PRNa2_in = 30;  
  opa2_valid = 1;   
  opb2_in = 14500;
  PRNb2_in = 39;
  opb2_valid = 1;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 4;
  instr_valid2_in = 1;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 3;
  correct = ((opa2_alu_out === 777) && (opb2_alu_out === 2222222)) &
            ((opa1_alu_out === 4300) && (opb1_alu_out === 1000000)) &
            ((opa1_mult_out === 3877) && (opb1_mult_out === 14500));

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
  dest_PRN1_in = 20;
  opa1_in = 900; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  //opb1_in = 120;
  PRNb1_in = 44;
  opb1_valid = 0;
  alu_func1_in = `ALU_MULQ;
  ROB1_in = 8;
  instr_valid1_in = 1;

  dest_PRN2_in = 13;
  opa2_in = 90070; 
  PRNa2_in = 25;  
  opa2_valid = 1;   
  opb2_in = 999000;
  PRNb2_in = 14;
  opb2_valid = 1;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 9;
  instr_valid2_in = 1;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = ((opa1_mult_out === 90070) && (opb1_mult_out === 999000));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  cdb1_tag = 44; 
  cdb1_valid = 1;
  cdb1_in = 440770;

  instr_valid1_in = 0;
  instr_valid2_in = 0;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = ((opa1_mult_out === 900) && (opb1_mult_out === 440770));
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

  instr_valid1_in = 1;
  instr_valid2_in = 1;

  dest_PRN1_in = 30;
  opa1_in = 4040; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  PRNb1_in = 4400;
  opb1_valid = 0;
  alu_func1_in = `ALU_MULQ;
  ROB1_in = 20;

  dest_PRN2_in = 23;
  opa2_in = 44440; 
  PRNa2_in = 25;  
  opa2_valid = 1;   
  opb2_in = 44545;
  PRNb2_in = 16;
  opb2_valid = 1;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 21;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;

  correct = ((opa1_mult_out === 44440) && (opb1_mult_out === 44545));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  dest_PRN1_in = 30;
  opa1_in = 5050; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  opb1_in = 5550;
  PRNb1_in = 55;
  opb1_valid = 1;
  alu_func1_in = `ALU_MULQ;
  ROB1_in = 26;

  dest_PRN2_in = 23;
  opa2_in = 55550; 
  PRNa2_in = 25;  
  opa2_valid = 1;
  opb2_in = 577557;
  PRNb2_in = 16;
  opb2_valid = 1;
  alu_func2_in = `ALU_SUBQ;
  ROB2_in = 27;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = ((opa1_mult_out === 5050) && (opb1_mult_out === 5550)) &&
            ((opa1_alu_out === 55550) && (opb1_alu_out === 577557));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  dest_PRN1_in = 30;
  opa1_in = 6060; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  opb1_in = 6120;
  PRNb1_in = 66;
  opb1_valid = 1;
  alu_func1_in = `ALU_MULQ;
  ROB1_in = 30;

  dest_PRN2_in = 23;
  opa2_in = 66660; 
  PRNa2_in = 25;  
  opa2_valid = 1;   
  opb2_in = 66545;
  PRNb2_in = 16;
  opb2_valid = 1;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 31;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;

  correct = ((opa2_mult_out === 66660) && (opb2_mult_out === 66545)) &&
            ((opa1_mult_out === 6060) && (opb1_mult_out === 6120));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  dest_PRN1_in = 30;
  opa1_in = 7070; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  //opb1_in = 120;
  PRNb1_in = 7700;
  opb1_valid = 0;
  alu_func1_in = `ALU_MULQ;
  ROB1_in = 35;

  dest_PRN2_in = 23;
  opa2_in = 77770; 
  PRNa2_in = 25;  
  opa2_valid = 1;   
  opb2_in = 77545;
  PRNb2_in = 16;
  opb2_valid = 1;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 36;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = ((opa1_mult_out === 77770) && (opb1_mult_out === 77545));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  dest_PRN1_in = 30;
  opa1_in = 8080; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  //opb1_in = 120;
  PRNb1_in = 8800;
  opb1_valid = 0;
  alu_func1_in = `ALU_MULQ;
  ROB1_in = 40;

  dest_PRN2_in = 23;
  opa2_in = 88880; 
  PRNa2_in = 25;  
  opa2_valid = 1;   
  opb2_in = 88545;
  PRNb2_in = 16;
  opb2_valid = 1;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 41;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = ((opa1_mult_out === 88880) && (opb1_mult_out === 88545));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  rd_mem1_in = 1;    // LD instruction
  ROB1_in = 46;
  dest_PRN1_in = 30;
  opa1_in = 38383838; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  PRNb1_in = 60;
  alu_func1_in = `LDQ_INST;
  opb1_valid = 0;

  wr_mem2_in = 1;
  dest_PRN2_in = 23;
  opa2_in = 46464646; 
  PRNa2_in = 25;  
  opa2_valid = 1;   
  opb2_in = 77777777;
  PRNb2_in = 16;
  opb2_valid = 1;
  alu_func2_in = `STQ_INST;
  ROB2_in = 47;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = 1;
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");
  print_result;

  ////////////////////////////////////////////////////////////////////////
  // instr 1: LOAD, shouldn't load it into RS (but in LSQ)
  // instr 2: MULT instr.
  ////////////////////////////////////////////////////////////////////////
  rd_mem1_in = 0;
  wr_mem2_in = 0;

  dest_PRN1_in = 40;
  opa1_in = 700; 
  PRNa1_in = 26;  
  opa1_valid = 1;   
  opb1_in = 7120;
  PRNb1_in = 73;
  opb1_valid = 1;
  alu_func1_in = `ALU_SUBQ;
  ROB1_in = 48;

  dest_PRN2_in = 23;
  opa2_in = 77777; 
  PRNa2_in = 25;  
  opa2_valid = 1;   
  opb2_in = 787878;
  PRNb2_in = 16;
  opb2_valid = 1;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 49;

  print_RS;

  @(negedge clock);
  rs_complete_inst = 1;
  correct = ((opa1_alu_out === 700) && (opb1_alu_out === 7120)) &&
            ((opa1_mult_out === 77777) && (opb1_mult_out === 787878));
  if(!correct) begin
    $display("@@@ Failed");
    $finish;
  end
  else
    $display("@@@ Passed");

  print_RS;

  print_result;

  show_clk_count;
  $fclose(wb_fileno);
  $fclose(wb_filen1);

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

