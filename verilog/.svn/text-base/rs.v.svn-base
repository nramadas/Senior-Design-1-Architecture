module rs(// inputs:
          reset,
          clock,

          rs_mult_free1_in,
          rs_mult_free2_in,
          rs_alu_free1_in,
          rs_alu_free2_in,

          rs_mispredict1_in,
          rs_mispredict2_in,

          // instruction 1 from the issue stage
          rs_dest_PRN1_in,
          rs_opa1_in,
          rs_PRNa1_in,
          rs_opa1_valid,
          rs_opb1_in,
          rs_PRNb1_in,
          rs_opb1_valid, 
          rs_cdb1_in,
          rs_cdb1_tag,
          rs_cdb1_valid,
          rs_cdb1_take_branch,
          rs_cdb1_NPC,
          rs_cond_branch1_in,
          rs_uncond_branch1_in,
          rs_issue_NPC1_in,
          rs_issue_IR1_in,
          rs_alu_func1_in,
          rs_ROB1_in,
          rs_opa_select1_in,
          rs_opb_select1_in,
          rs_rd_mem1_in,
          rs_wr_mem1_in,
          rs_instr_valid1_in,

          // instruction 2 from the issue stage
          rs_dest_PRN2_in,
          rs_opa2_in,
          rs_PRNa2_in,
          rs_opa2_valid,
          rs_opb2_in,
          rs_PRNb2_in,
          rs_opb2_valid, 
          rs_cdb2_in,
          rs_cdb2_tag,
          rs_cdb2_valid,
          rs_cdb2_take_branch,
          rs_cdb2_NPC,
          rs_cond_branch2_in,
          rs_uncond_branch2_in,
          rs_halt1_in,
          rs_issue_NPC2_in,
          rs_issue_IR2_in,
          rs_alu_func2_in,
          rs_ROB2_in,
          rs_opa_select2_in,
          rs_opb_select2_in,
          rs_rd_mem2_in,
          rs_wr_mem2_in,
          rs_instr_valid2_in,

          // outputs:
          rs_stall_out,

          // instruction 1 to alu
          rs_opa1_alu_out,
          rs_opb1_alu_out,
          rs_dest_PRN1_alu_out,
          rs_cond_branch1_alu_out,
          rs_uncond_branch1_alu_out,
          rs_halt2_in,
          rs_NPC1_alu_out, 
          rs_IR1_alu_out,
          rs_alu_func1_alu_out,
          rs_ROB1_alu_out,
          rs_opa_select1_alu_out,
          rs_opb_select1_alu_out,
          rs_instr_valid1_alu_out,

          // instruction 2 to alu
          rs_opa2_alu_out,
          rs_opb2_alu_out,
          rs_dest_PRN2_alu_out,
          rs_cond_branch2_alu_out,
          rs_uncond_branch2_alu_out,
          rs_NPC2_alu_out, 
          rs_IR2_alu_out,
          rs_alu_func2_alu_out,
          rs_ROB2_alu_out,
          rs_opa_select2_alu_out,
          rs_opb_select2_alu_out,
          rs_instr_valid2_alu_out,

          // instruction 1 to mult
          rs_opa1_mult_out,
          rs_opb1_mult_out,
          rs_dest_PRN1_mult_out,
          rs_cond_branch1_mult_out,
          rs_uncond_branch1_mult_out,
          rs_NPC1_mult_out, 
          rs_IR1_mult_out,
          rs_alu_func1_mult_out,
          rs_ROB1_mult_out,
          rs_opa_select1_mult_out,
          rs_opb_select1_mult_out,
          rs_instr_valid1_mult_out,

          // instruction 2 to mult
          rs_opa2_mult_out,
          rs_opb2_mult_out,
          rs_dest_PRN2_mult_out,
          rs_cond_branch2_mult_out,
          rs_uncond_branch2_mult_out,
          rs_NPC2_mult_out, 
          rs_IR2_mult_out,
          rs_alu_func2_mult_out,
          rs_ROB2_mult_out,
          rs_opa_select2_mult_out,
          rs_opb_select2_mult_out,
          rs_instr_valid2_mult_out);

