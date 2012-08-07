/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  test_id.v                                           //
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

reg         clock;                // system clock
reg         reset;                // system reset

reg  [31:0] if_id_IR1;             // incoming instruction
reg         if_id_valid_inst1;

reg  [31:0] if_id_IR2;             // incoming instruction
reg         if_id_valid_inst2;

wire  [1:0] id_opa_select1_out;    // ALU opa mux select (ALU_OPA_xxx *)
wire  [1:0] id_opb_select1_out;    // ALU opb mux select (ALU_OPB_xxx *)
wire  [4:0] id_dest_reg_idx1_out;  // destination (writeback) register index
                                      // (ZERO_REG if no writeback)
wire  [4:0] id_alu_func1_out;      // ALU function select (ALU_xxx *)
wire        id_rd_mem1_out;        // does inst read memory?
wire        id_wr_mem1_out;        // does inst write memory?
wire        id_cond_branch1_out;   // is inst a conditional branch?
wire        id_uncond_branch1_out; // is inst an unconditional branch 
                                      // or jump?
wire        id_halt1_out;
wire        id_illegal1_out;
wire        id_valid_inst1_out;    // is inst a valid instruction to be 
                                      // counted for CPI calculations?

wire  [1:0] id_opa_select2_out;    // ALU opa mux select (ALU_OPA_xxx *)
wire  [1:0] id_opb_select2_out;    // ALU opb mux select (ALU_OPB_xxx *)
wire  [4:0] id_dest_reg_idx2_out;  // destination (writeback) register index
                                      // (ZERO_REG if no writeback)
wire  [4:0] id_alu_func2_out;      // ALU function select (ALU_xxx *)
wire        id_rd_mem2_out;        // does inst read memory?
wire        id_wr_mem2_out;        // does inst write memory?
wire        id_cond_branch2_out;   // is inst a conditional branch?
wire        id_uncond_branch2_out; // is inst an unconditional branch 
                                      // or jump?
wire        id_halt2_out;
wire        id_illegal2_out;
wire        id_valid_inst2_out;    // is inst a valid instruction to be

