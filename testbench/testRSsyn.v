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
extern void get_arr(int a);
extern void print_close();

module testbench;

// Registers and wires ufile:///usr/share/doc/HTML/en-US/index.htmlsed in the testbench
reg        clock;
reg        reset;
integer    wb_fileno;

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

reg  [63:0]  ALU_opa [15:0];
reg  [63:0]  ALU_opb [15:0];
reg  [63:0]  MUL_opa [15:0];
reg  [63:0]  MUL_opb [15:0];

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
          .rs_instr_valid1_mult_out(instr_valid2_mult_out));

always
begin
  #(`VERILOG_CLOCK_PERIOD/2.0);
  clock = ~clock;
end


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

  wb_fileno = $fopen("writeback.out");
  
  //Open header AFTER throwing the reset otherwise the reset state is displayed
  print_rs_header("============================================================================\n");
  print_rs_header("|                    Reservation Station Data flow Result                  |\n");
  print_rs_header("============================================================================\n\n");


  @(negedge clock);

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 808088,  instr2 : opa = 777
  // instr1 : opb = 333992,  instr2 : opb = NOT VALID
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
  opb2_valid = 1;
  alu_func2_in = `ALU_ADDQ;
  ROB2_in = 2;
  instr_valid2_in = 1;

  @(negedge clock);

  cdb2_tag = 9;
  cdb2_valid = 1;
  cdb2_in = 2222222;

  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 4300,     instr2 : opa = 3877
  // instr1 : opb = 1000000,  instr2 : opb = 14500
  /////////////////////////////////////////////////////////////////////////////////
  dest_PRN1_in = 70;
  opa1_in = 4300; 
  PRNa1_in = 46;  
  opa1_valid = 1;   
  opb1_in = 1000000;
  PRNb1_in = 47;
  opb1_valid = 1;
  //issue1_IR_in = 64'h40a4040640430404;
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
  //issue2_IR_in = 64'h40a4040640430404;
  alu_func2_in = `ALU_MULQ;
  ROB2_in = 4;
  instr_valid2_in = 1;


  /////////////////////////////////////////////////////////////////////////////////
  // instr1 : opa = 900,        instr2 : opa = 90070
  // instr1 : opb = NOT VALID,  instr2 : opb = 999000
  /////////////////////////////////////////////////////////////////////////////////
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


  @(negedge clock);

  cdb1_tag = 44; 
  cdb1_valid = 1;
  cdb1_in = 440770;


  instr_valid1_in = 0;
  instr_valid2_in = 0;

  @(negedge clock);

  //print_RS;
$finish;
end
endmodule  // module testbench