input          reset;                       // reset signal 
input          clock;                       // the clock 

input          rs_mult_free1_in;
input          rs_mult_free2_in;
input          rs_alu_free1_in;
input          rs_alu_free2_in;

input          rs_mispredict1_in;
input          rs_mispredict2_in;

input   [6:0]  rs_dest_PRN1_in;             // The destination of this instruction 
input  [63:0]  rs_opa1_in;                  // Operand a from Rename  
input   [6:0]  rs_PRNa1_in;                 // Physical Register Number for opA
input          rs_opa1_valid;               // Is Opa a Tag or immediate data
input  [63:0]  rs_opb1_in;                  // Operand a from Rename 
input   [6:0]  rs_PRNb1_in;                 // Physical Register Number for opB
input          rs_opb1_valid;               // Is Opb a tag or immediate data
input  [63:0]  rs_cdb1_in;                  // CDB bus from functional units 
wire   [63:0]  rs_cdb1_in1;
input   [6:0]  rs_cdb1_tag;                 // CDB tag bus from functional units 
input          rs_cdb1_valid;               // The data on the CDB is valid 
input          rs_cdb1_take_branch;
input   [63:0] rs_cdb1_NPC;
input          rs_cond_branch1_in;
input          rs_uncond_branch1_in;
input          rs_halt1_in;
input  [63:0]  rs_issue_NPC1_in;            // Next PC from issue stage
input  [31:0]  rs_issue_IR1_in;             // instruction from issue stage
input   [4:0]  rs_alu_func1_in;             // alu opcode from issue stage
input   [5:0]  rs_ROB1_in;                  // ROB entry number
input   [1:0]  rs_opa_select1_in;
input   [1:0]  rs_opb_select1_in;
input          rs_rd_mem1_in;
input          rs_wr_mem1_in;
input          rs_instr_valid1_in;

input   [6:0]  rs_dest_PRN2_in;             // The destination of this instruction 
input  [63:0]  rs_opa2_in;                  // Operand a from Rename  
input   [6:0]  rs_PRNa2_in;                 // Physical Register Number for opA
input          rs_opa2_valid;               // Is Opa a Tag or immediate data
input  [63:0]  rs_opb2_in;                  // Operand a from Rename 
input   [6:0]  rs_PRNb2_in;                 // Physical Register Number for opB
input          rs_opb2_valid;               // Is Opb a tag or immediate data
input  [63:0]  rs_cdb2_in;                  // CDB bus from functional units 
wire   [63:0]  rs_cdb2_in1;
input   [6:0]  rs_cdb2_tag;                 // CDB tag bus from functional units 
input          rs_cdb2_valid;               // The data on the CDB is valid 
input          rs_cdb2_take_branch;
input   [63:0] rs_cdb2_NPC;
input          rs_cond_branch2_in;
input          rs_uncond_branch2_in;
input          rs_halt2_in;
input  [63:0]  rs_issue_NPC2_in;            // Next PC from issue stage
input  [31:0]  rs_issue_IR2_in;             // instruction from issue stage
input   [4:0]  rs_alu_func2_in;             // alu opcode from issue stage
input   [5:0]  rs_ROB2_in;                  // ROB entry number
input   [1:0]  rs_opa_select2_in;
input   [1:0]  rs_opb_select2_in;
input          rs_rd_mem2_in;
input          rs_wr_mem2_in;
input          rs_instr_valid2_in;

output [63:0]  rs_opa1_alu_out;             // This RS' opa 
output [63:0]  rs_opb1_alu_out;             // This RS' opb 
output  [6:0]  rs_dest_PRN1_alu_out;        // This RS' destination tag  
output         rs_cond_branch1_alu_out;
output         rs_uncond_branch1_alu_out;
output [63:0]  rs_NPC1_alu_out;             // PC+4 to EX for target address
output [31:0]  rs_IR1_alu_out;
output  [4:0]  rs_alu_func1_alu_out;
output  [5:0]  rs_ROB1_alu_out;             // ROB number passed into the FU
output  [1:0]  rs_opa_select1_alu_out;
output  [1:0]  rs_opb_select1_alu_out;
output         rs_instr_valid1_alu_out;

