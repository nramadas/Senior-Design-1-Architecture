/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  if_stage.v                                          //
//                                                                     //
//  Description :  instruction fetch (IF) stage of the pipeline;       //
//                 fetch instruction, compute next PC location, and    //
//                 send them down the pipeline.                        //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module if_stage(// Inputs
                clock,
                reset,

                Imem2proc_data_in,
                Imem_valid_in,

                take_branch1_in,
                target_pc1_in,
                unconditional_branch1,
                conditional_branch1,

                take_branch2_in,
                target_pc2_in,
                unconditional_branch2,
                conditional_branch2,

                proc2Dmem_command,

                ROB_stall,
                RS_stall,
                LSQ_stall,

                // Outputs
                proc2Imem_addr_out,

                ROB_pc1,
                ROB_pc2,

                ROB_mispredict1,
                ROB_mispredict2,

                if_NPC1_out,
                if_PC1_out,
                if_IR1_out,
                if_valid_inst1_out,    // when low, instruction is garbage
                if_pred_addr1_out,
                if_prediction1,

                if_NPC2_out,
                if_PC2_out,
                if_IR2_out,
                if_valid_inst2_out,    // when low, instruction is garbage
                if_pred_addr2_out,
                if_prediction2
               );

input         clock;                  // system clock
input         reset;                  // system reset
input  [63:0] ROB_pc1;
input  [63:0] ROB_pc2;
input  [63:0] Imem2proc_data_in;      // Data coming back from instruction-memory
input         Imem_valid_in;

input         ROB_mispredict1;
input         ROB_mispredict2;

input         take_branch1_in;        // taken-branch signal
input  [63:0] target_pc1_in;          // target pc: use if take_branch is TRUE
input         unconditional_branch1;
input         conditional_branch1;

input         take_branch2_in;        // taken-branch signal
input  [63:0] target_pc2_in;          // target pc: use if take_branch is TRUE
input         unconditional_branch2;
input         conditional_branch2;

input   [1:0] proc2Dmem_command;

input         ROB_stall;
input         RS_stall;
input         LSQ_stall;

output [63:0] proc2Imem_addr_out;    // Address sent to Instruction memory

output [63:0] if_NPC1_out;            // PC of instruction after fetched (PC+4).
output [63:0] if_PC1_out;
output [31:0] if_IR1_out;             // fetched instruction
output        if_valid_inst1_out;
output [63:0] if_pred_addr1_out;
output        if_prediction1;

output [63:0] if_NPC2_out;            // PC of instruction after fetched (PC+4).
output [63:0] if_PC2_out;
output [31:0] if_IR2_out;             // fetched instruction
output        if_valid_inst2_out;
output [63:0] if_pred_addr2_out;
output        if_prediction2;

reg    [63:0] PC_reg;                 // PC we are currently fetching
wire   [63:0] PC_plus_4;
wire   [63:0] PC_plus_8;
wire   [63:0] PC_plus_12;
reg    [63:0] next_PC;
wire          PC_enable;
wire          valid_inst_from_mem;

wire          BTB_valid1;
wire   [63:0] BTB_target_address1;
wire          BTB_valid2;
wire   [63:0] BTB_target_address2;


btb btb0 (// input
          .clock(clock),
          .reset(reset),

          .valid_inst1_in(if_valid_inst1_out),
          .take_branch1_in(take_branch1_in),
          .target_pc1_in(target_pc1_in),
          .unconditional_branch1(unconditional_branch1),
          .conditional_branch1(conditional_branch1),

          .valid_inst2_in(if_valid_inst2_out),
          .take_branch2_in(take_branch2_in),
          .target_pc2_in(target_pc2_in),
          .unconditional_branch2(unconditional_branch2),
          .conditional_branch2(conditional_branch2),

          .ROB_pc1(ROB_pc1),
          .ROB_pc2(ROB_pc2),
 
          .current_pc1(if_PC1_out),
          .current_pc2(if_PC2_out),

          //outputs
          .valid1_out(BTB_valid1),
          .target_pc1_btb_out(BTB_target_address1),
 
          .valid2_out(BTB_valid2),
          .target_pc2_btb_out(BTB_target_address2)
         );

assign proc2Imem_addr_out = {PC_reg[63:3], 3'b0};

assign if_IR1_out = PC_reg[2] ? Imem2proc_data_in[63:32] : Imem2proc_data_in[31:0];
assign if_IR2_out = Imem2proc_data_in[63:32];

assign if_prediction1 = BTB_valid1;
assign if_prediction2 = BTB_valid2;

assign if_pred_addr1_out = BTB_valid1 ? BTB_target_address1 : 64'b0;
assign if_pred_addr2_out = BTB_valid2 ? BTB_target_address2 : 64'b0;

always @*
begin
   if (ROB_mispredict1 && take_branch1_in)
      next_PC = target_pc1_in;
   else if (ROB_mispredict2 && take_branch2_in)
      next_PC = target_pc2_in;
   else if (ROB_mispredict1 && !take_branch1_in)
      next_PC = ROB_pc1 + 4;
   else if (ROB_mispredict2 && !take_branch2_in)
      next_PC = ROB_pc2 + 4;
   else if(BTB_valid1)
      next_PC = BTB_target_address1;
   else if(BTB_valid2)
      next_PC = BTB_target_address2;
   else if(PC_reg[2])
      next_PC = PC_plus_4;
   else
      next_PC = PC_plus_8;
end
assign valid_inst_from_mem = Imem_valid_in & (proc2Dmem_command ==`BUS_NONE);
assign if_valid_inst1_out = ~PC_reg[2] & valid_inst_from_mem;
assign if_valid_inst2_out = (~BTB_valid1) & valid_inst_from_mem;

assign PC_plus_4  = PC_reg + 4;
assign PC_plus_8  = PC_reg + 8;
assign PC_plus_12 = PC_reg + 12;


assign PC_enable = (if_valid_inst1_out | if_valid_inst2_out) &
                    ~(ROB_stall | RS_stall | LSQ_stall) | (ROB_mispredict1 | ROB_mispredict2);

assign if_PC1_out  = if_valid_inst1_out ? PC_reg : 64'b0;
assign if_PC2_out  = if_valid_inst2_out ? (~if_valid_inst1_out ? PC_reg : PC_plus_4) : 64'b0;

assign if_NPC1_out = if_valid_inst1_out ? PC_plus_8 : 64'b0; 
assign if_NPC2_out = if_valid_inst2_out ? (~if_valid_inst1_out ? PC_plus_8 : PC_plus_12) : 64'b0;

always @(posedge clock)
begin
   if(reset)
      PC_reg <= `SD 0;       // initial PC value is 0
   else if(PC_enable)
      PC_reg <= `SD next_PC; // transition to next PC
end  // always

endmodule  // module if_stage