id_stage id_stage_test(
              // Inputs
              .clock(clock),
              .reset(reset),

              .if_id_IR1(if_id_IR1),
              .if_id_valid_inst1(if_id_valid_inst1),

              .if_id_IR2(if_id_IR2),
              .if_id_valid_inst2(if_id_valid_inst2),

              // Outputs
              .id_opa_select1_out(id_opa_select1_out),
              .id_opb_select1_out(id_opb_select1_out),
              .id_dest_reg_idx1_out(id_dest_reg_idx1_out),
              .id_alu_func1_out(id_alu_func1_out),
              .id_rd_mem1_out(id_rd_mem1_out),
              .id_wr_mem1_out(id_wr_mem1_out),
              .id_cond_branch1_out(id_cond_branch1_out),
              .id_uncond_branch1_out(id_uncond_branch1_out),
              .id_halt1_out(id_halt1_out),
              .id_illegal1_out(id_illegal1_out),
              .id_valid_inst1_out(id_valid_inst1_out),

              .id_opa_select2_out(id_opa_select2_out),
              .id_opb_select2_out(id_opb_select2_out),
              .id_dest_reg_idx2_out(id_dest_reg_idx2_out),
              .id_alu_func2_out(id_alu_func2_out),
              .id_rd_mem2_out(id_rd_mem2_out),
              .id_wr_mem2_out(id_wr_mem2_out),
              .id_cond_branch2_out(id_cond_branch2_out),
              .id_uncond_branch2_out(id_uncond_branch2_out),
              .id_halt2_out(id_halt2_out),
              .id_illegal2_out(id_illegal2_out),
              .id_valid_inst2_out(id_valid_inst2_out)
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
  $display("@@ 0) Post Reset:");
  $display("@@ INPUTS:\n@@ | if_id_IR1:     %b | if_id_valid_inst1:    %d |\n@@ | if_id_IR2:     %b | if_id_valid_inst2:    %d |\n@@\n@@ OUTPUTS:\n@@ | id_opa_select1_out: %d | id_opb_select1_out:   %d | id_dest_reg_idx1_out:%d |\n@@ | id_alu_func1_out:  %d | id_rd_mem1_out:       %d | id_wr_mem1_out:       %d |\n@@ | id_cond_branch1_out:%d | id_uncond_branch1_out:%d | id_halt1_out:         %d | id_illegal1_out:%d |\n@@ | id_valid_inst1_out: %d\n@@\n@@ | id_opa_select2_out: %d | id_opb_select2_out:   %d | id_dest_reg_idx2_out:%d |\n@@ | id_alu_func2_out:  %d | id_rd_mem2_out:       %d | id_wr_mem2_out:       %d |\n@@ | id_cond_branch2_out:%d | id_uncond_branch2_out:%d | id_halt2_out:         %d | id_illegal2_out:%d |\n@@ | id_valid_inst2_out: %d |\n", if_id_IR1, if_id_valid_inst1, if_id_IR2, if_id_valid_inst2, id_opa_select1_out, id_opb_select1_out, id_dest_reg_idx1_out, id_alu_func1_out, id_rd_mem1_out, id_wr_mem1_out, id_cond_branch1_out, id_uncond_branch1_out, id_halt1_out, id_illegal1_out, id_valid_inst1_out, id_opa_select2_out, id_opb_select2_out, id_dest_reg_idx2_out, id_alu_func2_out, id_rd_mem2_out, id_wr_mem2_out, id_cond_branch2_out, id_uncond_branch2_out, id_halt2_out, id_illegal2_out, id_valid_inst2_out);

  @(negedge clock);

  if_id_IR1 = `NOOP_INST;
  if_id_valid_inst1 = 1;

  if_id_IR2 = `NOOP_INST;
  if_id_valid_inst2 = 1;

  $display("@@ 1) In: NOOPs | Out: Nothing");
  $display("@@ INPUTS:\n@@ | if_id_IR1:     %b | if_id_valid_inst1:    %d |\n@@ | if_id_IR2:     %b | if_id_valid_inst2:    %d |\n@@\n@@ OUTPUTS:\n@@ | id_opa_select1_out: %d | id_opb_select1_out:   %d | id_dest_reg_idx1_out:%d |\n@@ | id_alu_func1_out:  %d | id_rd_mem1_out:       %d | id_wr_mem1_out:       %d |\n@@ | id_cond_branch1_out:%d | id_uncond_branch1_out:%d | id_halt1_out:         %d | id_illegal1_out:%d |\n@@ | id_valid_inst1_out: %d\n@@\n@@ | id_opa_select2_out: %d | id_opb_select2_out:   %d | id_dest_reg_idx2_out:%d |\n@@ | id_alu_func2_out:  %d | id_rd_mem2_out:       %d | id_wr_mem2_out:       %d |\n@@ | id_cond_branch2_out:%d | id_uncond_branch2_out:%d | id_halt2_out:         %d | id_illegal2_out:%d |\n@@ | id_valid_inst2_out: %d |\n", if_id_IR1, if_id_valid_inst1, if_id_IR2, if_id_valid_inst2, id_opa_select1_out, id_opb_select1_out, id_dest_reg_idx1_out, id_alu_func1_out, id_rd_mem1_out, id_wr_mem1_out, id_cond_branch1_out, id_uncond_branch1_out, id_halt1_out, id_illegal1_out, id_valid_inst1_out, id_opa_select2_out, id_opb_select2_out, id_dest_reg_idx2_out, id_alu_func2_out, id_rd_mem2_out, id_wr_mem2_out, id_cond_branch2_out, id_uncond_branch2_out, id_halt2_out, id_illegal2_out, id_valid_inst2_out);

  @(negedge clock);

  if_id_IR1 = 32'h4143040a;
  if_id_valid_inst1 = 1;

  if_id_IR2 = 32'h4c22040a;
  if_id_valid_inst2 = 1;

  $display("@@ 2) In: mulq    $r1,$r2,$r10, addq    $r10,$r3,$r10 | Out: NOOPs");
  $display("@@ INPUTS:\n@@ | if_id_IR1:     %b | if_id_valid_inst1:    %d |\n@@ | if_id_IR2:     %b | if_id_valid_inst2:    %d |\n@@\n@@ OUTPUTS:\n@@ | id_opa_select1_out: %d | id_opb_select1_out:   %d | id_dest_reg_idx1_out:%d |\n@@ | id_alu_func1_out:  %d | id_rd_mem1_out:       %d | id_wr_mem1_out:       %d |\n@@ | id_cond_branch1_out:%d | id_uncond_branch1_out:%d | id_halt1_out:         %d | id_illegal1_out:%d |\n@@ | id_valid_inst1_out: %d\n@@\n@@ | id_opa_select2_out: %d | id_opb_select2_out:   %d | id_dest_reg_idx2_out:%d |\n@@ | id_alu_func2_out:  %d | id_rd_mem2_out:       %d | id_wr_mem2_out:       %d |\n@@ | id_cond_branch2_out:%d | id_uncond_branch2_out:%d | id_halt2_out:         %d | id_illegal2_out:%d |\n@@ | id_valid_inst2_out: %d |\n", if_id_IR1, if_id_valid_inst1, if_id_IR2, if_id_valid_inst2, id_opa_select1_out, id_opb_select1_out, id_dest_reg_idx1_out, id_alu_func1_out, id_rd_mem1_out, id_wr_mem1_out, id_cond_branch1_out, id_uncond_branch1_out, id_halt1_out, id_illegal1_out, id_valid_inst1_out, id_opa_select2_out, id_opb_select2_out, id_dest_reg_idx2_out, id_alu_func2_out, id_rd_mem2_out, id_wr_mem2_out, id_cond_branch2_out, id_uncond_branch2_out, id_halt2_out, id_illegal2_out, id_valid_inst2_out);

  @(negedge clock);

  if_id_IR1 = 32'hb5400000;
  if_id_valid_inst1 = 1;

  if_id_IR2 = 32'ha61e0000;
  if_id_valid_inst2 = 1;

  $display("@@ 3) In: stq     $r10,0($r0), ldq	    $r16,0($r30) | Out: mulq    $r1,$r2,$r10, addq    $r10,$r3,$r10");
  $display("@@ INPUTS:\n@@ | if_id_IR1:     %b | if_id_valid_inst1:    %d |\n@@ | if_id_IR2:     %b | if_id_valid_inst2:    %d |\n@@\n@@ OUTPUTS:\n@@ | id_opa_select1_out: %d | id_opb_select1_out:   %d | id_dest_reg_idx1_out:%d |\n@@ | id_alu_func1_out:  %d | id_rd_mem1_out:       %d | id_wr_mem1_out:       %d |\n@@ | id_cond_branch1_out:%d | id_uncond_branch1_out:%d | id_halt1_out:         %d | id_illegal1_out:%d |\n@@ | id_valid_inst1_out: %d\n@@\n@@ | id_opa_select2_out: %d | id_opb_select2_out:   %d | id_dest_reg_idx2_out:%d |\n@@ | id_alu_func2_out:  %d | id_rd_mem2_out:       %d | id_wr_mem2_out:       %d |\n@@ | id_cond_branch2_out:%d | id_uncond_branch2_out:%d | id_halt2_out:         %d | id_illegal2_out:%d |\n@@ | id_valid_inst2_out: %d |\n", if_id_IR1, if_id_valid_inst1, if_id_IR2, if_id_valid_inst2, id_opa_select1_out, id_opb_select1_out, id_dest_reg_idx1_out, id_alu_func1_out, id_rd_mem1_out, id_wr_mem1_out, id_cond_branch1_out, id_uncond_branch1_out, id_halt1_out, id_illegal1_out, id_valid_inst1_out, id_opa_select2_out, id_opb_select2_out, id_dest_reg_idx2_out, id_alu_func2_out, id_rd_mem2_out, id_wr_mem2_out, id_cond_branch2_out, id_uncond_branch2_out, id_halt2_out, id_illegal2_out, id_valid_inst2_out);

  @(negedge clock);

  if_id_IR1 = `NOOP_INST;
  if_id_valid_inst1 = 0;

  if_id_IR2 = `NOOP_INST;
  if_id_valid_inst2 = 0;

  $display("@@ 3) In: Invalids | Out: stq     $r10,0($r0), ldq	    $r16,0($r30)");
  $display("@@ INPUTS:\n@@ | if_id_IR1:     %b | if_id_valid_inst1:    %d |\n@@ | if_id_IR2:     %b | if_id_valid_inst2:    %d |\n@@\n@@ OUTPUTS:\n@@ | id_opa_select1_out: %d | id_opb_select1_out:   %d | id_dest_reg_idx1_out:%d |\n@@ | id_alu_func1_out:  %d | id_rd_mem1_out:       %d | id_wr_mem1_out:       %d |\n@@ | id_cond_branch1_out:%d | id_uncond_branch1_out:%d | id_halt1_out:         %d | id_illegal1_out:%d |\n@@ | id_valid_inst1_out: %d\n@@\n@@ | id_opa_select2_out: %d | id_opb_select2_out:   %d | id_dest_reg_idx2_out:%d |\n@@ | id_alu_func2_out:  %d | id_rd_mem2_out:       %d | id_wr_mem2_out:       %d |\n@@ | id_cond_branch2_out:%d | id_uncond_branch2_out:%d | id_halt2_out:         %d | id_illegal2_out:%d |\n@@ | id_valid_inst2_out: %d |\n", if_id_IR1, if_id_valid_inst1, if_id_IR2, if_id_valid_inst2, id_opa_select1_out, id_opb_select1_out, id_dest_reg_idx1_out, id_alu_func1_out, id_rd_mem1_out, id_wr_mem1_out, id_cond_branch1_out, id_uncond_branch1_out, id_halt1_out, id_illegal1_out, id_valid_inst1_out, id_opa_select2_out, id_opb_select2_out, id_dest_reg_idx2_out, id_alu_func2_out, id_rd_mem2_out, id_wr_mem2_out, id_cond_branch2_out, id_uncond_branch2_out, id_halt2_out, id_illegal2_out, id_valid_inst2_out);

  $finish;

end
endmodule