output [63:0]  rs_opa2_alu_out;             // This RS' opa 
output [63:0]  rs_opb2_alu_out;             // This RS' opb 
output  [6:0]  rs_dest_PRN2_alu_out;        // This RS' destination tag  
output         rs_cond_branch2_alu_out;
output         rs_uncond_branch2_alu_out;
output [63:0]  rs_NPC2_alu_out;             // PC+4 to EX for target address
output [31:0]  rs_IR2_alu_out;
output  [4:0]  rs_alu_func2_alu_out;
output  [5:0]  rs_ROB2_alu_out;             // ROB number passed into the FU
output  [1:0]  rs_opa_select2_alu_out;
output  [1:0]  rs_opb_select2_alu_out;
output         rs_instr_valid2_alu_out;

output [63:0]  rs_opa1_mult_out;            // This RS' opa 
output [63:0]  rs_opb1_mult_out;            // This RS' opb 
output  [6:0]  rs_dest_PRN1_mult_out;       // This RS' destination tag  
output         rs_cond_branch1_mult_out;
output         rs_uncond_branch1_mult_out;
output [63:0]  rs_NPC1_mult_out;            // PC+4 to EX for target address
output [31:0]  rs_IR1_mult_out;
output  [4:0]  rs_alu_func1_mult_out;
output  [5:0]  rs_ROB1_mult_out;            // ROB number passed into the FU
output  [1:0]  rs_opa_select1_mult_out;
output  [1:0]  rs_opb_select1_mult_out;
output         rs_instr_valid1_mult_out;

output [63:0]  rs_opa2_mult_out;            // This RS' opa 
output [63:0]  rs_opb2_mult_out;            // This RS' opb 
output  [6:0]  rs_dest_PRN2_mult_out;       // This RS' destination tag  
output         rs_cond_branch2_mult_out;
output         rs_uncond_branch2_mult_out;
output [63:0]  rs_NPC2_mult_out;            // PC+4 to EX for target address
output [31:0]  rs_IR2_mult_out;
output  [4:0]  rs_alu_func2_mult_out;
output  [5:0]  rs_ROB2_mult_out;            // ROB number passed into the FU
output  [1:0]  rs_opa_select2_mult_out;
output  [1:0]  rs_opb_select2_mult_out;
output         rs_instr_valid2_mult_out;

output         rs_stall_out;

wire   [15:0]  rs_avail_out_alu;
wire   [15:0]  rs_ready_out_alu;
wire   [15:0]  rs_use_enable1_alu;
wire   [15:0]  rs_use_enable2_alu;
wire   [15:0]  rs_load1_in_alu;
wire   [15:0]  rs_load2_in_alu; 

wire   [15:0]  rs_avail_out_mult;
wire   [15:0]  rs_ready_out_mult;
wire   [15:0]  rs_use_enable1_mult;
wire   [15:0]  rs_use_enable2_mult;
wire   [15:0]  rs_load1_in_mult;
wire   [15:0]  rs_load2_in_mult;

wor    [63:0]  rs_opa1_alu_out;             // This RS' opa 
wor    [63:0]  rs_opb1_alu_out;             // This RS' opb 
wor     [6:0]  rs_dest_PRN1_alu_out;        // This RS' destination tag  
wor            rs_cond_branch1_alu_out;
wor            rs_uncond_branch1_alu_out;
wor    [63:0]  rs_NPC1_alu_out;             // PC+4 to EX for target address
wor    [31:0]  rs_IR1_alu_out;
wor     [4:0]  rs_alu_func1_alu_out;
wor     [5:0]  rs_ROB1_alu_out;             // ROB number passed into the FU
wor     [1:0]  rs_opa_select1_alu_out;
wor     [1:0]  rs_opb_select1_alu_out;
wor            rs_instr_valid1_alu_out;

wor    [63:0]  rs_opa2_alu_out;             // This RS' opa 
wor    [63:0]  rs_opb2_alu_out;             // This RS' opb 
wor     [6:0]  rs_dest_PRN2_alu_out;        // This RS' destination tag  
wor            rs_cond_branch2_alu_out;
wor            rs_uncond_branch2_alu_out;
wor    [63:0]  rs_NPC2_alu_out;             // PC+4 to EX for target address
wor    [31:0]  rs_IR2_alu_out;
wor     [4:0]  rs_alu_func2_alu_out;
wor     [5:0]  rs_ROB2_alu_out;             // ROB number passed into the FU
wor     [1:0]  rs_opa_select2_alu_out;
wor     [1:0]  rs_opb_select2_alu_out;
wor            rs_instr_valid2_alu_out;

wor    [63:0]  rs_opa1_mult_out;            // This RS' opa 
wor    [63:0]  rs_opb1_mult_out;            // This RS' opb 
wor     [6:0]  rs_dest_PRN1_mult_out;       // This RS' destination tag  
wor            rs_cond_branch1_mult_out;
wor            rs_uncond_branch1_mult_out;
wor    [63:0]  rs_NPC1_mult_out;            // PC+4 to EX for target address
wor    [31:0]  rs_IR1_mult_out;
wor     [4:0]  rs_alu_func1_mult_out;
wor     [5:0]  rs_ROB1_mult_out;            // ROB number passed into the FU
wor     [1:0]  rs_opa_select1_mult_out;
wor     [1:0]  rs_opb_select1_mult_out;
wor            rs_instr_valid1_mult_out;

wor    [63:0]  rs_opa2_mult_out;            // This RS' opa 
wor    [63:0]  rs_opb2_mult_out;            // This RS' opb 
wor     [6:0]  rs_dest_PRN2_mult_out;       // This RS' destination tag  
wor            rs_cond_branch2_mult_out;
wor            rs_uncond_branch2_mult_out;
wor    [63:0]  rs_NPC2_mult_out;            // PC+4 to EX for target address
wor    [31:0]  rs_IR2_mult_out;
wor     [4:0]  rs_alu_func2_mult_out;
wor     [5:0]  rs_ROB2_mult_out;            // ROB number passed into the FU
wor     [1:0]  rs_opa_select2_mult_out;
wor     [1:0]  rs_opb_select2_mult_out;
wor            rs_instr_valid2_mult_out;

assign rs_stall_out = (rs_load1_in_alu==rs_load2_in_alu) || (rs_load1_in_mult==rs_load2_in_mult);

assign rs_cdb1_in1 = (rs_cdb1_take_branch && rs_cdb1_valid) ? rs_cdb1_NPC : rs_cdb1_in;
assign rs_cdb2_in1 = (rs_cdb2_take_branch && rs_cdb2_valid) ? rs_cdb2_NPC : rs_cdb2_in;


rs_entry_mult rs_table_mult [15:0] (
           // inputs
           .reset(reset | rs_mispredict1_in | rs_mispredict2_in),
           .clock(clock),

           .rs_entry_use_enable1(rs_use_enable1_mult),
           .rs_entry_use_enable2(rs_use_enable2_mult),
           .rs_entry_free_in(rs_use_enable1_mult | rs_use_enable2_mult),

           .rs_entry_cdb1_in(rs_cdb1_in1),
           .rs_entry_cdb1_tag(rs_cdb1_tag),
           .rs_entry_cdb1_valid(rs_cdb1_valid),

           .rs_entry_cdb2_in(rs_cdb2_in1),
           .rs_entry_cdb2_tag(rs_cdb2_tag),
           .rs_entry_cdb2_valid(rs_cdb2_valid),

           .rs_entry_dest1_in(rs_dest_PRN1_in),
           .rs_entry_opa1_in(rs_opa1_in),
           .rs_entry_opa1_valid(rs_opa1_valid),
           .rs_entry_opa1_tag_in(rs_PRNa1_in),
           .rs_entry_opb1_in(rs_opb1_in),
           .rs_entry_opb1_valid(rs_opb1_valid), 
           .rs_entry_opb1_tag_in(rs_PRNb1_in),
           .rs_entry_load1_in(rs_load1_in_mult & (~rs_stall_out)),
           .rs_entry_cond_branch1_in(rs_cond_branch1_in),
           .rs_entry_uncond_branch1_in(rs_uncond_branch1_in),
           .rs_entry_NPC1_in(rs_issue_NPC1_in),
           .rs_entry_IR1_in(rs_issue_IR1_in),
           .rs_entry_alu_func1_in(rs_alu_func1_in),
           .rs_entry_ROB1_in(rs_ROB1_in),
           .rs_entry_rd_mem1_in(rs_rd_mem1_in),
           .rs_entry_wr_mem1_in(rs_wr_mem1_in),
           .rs_entry_opa_select1_in(rs_opa_select1_in),
           .rs_entry_opb_select1_in(rs_opb_select1_in),
           .rs_entry_instr_valid1_in(rs_instr_valid1_in),

           .rs_entry_dest2_in(rs_dest_PRN2_in),
           .rs_entry_opa2_in(rs_opa2_in),
           .rs_entry_opa2_valid(rs_opa2_valid),
           .rs_entry_opa2_tag_in(rs_PRNa2_in),
           .rs_entry_opb2_in(rs_opb2_in),
           .rs_entry_opb2_valid(rs_opb2_valid),
           .rs_entry_opb2_tag_in(rs_PRNb2_in),
           .rs_entry_load2_in(rs_load2_in_mult & (~rs_stall_out)),
           .rs_entry_cond_branch2_in(rs_cond_branch2_in),
           .rs_entry_uncond_branch2_in(rs_uncond_branch2_in),
           .rs_entry_NPC2_in(rs_issue_NPC2_in),
           .rs_entry_IR2_in(rs_issue_IR2_in),
           .rs_entry_alu_func2_in(rs_alu_func2_in),
           .rs_entry_ROB2_in(rs_ROB2_in),
           .rs_entry_rd_mem2_in(rs_rd_mem2_in),
           .rs_entry_wr_mem2_in(rs_wr_mem2_in),
           .rs_entry_opa_select2_in(rs_opa_select2_in),
           .rs_entry_opb_select2_in(rs_opb_select2_in),
           .rs_entry_instr_valid2_in(rs_instr_valid2_in),

           // output
           .rs_entry_avail_out(rs_avail_out_mult),
           .rs_entry_ready_out(rs_ready_out_mult),

           .rs_entry_opa1_out(rs_opa1_mult_out),
           .rs_entry_opb1_out(rs_opb1_mult_out),
           .rs_entry_dest_tag1_out(rs_dest_PRN1_mult_out),
           .rs_entry_cond_branch1_out(rs_cond_branch1_mult_out),
           .rs_entry_uncond_branch1_out(rs_uncond_branch1_mult_out),
           .rs_entry_NPC1_out(rs_NPC1_mult_out),
           .rs_entry_IR1_out(rs_IR1_mult_out),
           .rs_entry_alu_func1_out(rs_alu_func1_mult_out),
           .rs_entry_ROB1_out(rs_ROB1_mult_out),
           .rs_entry_opa_select1_out(rs_opa_select1_mult_out),
           .rs_entry_opb_select1_out(rs_opb_select1_mult_out),
           .rs_entry_instr_valid1_out(rs_instr_valid1_mult_out),

           .rs_entry_opa2_out(rs_opa2_mult_out),
           .rs_entry_opb2_out(rs_opb2_mult_out),
           .rs_entry_dest_tag2_out(rs_dest_PRN2_mult_out),
           .rs_entry_cond_branch2_out(rs_cond_branch2_mult_out),
           .rs_entry_uncond_branch2_out(rs_uncond_branch2_mult_out),
           .rs_entry_NPC2_out(rs_NPC2_mult_out),
           .rs_entry_IR2_out(rs_IR2_mult_out),
           .rs_entry_alu_func2_out(rs_alu_func2_mult_out),
           .rs_entry_ROB2_out(rs_ROB2_mult_out),
           .rs_entry_opa_select2_out(rs_opa_select2_mult_out),
           .rs_entry_opb_select2_out(rs_opb_select2_mult_out),
           .rs_entry_instr_valid2_out(rs_instr_valid2_mult_out));

rs_entry_alu rs_table_alu [15:0] (
           // inputs
           .reset(reset | rs_mispredict1_in | rs_mispredict2_in),
           .clock(clock),

           .rs_entry_use_enable1(rs_use_enable1_alu),
           .rs_entry_use_enable2(rs_use_enable2_alu),
           .rs_entry_free_in(rs_use_enable1_alu | rs_use_enable2_alu),

           .rs_entry_cdb1_in(rs_cdb1_in1),
           .rs_entry_cdb1_tag(rs_cdb1_tag),
           .rs_entry_cdb1_valid(rs_cdb1_valid),

           .rs_entry_cdb2_in(rs_cdb2_in1),
           .rs_entry_cdb2_tag(rs_cdb2_tag),
           .rs_entry_cdb2_valid(rs_cdb2_valid),

           .rs_entry_dest1_in(rs_dest_PRN1_in),
           .rs_entry_opa1_in(rs_opa1_in),
           .rs_entry_opa1_valid(rs_opa1_valid),
           .rs_entry_opa1_tag_in(rs_PRNa1_in),
           .rs_entry_opb1_in(rs_opb1_in),
           .rs_entry_opb1_valid(rs_opb1_valid), 
           .rs_entry_opb1_tag_in(rs_PRNb1_in),
           .rs_entry_load1_in(rs_load1_in_alu & (~rs_stall_out)),
           .rs_entry_cond_branch1_in(rs_cond_branch1_in),
           .rs_entry_uncond_branch1_in(rs_uncond_branch1_in),
           .rs_entry_NPC1_in(rs_issue_NPC1_in),
           .rs_entry_IR1_in(rs_issue_IR1_in),
           .rs_entry_alu_func1_in(rs_alu_func1_in),
           .rs_entry_ROB1_in(rs_ROB1_in),
           .rs_entry_opa_select1_in(rs_opa_select1_in),
           .rs_entry_opb_select1_in(rs_opb_select1_in),
           .rs_entry_rd_mem1_in(rs_rd_mem1_in),
           .rs_entry_wr_mem1_in(rs_wr_mem1_in),
           .rs_entry_instr_valid1_in(rs_instr_valid1_in),

           .rs_entry_dest2_in(rs_dest_PRN2_in),
           .rs_entry_opa2_in(rs_opa2_in),
           .rs_entry_opa2_valid(rs_opa2_valid),
           .rs_entry_opa2_tag_in(rs_PRNa2_in),
           .rs_entry_opb2_in(rs_opb2_in),
           .rs_entry_opb2_valid(rs_opb2_valid),
           .rs_entry_opb2_tag_in(rs_PRNb2_in),
           .rs_entry_load2_in(rs_load2_in_alu & (~rs_stall_out)),
           .rs_entry_cond_branch2_in(rs_cond_branch2_in),
           .rs_entry_uncond_branch2_in(rs_uncond_branch2_in),
           .rs_entry_NPC2_in(rs_issue_NPC2_in),
           .rs_entry_IR2_in(rs_issue_IR2_in),
           .rs_entry_alu_func2_in(rs_alu_func2_in),
           .rs_entry_ROB2_in(rs_ROB2_in),
           .rs_entry_opa_select2_in(rs_opa_select2_in),
           .rs_entry_opb_select2_in(rs_opb_select2_in),
           .rs_entry_rd_mem2_in(rs_rd_mem2_in),
           .rs_entry_wr_mem2_in(rs_wr_mem2_in),
           .rs_entry_instr_valid2_in(rs_instr_valid2_in),

           // output
           .rs_entry_avail_out(rs_avail_out_alu),
           .rs_entry_ready_out(rs_ready_out_alu),

           .rs_entry_opa1_out(rs_opa1_alu_out),
           .rs_entry_opb1_out(rs_opb1_alu_out),
           .rs_entry_dest_tag1_out(rs_dest_PRN1_alu_out),
           .rs_entry_cond_branch1_out(rs_cond_branch1_alu_out),
           .rs_entry_uncond_branch1_out(rs_uncond_branch1_alu_out),
           .rs_entry_NPC1_out(rs_NPC1_alu_out),
           .rs_entry_IR1_out(rs_IR1_alu_out),
           .rs_entry_alu_func1_out(rs_alu_func1_alu_out),
           .rs_entry_ROB1_out(rs_ROB1_alu_out),
           .rs_entry_opa_select1_out(rs_opa_select1_alu_out),
           .rs_entry_opb_select1_out(rs_opb_select1_alu_out),
           .rs_entry_instr_valid1_out(rs_instr_valid1_alu_out),

           .rs_entry_opa2_out(rs_opa2_alu_out),
           .rs_entry_opb2_out(rs_opb2_alu_out),
           .rs_entry_dest_tag2_out(rs_dest_PRN2_alu_out),
           .rs_entry_cond_branch2_out(rs_cond_branch2_alu_out),
           .rs_entry_uncond_branch2_out(rs_uncond_branch2_alu_out),
           .rs_entry_NPC2_out(rs_NPC2_alu_out),
           .rs_entry_IR2_out(rs_IR2_alu_out),
           .rs_entry_alu_func2_out(rs_alu_func2_alu_out),
           .rs_entry_ROB2_out(rs_ROB2_alu_out),
           .rs_entry_opa_select2_out(rs_opa_select2_alu_out),
           .rs_entry_opb_select2_out(rs_opb_select2_alu_out),
           .rs_entry_instr_valid2_out(rs_instr_valid2_alu_out));

// 16 bit PS for rs_load1_in_alu_in
ps16 rs_load1_in_alu_in_ps(// input
           .req(rs_avail_out_alu),
           .en(1'b1),
           .gnt(rs_load1_in_alu));

// 16 bit PS for rs_load2_in_alu_in
rev_ps16 rs_load2_in_alu_in_ps(// input
           .req(rs_avail_out_alu),
           .en(1'b1),
           .gnt(rs_load2_in_alu));

// 16 bit PS for rs_load1_in_mult_in
ps16 rs_load1_in_mult_in_ps(// input
           .req(rs_avail_out_mult),
           .en(1'b1),
           .gnt(rs_load1_in_mult));

// 16 bit PS for rs_load2_in_mult_in
rev_ps16 rs_load2_in_mult_in_ps(// input
           .req(rs_avail_out_mult),
           .en(1'b1),
           .gnt(rs_load2_in_mult));

// 16 bit PS for use_enable1_in_alu
ps16 use_en1_alu_ps(// input
           .req(rs_ready_out_alu),
           .en(rs_alu_free1_in),
           .gnt(rs_use_enable1_alu));

// 16 bit PS for use_enable2_in_alu
rev_ps16 use_en2_alu_ps(// input
           .req(rs_ready_out_alu),
           .en(rs_alu_free2_in),
           .gnt(rs_use_enable2_alu));

// 16 bit PS for use_enable1_in_mult
ps16 use_en1_mult_ps(// input
           .req(rs_ready_out_mult),
           .en(rs_mult_free1_in),
           .gnt(rs_use_enable1_mult));

// 16 bit PS for use_enable2_in_mult
rev_ps16 use_en2_mult_ps(// input
           .req(rs_ready_out_mult),
           .en(rs_mult_free2_in),
           .gnt(rs_use_enable2_mult));
endmodule
