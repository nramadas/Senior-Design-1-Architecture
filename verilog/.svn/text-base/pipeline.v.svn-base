/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  pipeline.v                                          //
//                                                                     //
//  Description :  Top-level module of the verisimple pipeline;        //
//                 This instantiates and connects the 5 stages of the  //
//                 Verisimple pipeline.                                //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module pipeline (// Inputs
                 clock,
                 reset,
                 mem2proc_response,
                 mem2proc_data,
                 mem2proc_tag,
                 
                 cachemem_data,
                 cachemem_valid,

                 Dcachemem_data,
                 Dcachemem_valid,

                 // Outputs
                 proc2mem_command,
                 proc2mem_addr,
                 proc2mem_data,

                 Icache_rd_idx,
                 Icache_rd_tag,
                 Icache_wr_idx,
                 Icache_wr_tag,
                 Icache_wr_en,
                  

                 Dcache_rd_idx,
                 Dcache_rd_tag,
                 Dcache_wr_idx,
                 Dcache_wr_tag,
                 Dcache_wr_en,
                 Dcache_store_idx,
                 Dcache_store_tag,
                 Dcache_store_en,

                 pipeline_completed_insts,
                 pipeline_error_status,

                 pipeline_commit_wr_data1,
                 pipeline_commit_wr_idx1,
                 pipeline_commit_wr_en1,
                 pipeline_commit_NPC1,

                 pipeline_commit_wr_data2,
                 pipeline_commit_wr_idx2,
                 pipeline_commit_wr_en2,
                 pipeline_commit_NPC2,


                 // testing hooks (these must be exported so we can test
                 // the synthesized version) data is tested by looking at
                 // the final values in memory

                 if_NPC1_out,
                 if_PC1_out,
                 if_IR1_out,
                 if_valid_inst1_out,
                 if_id_NPC1,
                 if_id_PC1,
                 if_id_IR1,
                 if_id_valid_inst1,
                 id_ri_NPC1,
                 id_ri_PC1,
                 id_ri_IR1,
                 id_ri_valid_inst1,
                 ri_ooc_NPC1,
                 ri_ooc_PC1,
                 ri_ooc_IR1,
                 ri_ooc_valid_inst1,
                 ooc_NPC1_out,
                 ooc_ROB_valid1_out,
                 ooc_IR1_out,

                 if_NPC2_out,
                 if_PC2_out,
                 if_IR2_out,
                 if_valid_inst2_out,
                 if_id_NPC2,
                 if_id_PC2,
                 if_id_IR2,
                 if_id_valid_inst2,
                 id_ri_NPC2,
                 id_ri_PC2,
                 id_ri_IR2,
                 id_ri_valid_inst2,
                 ri_ooc_NPC2,
                 ri_ooc_PC2,
                 ri_ooc_IR2,
                 ri_ooc_valid_inst2,
                 ooc_NPC2_out,
                 ooc_ROB_valid2_out,
                 ooc_IR2_out
                );

  input         clock;             // System clock
  input         reset;             // System reset
  input  [3:0]  mem2proc_response; // Tag from memory about current request
  input  [63:0] mem2proc_data;     // Data coming back from memory
  input  [3:0]  mem2proc_tag;      // Tag from memory about current reply

  input  [63:0] cachemem_data;
  input		    cachemem_valid;

  input  [63:0] Dcachemem_data;
  input		    Dcachemem_valid;

  output [1:0]  proc2mem_command;  // command sent to memory
  output [63:0] proc2mem_addr;     // Address sent to memory
  output [63:0] proc2mem_data;     // Data sent to memory

  output  [6:0] Icache_rd_idx;
  output [21:0] Icache_rd_tag;
  output  [6:0] Icache_wr_idx;
  output [21:0] Icache_wr_tag;
  output	    Icache_wr_en;

  output  [6:0] Dcache_rd_idx;
  output [21:0] Dcache_rd_tag;
  output  [6:0] Dcache_wr_idx;
  output [21:0] Dcache_wr_tag;
  output        Dcache_wr_en;
  output  [6:0] Dcache_store_idx;
  output [21:0] Dcache_store_tag;
  output        Dcache_store_en;
  output [3:0]  pipeline_completed_insts;
  output [3:0]  pipeline_error_status;

  output [4:0]  pipeline_commit_wr_idx1;
  output [63:0] pipeline_commit_wr_data1;
  output        pipeline_commit_wr_en1;
  output [63:0] pipeline_commit_NPC1;

  output [4:0]  pipeline_commit_wr_idx2;
  output [63:0] pipeline_commit_wr_data2;
  output        pipeline_commit_wr_en2;
  output [63:0] pipeline_commit_NPC2;

  output [63:0] if_NPC1_out;
  output [63:0] if_PC1_out;
  output [31:0] if_IR1_out;
  output        if_valid_inst1_out;
  output [63:0] if_id_NPC1;
  output [63:0] if_id_PC1;
  output [31:0] if_id_IR1;
  output        if_id_valid_inst1;
  output [63:0] id_ri_NPC1;
  output [63:0] id_ri_PC1;
  output [31:0] id_ri_IR1;
  output        id_ri_valid_inst1;
  output [63:0] ri_ooc_NPC1;
  output [63:0] ri_ooc_PC1;
  output [31:0] ri_ooc_IR1;
  output        ri_ooc_valid_inst1;
  output [63:0] ooc_NPC1_out;
  output        ooc_ROB_valid1_out;
  output [31:0] ooc_IR1_out;

  output [63:0] if_NPC2_out;
  output [63:0] if_PC2_out;
  output [31:0] if_IR2_out;
  output        if_valid_inst2_out;
  output [63:0] if_id_NPC2;
  output [63:0] if_id_PC2;
  output [31:0] if_id_IR2;
  output        if_id_valid_inst2;
  output [63:0] id_ri_NPC2;
  output [63:0] id_ri_PC2;
  output [31:0] id_ri_IR2;
  output        id_ri_valid_inst2;
  output [63:0] ri_ooc_NPC2;
  output [63:0] ri_ooc_PC2;
  output [31:0] ri_ooc_IR2;
  output        ri_ooc_valid_inst2;
  output [63:0] ooc_NPC2_out;
  output        ooc_ROB_valid2_out;
  output [31:0] ooc_IR2_out;

  // Pipeline register enables
  wire   if_id_enable, id_ri_enable, ri_ooc_enable;

  // Outputs from IF-Stage
  wire [63:0] proc2Imem_addr_out;
  wire [63:0] if_NPC1_out;
  wire [63:0] if_PC1_out;
  wire [31:0] if_IR1_out;
  wire [63:0] if_pred_addr1_out;
  wire        if_prediction1;
  wire        if_valid_inst1_out;    // when low, instruction is garbage

  wire [63:0] if_NPC2_out;
  wire [63:0] if_PC2_out;
  wire [31:0] if_IR2_out;
  wire [63:0] if_pred_addr2_out;
  wire        if_prediction2;
  wire        if_valid_inst2_out;    // when low, instruction is garbage

  // Outputs from IF/ID Pipeline Register
  reg  [63:0] if_id_NPC1;
  reg  [63:0] if_id_PC1;
  reg  [31:0] if_id_IR1;
  reg  [63:0] if_id_pred_addr1;
  reg         if_id_prediction1;
  reg         if_id_valid_inst1;

  reg  [63:0] if_id_NPC2;
  reg  [63:0] if_id_PC2;
  reg  [31:0] if_id_IR2;
  reg  [63:0] if_id_pred_addr2;
  reg         if_id_prediction2;
  reg         if_id_valid_inst2;
   
  // Outputs from ID stage
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
  wire        id_valid_inst2_out;

  // Outputs from ID/RI Pipeline Register
  reg  [63:0] id_ri_NPC1;
  reg  [63:0] id_ri_PC1;
  reg  [31:0] id_ri_IR1;
  reg         id_ri_valid_inst1;
  reg  [63:0] id_ri_pred_addr1;
  reg         id_ri_prediction1;

  reg  [63:0] id_ri_NPC2;
  reg  [63:0] id_ri_PC2;
  reg  [31:0] id_ri_IR2;
  reg         id_ri_valid_inst2;
  reg  [63:0] id_ri_pred_addr2;
  reg         id_ri_prediction2;

  reg   [1:0] id_ri_opa_select1;
  reg   [1:0] id_ri_opb_select1;  
  reg   [4:0] id_ri_dest_reg_idx1;
                                 
  reg   [4:0] id_ri_alu_func1;   
  reg         id_ri_rd_mem1;   
  reg         id_ri_wr_mem1;      
  reg         id_ri_cond_branch1;
  reg         id_ri_uncond_branch1;
                                    
  reg         id_ri_halt1;
  reg         id_ri_illegal1;  
                                     
  reg   [1:0] id_ri_opa_select2;   
  reg   [1:0] id_ri_opb_select2;   
  reg   [4:0] id_ri_dest_reg_idx2;  
                                     
  reg   [4:0] id_ri_alu_func2;      
  reg         id_ri_rd_mem2;        
  reg         id_ri_wr_mem2;        
  reg         id_ri_cond_branch2;   
  reg         id_ri_uncond_branch2; 

  reg         id_ri_halt2;
  reg         id_ri_illegal2;

  // Outputs from RI stage
  wire  [6:0] ri_dest_PRN1_out;
  wire  [6:0] ri_dest_PRN1_old_out;
  wire [63:0] ri_opa1_out;
  wire  [6:0] ri_PRNa1_out;
  wire        ri_opa1_valid;
  wire [63:0] ri_opb1_out;
  wire  [6:0] ri_PRNb1_out;
  wire        ri_opb1_valid; 

  wire  [6:0] ri_dest_PRN2_out;
  wire  [6:0] ri_dest_PRN2_old_out;
  wire [63:0] ri_opa2_out;
  wire  [6:0] ri_PRNa2_out;
  wire        ri_opa2_valid;
  wire [63:0] ri_opb2_out;
  wire  [6:0] ri_PRNb2_out;
  wire        ri_opb2_valid;

  // Outputs from RI/OOC pipeline registers

  wire [63:0] cdb_to_prf_result1_0;
  wire [63:0] cdb_to_prf_result2_0;

  reg  [63:0] ri_ooc_NPC1;
  reg  [63:0] ri_ooc_PC1;
  reg  [31:0] ri_ooc_IR1;
  reg         ri_ooc_valid_inst1;
  reg  [63:0] ri_ooc_pred_addr1;
  reg  [63:0] ri_ooc_pred_addr2;
  reg         ri_ooc_prediction1;
  reg         ri_ooc_prediction2;

  reg  [63:0] ri_ooc_NPC2;
  reg  [63:0] ri_ooc_PC2;
  reg  [31:0] ri_ooc_IR2;
  reg         ri_ooc_valid_inst2;

  reg   [1:0] ri_ooc_opa_select1;
  reg   [1:0] ri_ooc_opb_select1;                                 
  reg   [4:0] ri_ooc_alu_func1;   
  reg         ri_ooc_rd_mem1;   
  reg         ri_ooc_wr_mem1;      
  reg         ri_ooc_cond_branch1;
  reg         ri_ooc_uncond_branch1;                                    
  reg         ri_ooc_halt1;
  reg         ri_ooc_illegal1;

  reg   [6:0] ri_ooc_dest_PRN1;
  reg   [6:0] ri_ooc_dest_old_PRN1;
  reg   [4:0] ri_ooc_dest_ARN1;
  reg  [63:0] ri_ooc_opa1;
  reg   [6:0] ri_ooc_PRNa1;
  reg         ri_ooc_opa1_valid;
  reg  [63:0] ri_ooc_opb1;
  reg   [6:0] ri_ooc_PRNb1;
  reg         ri_ooc_opb1_valid; 

  reg   [1:0] ri_ooc_opa_select2;
  reg   [1:0] ri_ooc_opb_select2;                                 
  reg   [4:0] ri_ooc_alu_func2;   
  reg         ri_ooc_rd_mem2;   
  reg         ri_ooc_wr_mem2;      
  reg         ri_ooc_cond_branch2;
  reg         ri_ooc_uncond_branch2;                                    
  reg         ri_ooc_halt2;
  reg         ri_ooc_illegal2;

  reg   [6:0] ri_ooc_dest_PRN2;
  reg   [6:0] ri_ooc_dest_old_PRN2;
  reg   [4:0] ri_ooc_dest_ARN2;
  reg  [63:0] ri_ooc_opa2;
  reg   [6:0] ri_ooc_PRNa2;
  reg         ri_ooc_opa2_valid;
  reg  [63:0] ri_ooc_opb2;
  reg   [6:0] ri_ooc_PRNb2;
  reg         ri_ooc_opb2_valid;

  // Outputs from OOC
  wire [63:0] cdb_to_prf_result1;
  wire  [6:0] cdb_to_prf_PRN1;
  wire        cdb_to_prf_valid1;
  wire        cdb1_take_branch;
  wire [63:0] cdb1_NPC;

  wire [63:0] cdb_to_prf_result2;
  wire  [6:0] cdb_to_prf_PRN2;
  wire        cdb_to_prf_valid2;
  wire        cdb2_take_branch;
  wire [63:0] cdb2_NPC;

  wire        rs_stall_out;
  wire        ROB_stall_out;
  wire        lsq_stall_out;

  wire  [6:0] ooc_ROB_to_RRAT_PRN1_out;
  wire  [4:0] ooc_ROB_to_RRAT_ARN1_out;
  wire  [6:0] ooc_ROB_to_PRF_PRN_old1_out;
  wire [63:0] ooc_ROB_to_fetch_target_addr1_out;
  wire        ooc_ROB_mis_predict1_out;
  wire        ooc_ROB_halt1_out;
  wire        ooc_ROB_valid1_out;
  wire [63:0] ooc_ROB_PC1_out;
  wire [63:0] ooc_NPC1_out;
  wire        ooc_valid_inst1_out;
  wire [31:0] ooc_IR1_out;
  wire        ooc_cond_br1_out;
  wire        ooc_uncond_br1_out;
  wire        ooc_br_taken1_out;

  wire  [6:0] ooc_ROB_to_RRAT_PRN2_out;
  wire  [4:0] ooc_ROB_to_RRAT_ARN2_out;
  wire  [6:0] ooc_ROB_to_PRF_PRN_old2_out;
  wire [63:0] ooc_ROB_to_fetch_target_addr2_out;
  wire        ooc_ROB_mis_predict2_out;
  wire        ooc_ROB_halt2_out;
  wire        ooc_ROB_valid2_out;
  wire [63:0] ooc_ROB_PC2_out;
  wire [63:0] ooc_NPC2_out;
  wire        ooc_valid_inst2_out;
  wire [31:0] ooc_IR2_out;
  wire        ooc_cond_br2_out;
  wire        ooc_uncond_br2_out;
  wire        ooc_br_taken2_out;

  wire [63:0] proc2Dmem_addr_out;
  // Memory interface/arbiter wires
  wire [63:0] proc2Dmem_addr, proc2Imem_addr;
  wire [1:0]  proc2Dmem_command, proc2Imem_command;
  wire [3:0]  Imem2proc_response, Dmem2proc_response;

  wire [63:0] Icache_data_out, proc2Icache_addr;
  wire        Icache_valid_out;
  wire [63:0] Dcache_data_out, proc2Dcache_addr;
  wire        Dcache_valid_out;
  wire [1:0]  proc2Dcache_command;
  wire [63:0] proc2Dcache_data;

  assign pipeline_completed_insts = (ooc_ROB_valid1_out && ooc_ROB_valid2_out) ?
            4'd2 : {3'b0, ooc_ROB_valid1_out};

  assign pipeline_error_status = 1'b0 ? `HALTED_ON_ILLEGAL : 
            (ooc_ROB_halt1_out || ooc_ROB_halt2_out) ? `HALTED_ON_HALT: `NO_ERROR;

  assign pipeline_commit_wr_idx1 = ooc_ROB_to_RRAT_ARN1_out;
  assign pipeline_commit_wr_data1 = cdb_to_prf_result1;
         //rename_issue_0.p0.registers[ooc_ROB_to_RRAT_PRN1_out];
  assign pipeline_commit_wr_en1 = ooc_ROB_valid1_out && (ooc_ROB_to_RRAT_ARN1_out!=`ZERO_REG);
  assign pipeline_commit_NPC1 = ooc_ROB_PC1_out;

  assign pipeline_commit_wr_idx2 = ooc_ROB_to_RRAT_ARN2_out;
  assign pipeline_commit_wr_data2 = cdb_to_prf_result2;
         //rename_issue_0.p0.registers[ooc_ROB_to_RRAT_PRN2_out];
  assign pipeline_commit_wr_en2 = ooc_ROB_valid2_out && (ooc_ROB_to_RRAT_ARN2_out!=`ZERO_REG);
  assign pipeline_commit_NPC2 = ooc_ROB_PC2_out;

  
  assign proc2mem_command =
           (proc2Dmem_command==`BUS_NONE)?proc2Imem_command:proc2Dmem_command;
  assign proc2mem_addr =
           (proc2Dmem_command==`BUS_NONE)?proc2Imem_addr:proc2Dmem_addr;
  assign Dmem2proc_response = 
      (proc2Dmem_command==`BUS_NONE) ? 0 : mem2proc_response;
  assign Imem2proc_response =
      (proc2Dmem_command==`BUS_NONE) ? mem2proc_response : 0;




  icache icache_0(// inputs 
                  .clock(clock),
                  .reset(reset),

                  .Imem2proc_response(Imem2proc_response),
                  .Imem2proc_data(mem2proc_data),
                  .Imem2proc_tag(mem2proc_tag),

                  .proc2Icache_addr(proc2Icache_addr),
                  .cachemem_data(cachemem_data),
                  .cachemem_valid(cachemem_valid),
                  .mispredict(ooc_ROB_mis_predict1_out || ooc_ROB_mis_predict2_out),

                   // outputs
                  .proc2Imem_command(proc2Imem_command),
                  .proc2Imem_addr(proc2Imem_addr),

                  .Icache_data_out(Icache_data_out),
                  .Icache_valid_out(Icache_valid_out),
                  .current_index(Icache_rd_idx),
                  .current_tag(Icache_rd_tag),
                  .last_index(Icache_wr_idx),
                  .last_tag(Icache_wr_tag),
                  .data_write_enable(Icache_wr_en)
                 );

  dcache dcache_0(// inputs 
                  .clock(clock),
                  .reset(reset),
                  .dmem2proc_response(Dmem2proc_response),
                  .dmem2proc_data(mem2proc_data),
                  .dmem2proc_tag(mem2proc_tag),

                  .proc2dcache_addr(proc2Dcache_addr),
                  .proc2dcache_command(proc2Dcache_command),
                  .proc2dcache_data(proc2Dcache_data),

                  .dcachemem_data(Dcachemem_data),
                  .dcachemem_valid(Dcachemem_valid),
 
                   //outputs
                  .proc2dmem_command(proc2Dmem_command),
                  .proc2dmem_addr(proc2Dmem_addr),
                  .proc2dmem_data(proc2mem_data),
                  
                  //ouptuts to processor
                  .dcache_data_out(Dcache_data_out),     // value is memory[proc2dcache_addr]
                  .dcache_valid_out(Dcache_valid_out),    // when this is high

 
                  .current_index(Dcache_rd_idx),
                  .current_tag(Dcache_rd_tag),
                  .last_index(Dcache_wr_idx),
                  .last_tag(Dcache_wr_tag),
                  .store_index(Dcache_store_idx),
                  .store_tag(Dcache_store_tag),
                  .store_write_enable(Dcache_store_en),
                  .data_write_enable(Dcache_wr_en)
                 );


  //////////////////////////////////////////////////
  //                                              //
  //                  IF-Stage                    //
  //                                              //
  //////////////////////////////////////////////////
  if_stage if_stage_0 (// Inputs
                       .clock (clock),
                       .reset (reset),

                       .Imem2proc_data_in(Icache_data_out),
                       .Imem_valid_in(Icache_valid_out),

                       .take_branch1_in(ooc_br_taken1_out),
                       .target_pc1_in(ooc_ROB_to_fetch_target_addr1_out),
                       .unconditional_branch1(ooc_uncond_br1_out),
                       .conditional_branch1(ooc_cond_br1_out),

                       .take_branch2_in(ooc_br_taken2_out),
                       .target_pc2_in(ooc_ROB_to_fetch_target_addr2_out),
                       .unconditional_branch2(ooc_uncond_br2_out),
                       .conditional_branch2(ooc_cond_br2_out),

                       .ROB_pc1(ooc_ROB_PC1_out),
                       .ROB_pc2(ooc_ROB_PC2_out),

                       .ROB_mispredict1(ooc_ROB_mis_predict1_out),
                       .ROB_mispredict2(ooc_ROB_mis_predict2_out),

                       .ROB_stall(ROB_stall_out),
                       .RS_stall(rs_stall_out),
                       .LSQ_stall(lsq_stall_out),

                       .proc2Dmem_command(proc2Dmem_command),

                       // Outputs
                       .if_NPC1_out(if_NPC1_out),
                       .if_PC1_out(if_PC1_out),
                       .if_IR1_out(if_IR1_out),
                       .if_valid_inst1_out(if_valid_inst1_out),
                       .if_pred_addr1_out(if_pred_addr1_out),
                       .if_prediction1(if_prediction1),

                       .if_NPC2_out(if_NPC2_out),
                       .if_PC2_out(if_PC2_out),
                       .if_IR2_out(if_IR2_out),
                       .if_valid_inst2_out(if_valid_inst2_out),
                       .if_pred_addr2_out(if_pred_addr2_out),
                       .if_prediction2(if_prediction2),

                       .proc2Imem_addr_out(proc2Icache_addr)
                      );


  //////////////////////////////////////////////////
  //                                              //
  //            IF/ID Pipeline Register           //
  //                                              //
  //////////////////////////////////////////////////
  assign if_id_enable = ~(ROB_stall_out | rs_stall_out | lsq_stall_out);
  always @(posedge clock)
  begin
    if(reset)
    begin
      if_id_NPC1          <= `SD 0;
      if_id_PC1           <= `SD 0;
      if_id_IR1           <= `SD `NOOP_INST;
      if_id_valid_inst1   <= `SD `FALSE;

      if_id_pred_addr1    <= `SD 0;
      if_id_pred_addr2    <= `SD 0;

      if_id_prediction1   <= `SD 0;
      if_id_prediction2   <= `SD 0;

      if_id_NPC2          <= `SD 0;
      if_id_PC2           <= `SD 0;
      if_id_IR2           <= `SD `NOOP_INST;
      if_id_valid_inst2   <= `SD `FALSE;
    end // if (reset)
    else if (ooc_ROB_mis_predict1_out || ooc_ROB_mis_predict2_out)
    begin
      if_id_NPC1          <= `SD 0;
      if_id_PC1           <= `SD 0;
      if_id_IR1           <= `SD `NOOP_INST;
      if_id_valid_inst1   <= `SD `FALSE;

      if_id_pred_addr1    <= `SD 0;
      if_id_pred_addr2    <= `SD 0;

      if_id_prediction1   <= `SD 0;
      if_id_prediction2   <= `SD 0;

      if_id_NPC2          <= `SD 0;
      if_id_PC2           <= `SD 0;
      if_id_IR2           <= `SD `NOOP_INST;
      if_id_valid_inst2   <= `SD `FALSE;
    end // if (reset)
    else if (if_id_enable)
      begin
        if_id_NPC1        <= `SD if_NPC1_out;
        if_id_PC1         <= `SD if_PC1_out;
        if_id_IR1         <= `SD if_IR1_out;
        if_id_valid_inst1 <= `SD if_valid_inst1_out;

        if_id_pred_addr1    <= `SD if_pred_addr1_out;
        if_id_pred_addr2    <= `SD if_pred_addr2_out;

        if_id_prediction1 <= `SD if_prediction1;
        if_id_prediction2 <= `SD if_prediction2;

        if_id_NPC2        <= `SD if_NPC2_out;
        if_id_PC2         <= `SD if_PC2_out;
        if_id_IR2         <= `SD if_IR2_out;
        if_id_valid_inst2 <= `SD if_valid_inst2_out;
      end // if (if_id_enable)
  end // always

   
  //////////////////////////////////////////////////
  //                                              //
  //                  ID-Stage                    //
  //                                              //
  //////////////////////////////////////////////////
  id_stage id_stage_0 (// Inputs
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

  //////////////////////////////////////////////////
  //                                              //
  //            ID/RI Pipeline Register           //
  //                                              //
  //////////////////////////////////////////////////
  assign id_ri_enable = ~(ROB_stall_out | rs_stall_out | lsq_stall_out); // always enabled
  always @(posedge clock)
  begin
    if (reset)
    begin
      id_ri_NPC1           <= `SD 0;
      id_ri_PC1            <= `SD 0;
      id_ri_IR1            <= `SD `NOOP_INST;
      id_ri_valid_inst1    <= `SD `FALSE;

      id_ri_pred_addr1     <= `SD 0;
      id_ri_pred_addr2     <= `SD 0;

      id_ri_prediction1    <= `SD 0;
      id_ri_prediction2    <= `SD 0;

      id_ri_NPC2           <= `SD 0;
      id_ri_PC2            <= `SD 0;
      id_ri_IR2            <= `SD `NOOP_INST;
      id_ri_valid_inst2    <= `SD `FALSE;

      id_ri_opa_select1    <= `SD `ALU_OPA_IS_REGA;
      id_ri_opb_select1    <= `SD `ALU_OPB_IS_REGB;
      id_ri_dest_reg_idx1  <= `SD `ZERO_REG;
      id_ri_alu_func1      <= `SD 0;
      id_ri_rd_mem1        <= `SD 0;
      id_ri_wr_mem1        <= `SD 0;
      id_ri_cond_branch1   <= `SD 0;
      id_ri_uncond_branch1 <= `SD 0;
      id_ri_halt1          <= `SD 0;
      id_ri_illegal1       <= `SD 0;
      id_ri_valid_inst1    <= `SD 0;
      id_ri_prediction1    <= `SD 0;
      id_ri_prediction2    <= `SD 0;

      id_ri_opa_select2    <= `SD `ALU_OPA_IS_REGA;
      id_ri_opb_select2    <= `SD `ALU_OPB_IS_REGB;
      id_ri_dest_reg_idx2  <= `SD `ZERO_REG;
      id_ri_alu_func2      <= `SD 0;
      id_ri_rd_mem2        <= `SD 0;
      id_ri_wr_mem2        <= `SD 0;
      id_ri_cond_branch2   <= `SD 0;
      id_ri_uncond_branch2 <= `SD 0;
      id_ri_halt2          <= `SD 0;
      id_ri_illegal2       <= `SD 0;
      id_ri_valid_inst2    <= `SD 0;
    end // if (reset)
    else if (ooc_ROB_mis_predict1_out || ooc_ROB_mis_predict2_out)
    begin
      id_ri_NPC1           <= `SD 0;
      id_ri_PC1            <= `SD 0;
      id_ri_IR1            <= `SD `NOOP_INST;
      id_ri_valid_inst1    <= `SD `FALSE;

      id_ri_pred_addr1     <= `SD 0;
      id_ri_pred_addr2     <= `SD 0;

      id_ri_prediction1    <= `SD 0;
      id_ri_prediction2    <= `SD 0;

      id_ri_NPC2           <= `SD 0;
      id_ri_PC2            <= `SD 0;
      id_ri_IR2            <= `SD `NOOP_INST;
      id_ri_valid_inst2    <= `SD `FALSE;

      id_ri_opa_select1    <= `SD `ALU_OPA_IS_REGA;
      id_ri_opb_select1    <= `SD `ALU_OPB_IS_REGB;
      id_ri_dest_reg_idx1  <= `SD `ZERO_REG;
      id_ri_alu_func1      <= `SD 0;
      id_ri_rd_mem1        <= `SD 0;
      id_ri_wr_mem1        <= `SD 0;
      id_ri_cond_branch1   <= `SD 0;
      id_ri_uncond_branch1 <= `SD 0;
      id_ri_halt1          <= `SD 0;
      id_ri_illegal1       <= `SD 0;
      id_ri_valid_inst1    <= `SD 0;

      id_ri_opa_select2    <= `SD `ALU_OPA_IS_REGA;
      id_ri_opb_select2    <= `SD `ALU_OPB_IS_REGB;
      id_ri_dest_reg_idx2  <= `SD `ZERO_REG;
      id_ri_alu_func2      <= `SD 0;
      id_ri_rd_mem2        <= `SD 0;
      id_ri_wr_mem2        <= `SD 0;
      id_ri_cond_branch2   <= `SD 0;
      id_ri_uncond_branch2 <= `SD 0;
      id_ri_halt2          <= `SD 0;
      id_ri_illegal2       <= `SD 0;
      id_ri_valid_inst2    <= `SD 0;
    end // if (reset)
    else
    begin
      if (id_ri_enable)
      begin
        id_ri_NPC1           <= `SD if_id_NPC1;
        id_ri_PC1            <= `SD if_id_PC1;
        id_ri_IR1            <= `SD if_id_IR1;

        id_ri_pred_addr1     <= `SD if_id_pred_addr1;
        id_ri_pred_addr2     <= `SD if_id_pred_addr2;

        id_ri_prediction1    <= `SD if_id_prediction1;
        id_ri_prediction2    <= `SD if_id_prediction2;

        id_ri_NPC2           <= `SD if_id_NPC2;
        id_ri_PC2            <= `SD if_id_PC2;
        id_ri_IR2            <= `SD if_id_IR2;

        id_ri_opa_select1    <= `SD id_opa_select1_out;
        id_ri_opb_select1    <= `SD id_opb_select1_out;
        id_ri_dest_reg_idx1  <= `SD id_dest_reg_idx1_out;
        id_ri_alu_func1      <= `SD id_alu_func1_out;
        id_ri_rd_mem1        <= `SD id_rd_mem1_out;
        id_ri_wr_mem1        <= `SD id_wr_mem1_out;
        id_ri_cond_branch1   <= `SD id_cond_branch1_out;
        id_ri_uncond_branch1 <= `SD id_uncond_branch1_out;
        id_ri_halt1          <= `SD id_halt1_out;
        id_ri_illegal1       <= `SD id_illegal1_out;
        id_ri_valid_inst1    <= `SD id_valid_inst1_out;

        id_ri_opa_select2    <= `SD id_opa_select2_out;
        id_ri_opb_select2    <= `SD id_opb_select2_out;
        id_ri_dest_reg_idx2  <= `SD id_dest_reg_idx2_out;
        id_ri_alu_func2      <= `SD id_alu_func2_out;
        id_ri_rd_mem2        <= `SD id_rd_mem2_out;
        id_ri_wr_mem2        <= `SD id_wr_mem2_out;
        id_ri_cond_branch2   <= `SD id_cond_branch2_out;
        id_ri_uncond_branch2 <= `SD id_uncond_branch2_out;
        id_ri_halt2          <= `SD id_halt2_out;
        id_ri_illegal2       <= `SD id_illegal2_out;
        id_ri_valid_inst2    <= `SD id_valid_inst2_out;
      end // if
    end // else: !if(reset)
  end // always


  //////////////////////////////////////////////////
  //                                              //
  //                  RI-Stage                    //
  //                                              //
  //////////////////////////////////////////////////
  rename_issue rename_issue_0(
                       // inputs
                       .clock(clock),
                       .reset(reset),

                       .rename_opa_select1(id_ri_opa_select1),
                       .rename_opb_select1(id_ri_opb_select1),
                       .rename_opa_select2(id_ri_opa_select2),
                       .rename_opb_select2(id_ri_opb_select2),


                       .id_rename_IR1(id_ri_IR1),
                       .id_rename_IR2(id_ri_IR2),
                       .rename_dest_reg_idx_in1(id_ri_dest_reg_idx1),
                       .rename_dest_reg_idx_in2(id_ri_dest_reg_idx2),
                       .rename_valid_IR1(id_ri_valid_inst1 & ~ROB_stall_out & ~rs_stall_out & ~lsq_stall_out),
                       .rename_valid_IR2(id_ri_valid_inst2 & ~ROB_stall_out & ~rs_stall_out & ~lsq_stall_out),
                       .wr_mem1(id_ri_wr_mem1),
                       .wr_mem2(id_ri_wr_mem2),
                       .cond_branch1(id_ri_cond_branch1),
                       .cond_branch2(id_ri_cond_branch2),

                       // commit inputs to update PRF Valid Bit(s) for the free register(s),
                       // RRAT and Both Free Lists
                       .ROB_to_RRAT_PRN1_in(ooc_ROB_to_RRAT_PRN1_out),
                       .ROB_to_RRAT_ARN1_in(ooc_ROB_to_RRAT_ARN1_out),
                       .ROB_to_PRF_PRN_old1_in(ooc_ROB_to_PRF_PRN_old1_out),
                       .ROB_to_RRAT_PRN2_in(ooc_ROB_to_RRAT_PRN2_out),
                       .ROB_to_RRAT_ARN2_in(ooc_ROB_to_RRAT_ARN2_out),
                       .ROB_to_PRF_PRN_old2_in(ooc_ROB_to_PRF_PRN_old2_out),
                       .ROB_valid1_in(ooc_ROB_valid1_out),
                       .ROB_valid2_in(ooc_ROB_valid2_out),

                       // ships passing in the night + executed instruction to update PRF      
                       .rename_cdb1_in1(cdb_to_prf_result1),
                       .rename_cdb1_tag(cdb_to_prf_PRN1),
                       .rename_cdb1_valid(cdb_to_prf_valid1),
                       .rename_cdb1_take_branch(cdb1_take_branch),
                       .rename_cdb1_NPC(cdb1_NPC),
                       .rename_cdb2_take_branch(cdb2_take_branch),
                       .rename_cdb2_NPC(cdb2_NPC),
                       .rename_cdb2_in1(cdb_to_prf_result2),
                       .rename_cdb2_tag(cdb_to_prf_PRN2),
                       .rename_cdb2_valid(cdb_to_prf_valid2),

                       // if branch misprediction
                       .copy1(ooc_ROB_mis_predict1_out),
                       .copy2(ooc_ROB_mis_predict2_out),

                       //outputs to Rename/Out of Order Pipeline Register for issue
                       .rename_dest_PRN1_out(ri_dest_PRN1_out),
                       .rename_dest_PRN1_old_out(ri_dest_PRN1_old_out),
                       .rename_opa1_out(ri_opa1_out),
                       .rename_PRNa1_out(ri_PRNa1_out),
                       .rename_opa1_valid(ri_opa1_valid),
                       .rename_opb1_out(ri_opb1_out),
                       .rename_PRNb1_out(ri_PRNb1_out),
                       .rename_opb1_valid(ri_opb1_valid), 

                       .rename_dest_PRN2_out(ri_dest_PRN2_out),
                       .rename_dest_PRN2_old_out(ri_dest_PRN2_old_out),
                       .rename_opa2_out(ri_opa2_out),
                       .rename_PRNa2_out(ri_PRNa2_out),
                       .rename_opa2_valid(ri_opa2_valid),
                       .rename_opb2_out(ri_opb2_out),
                       .rename_PRNb2_out(ri_PRNb2_out),
                       .rename_opb2_valid(ri_opb2_valid)
                      );


  //////////////////////////////////////////////////
  //                                              //
  //           RI/OOC Pipeline Register           //
  //                                              //
  //////////////////////////////////////////////////

  assign cdb_to_prf_result1_0 = (cdb1_take_branch && cdb_to_prf_valid1) ? cdb1_NPC : cdb_to_prf_result1;
  assign cdb_to_prf_result2_0 = (cdb2_take_branch && cdb_to_prf_valid2) ? cdb2_NPC : cdb_to_prf_result2;

  assign ri_ooc_enable = ~(ROB_stall_out | rs_stall_out | lsq_stall_out);
  always @(posedge clock)
  begin
    if (reset)
    begin
      ri_ooc_NPC1           <= `SD 0;
      ri_ooc_PC1            <= `SD 0;
      ri_ooc_IR1            <= `SD `NOOP_INST;
      ri_ooc_valid_inst1    <= `SD `FALSE;

      ri_ooc_pred_addr1     <= `SD 0;
      ri_ooc_pred_addr2     <= `SD 0;

      ri_ooc_prediction1    <= `SD 0;
      ri_ooc_prediction2    <= `SD 0;

      ri_ooc_NPC2           <= `SD 0;
      ri_ooc_PC2            <= `SD 0;
      ri_ooc_IR2            <= `SD `NOOP_INST;
      ri_ooc_valid_inst2    <= `SD `FALSE;

      ri_ooc_opa_select1    <= `SD `ALU_OPA_IS_REGA;
      ri_ooc_opb_select1    <= `SD `ALU_OPB_IS_REGB;
      ri_ooc_alu_func1      <= `SD 0;   
      ri_ooc_rd_mem1        <= `SD 0;   
      ri_ooc_wr_mem1        <= `SD 0;
      ri_ooc_cond_branch1   <= `SD 0;
      ri_ooc_uncond_branch1 <= `SD 0;
      ri_ooc_halt1          <= `SD 0;
      ri_ooc_illegal1       <= `SD 0;

      ri_ooc_dest_PRN1      <= `SD 0;
      ri_ooc_dest_old_PRN1  <= `SD 0;
      ri_ooc_dest_ARN1      <= `SD 0;
      ri_ooc_opa1           <= `SD 0;
      ri_ooc_PRNa1          <= `SD 0;
      ri_ooc_opa1_valid     <= `SD 0;
      ri_ooc_opb1           <= `SD 0;
      ri_ooc_PRNb1          <= `SD 0;
      ri_ooc_opb1_valid     <= `SD 0; 

      ri_ooc_opa_select2    <= `SD `ALU_OPA_IS_REGA;
      ri_ooc_opb_select2    <= `SD `ALU_OPB_IS_REGB;
      ri_ooc_alu_func2      <= `SD 0;
      ri_ooc_rd_mem2        <= `SD 0;
      ri_ooc_wr_mem2        <= `SD 0;
      ri_ooc_cond_branch2   <= `SD 0;
      ri_ooc_uncond_branch2 <= `SD 0;
      ri_ooc_halt2          <= `SD 0;
      ri_ooc_illegal2       <= `SD 0;

      ri_ooc_dest_PRN2      <= `SD 0;
      ri_ooc_dest_old_PRN2  <= `SD 0;
      ri_ooc_dest_ARN2      <= `SD 0;
      ri_ooc_opa2           <= `SD 0;
      ri_ooc_PRNa2          <= `SD 0;
      ri_ooc_opa2_valid     <= `SD 0;
      ri_ooc_opb2           <= `SD 0;
      ri_ooc_PRNb2          <= `SD 0;
      ri_ooc_opb2_valid     <= `SD 0;
    end
    else if (ooc_ROB_mis_predict1_out || ooc_ROB_mis_predict2_out)
    begin
      ri_ooc_NPC1           <= `SD 0;
      ri_ooc_PC1            <= `SD 0;
      ri_ooc_IR1            <= `SD `NOOP_INST;
      ri_ooc_valid_inst1    <= `SD `FALSE;

      ri_ooc_pred_addr1     <= `SD 0;
      ri_ooc_pred_addr2     <= `SD 0;

      ri_ooc_prediction1    <= `SD 0;
      ri_ooc_prediction2    <= `SD 0;

      ri_ooc_NPC2           <= `SD 0;
      ri_ooc_PC2            <= `SD 0;
      ri_ooc_IR2            <= `SD `NOOP_INST;
      ri_ooc_valid_inst2    <= `SD `FALSE;

      ri_ooc_opa_select1    <= `SD `ALU_OPA_IS_REGA;
      ri_ooc_opb_select1    <= `SD `ALU_OPB_IS_REGB;
      ri_ooc_alu_func1      <= `SD 0;   
      ri_ooc_rd_mem1        <= `SD 0;   
      ri_ooc_wr_mem1        <= `SD 0;
      ri_ooc_cond_branch1   <= `SD 0;
      ri_ooc_uncond_branch1 <= `SD 0;
      ri_ooc_halt1          <= `SD 0;
      ri_ooc_illegal1       <= `SD 0;

      ri_ooc_dest_PRN1      <= `SD 0;
      ri_ooc_dest_old_PRN1  <= `SD 0;
      ri_ooc_dest_ARN1      <= `SD 0;
      ri_ooc_opa1           <= `SD 0;
      ri_ooc_PRNa1          <= `SD 0;
      ri_ooc_opa1_valid     <= `SD 0;
      ri_ooc_opb1           <= `SD 0;
      ri_ooc_PRNb1          <= `SD 0;
      ri_ooc_opb1_valid     <= `SD 0; 

      ri_ooc_opa_select2    <= `SD `ALU_OPA_IS_REGA;
      ri_ooc_opb_select2    <= `SD `ALU_OPB_IS_REGB;
      ri_ooc_alu_func2      <= `SD 0;
      ri_ooc_rd_mem2        <= `SD 0;
      ri_ooc_wr_mem2        <= `SD 0;
      ri_ooc_cond_branch2   <= `SD 0;
      ri_ooc_uncond_branch2 <= `SD 0;
      ri_ooc_halt2          <= `SD 0;
      ri_ooc_illegal2       <= `SD 0;

      ri_ooc_dest_PRN2      <= `SD 0;
      ri_ooc_dest_old_PRN2  <= `SD 0;
      ri_ooc_dest_ARN2      <= `SD 0;
      ri_ooc_opa2           <= `SD 0;
      ri_ooc_PRNa2          <= `SD 0;
      ri_ooc_opa2_valid     <= `SD 0;
      ri_ooc_opb2           <= `SD 0;
      ri_ooc_PRNb2          <= `SD 0;
      ri_ooc_opb2_valid     <= `SD 0;
    end
    else
    begin
      if (ri_ooc_enable)
      begin
        ri_ooc_NPC1           <= `SD id_ri_NPC1;
        ri_ooc_PC1            <= `SD id_ri_PC1;
        ri_ooc_IR1            <= `SD id_ri_IR1;

        ri_ooc_pred_addr1     <= `SD id_ri_pred_addr1;
        ri_ooc_pred_addr2     <= `SD id_ri_pred_addr2;

        ri_ooc_valid_inst1    <= `SD id_ri_valid_inst1;
        ri_ooc_prediction1    <= `SD id_ri_prediction1;
        ri_ooc_prediction2    <= `SD id_ri_prediction2;

        ri_ooc_NPC2           <= `SD id_ri_NPC2;
        ri_ooc_PC2            <= `SD id_ri_PC2;
        ri_ooc_IR2            <= `SD id_ri_IR2;
        ri_ooc_valid_inst2    <= `SD id_ri_valid_inst2;

        ri_ooc_opa_select1    <= `SD id_ri_opa_select1;
        ri_ooc_opb_select1    <= `SD id_ri_opb_select1;
        ri_ooc_alu_func1      <= `SD id_ri_alu_func1;
        ri_ooc_rd_mem1        <= `SD id_ri_rd_mem1;
        ri_ooc_wr_mem1        <= `SD id_ri_wr_mem1;
        ri_ooc_cond_branch1   <= `SD id_ri_cond_branch1;
        ri_ooc_uncond_branch1 <= `SD id_ri_uncond_branch1;
        ri_ooc_halt1          <= `SD id_ri_halt1;
        ri_ooc_illegal1       <= `SD id_ri_illegal1;

        ri_ooc_dest_PRN1      <= `SD ri_dest_PRN1_out;
        ri_ooc_dest_old_PRN1  <= `SD ri_dest_PRN1_old_out;
        ri_ooc_dest_ARN1      <= `SD id_ri_dest_reg_idx1;
        ri_ooc_opa1           <= `SD ri_opa1_out;
        ri_ooc_PRNa1          <= `SD ri_PRNa1_out;
        ri_ooc_opa1_valid     <= `SD ri_opa1_valid;
        ri_ooc_opb1           <= `SD ri_opb1_out;
        ri_ooc_PRNb1          <= `SD ri_PRNb1_out;
        ri_ooc_opb1_valid     <= `SD ri_opb1_valid;

        ri_ooc_opa_select2    <= `SD id_ri_opa_select2;
        ri_ooc_opb_select2    <= `SD id_ri_opb_select2;
        ri_ooc_alu_func2      <= `SD id_ri_alu_func2;
        ri_ooc_rd_mem2        <= `SD id_ri_rd_mem2;
        ri_ooc_wr_mem2        <= `SD id_ri_wr_mem2;
        ri_ooc_cond_branch2   <= `SD id_ri_cond_branch2;
        ri_ooc_uncond_branch2 <= `SD id_ri_uncond_branch2;
        ri_ooc_halt2          <= `SD id_ri_halt2;
        ri_ooc_illegal2       <= `SD id_ri_illegal2;

        ri_ooc_dest_PRN2      <= `SD ri_dest_PRN2_out;
        ri_ooc_dest_old_PRN2  <= `SD ri_dest_PRN2_old_out;
        ri_ooc_dest_ARN2      <= `SD id_ri_dest_reg_idx2;
        ri_ooc_opa2           <= `SD ri_opa2_out;
        ri_ooc_PRNa2          <= `SD ri_PRNa2_out;
        ri_ooc_opa2_valid     <= `SD ri_opa2_valid;
        ri_ooc_opb2           <= `SD ri_opb2_out;
        ri_ooc_PRNb2          <= `SD ri_PRNb2_out;
        ri_ooc_opb2_valid     <= `SD ri_opb2_valid;
      end // if
      else
      begin
        if(ri_ooc_PRNa1==cdb_to_prf_PRN1 && (cdb_to_prf_PRN1 != 7'd31))
        begin
          ri_ooc_opa1 <= `SD cdb_to_prf_result1_0;
          ri_ooc_opa1_valid <= `SD 1'b1;
        end
        else if(ri_ooc_PRNa1==cdb_to_prf_PRN2 && (cdb_to_prf_PRN2 != 7'd31))
        begin
          ri_ooc_opa1 <= `SD cdb_to_prf_result2_0;
          ri_ooc_opa1_valid <= `SD 1'b1;
        end

        if(ri_ooc_PRNb1==cdb_to_prf_PRN1 && (cdb_to_prf_PRN1 != 7'd31))
        begin
          ri_ooc_opb1 <= `SD cdb_to_prf_result1_0;
          ri_ooc_opb1_valid <= `SD 1'b1;
        end
        else if(ri_ooc_PRNb1==cdb_to_prf_PRN2 && (cdb_to_prf_PRN2 != 7'd31))
        begin
          ri_ooc_opb1 <= `SD cdb_to_prf_result2_0;
          ri_ooc_opb1_valid <= `SD 1'b1;
        end

        if(ri_ooc_PRNa2==cdb_to_prf_PRN1 && (cdb_to_prf_PRN1 != 7'd31))
        begin
          ri_ooc_opa2 <= `SD cdb_to_prf_result1_0;
          ri_ooc_opa2_valid <= `SD 1'b1;
        end
        else if(ri_ooc_PRNa2==cdb_to_prf_PRN2 && (cdb_to_prf_PRN2 != 7'd31))
        begin
          ri_ooc_opa2 <= `SD cdb_to_prf_result2_0;
          ri_ooc_opa2_valid <= `SD 1'b1;
        end

        if(ri_ooc_PRNb2==cdb_to_prf_PRN1 && (cdb_to_prf_PRN1 != 7'd31))
        begin
          ri_ooc_opb2 <= `SD cdb_to_prf_result1_0;
          ri_ooc_opb2_valid <= `SD 1'b1;
        end
        else if(ri_ooc_PRNb2==cdb_to_prf_PRN2 && (cdb_to_prf_PRN2 != 7'd31))
        begin
          ri_ooc_opb2 <= `SD cdb_to_prf_result2_0;
          ri_ooc_opb2_valid <= `SD 1'b1;
        end
      end
    end // else: !if(reset)
  end // always

  //////////////////////////////////////////////////
  //                                              //
  //           OOC Stage		          //
  //                                              //
  //////////////////////////////////////////////////

  ooc ooc_0(// inputs:
          .reset(reset | ooc_ROB_mis_predict1_out | ooc_ROB_mis_predict2_out),
          .clock(clock),

          // input : instruction 1 from the issue stage
          .is_ooc_dest_PRN1_in(ri_ooc_dest_PRN1),
          .is_ooc_dest_PRN1_old_in(ri_ooc_dest_old_PRN1),
          .is_ooc_dest_ARN1_in(ri_ooc_dest_ARN1),
          .is_ooc_opa1_in(ri_ooc_opa1),
          .is_ooc_PRNa1_in(ri_ooc_PRNa1),
          .is_ooc_opa1_valid(ri_ooc_opa1_valid),
          .is_ooc_opb1_in(ri_ooc_opb1),
          .is_ooc_PRNb1_in(ri_ooc_PRNb1),
          .is_ooc_opb1_valid(ri_ooc_opb1_valid), 
          .is_ooc_cond_branch1_in(ri_ooc_cond_branch1),
          .is_ooc_uncond_branch1_in(ri_ooc_uncond_branch1),
          .is_ooc_pred_addr1_in(ri_ooc_pred_addr1),
          .is_ooc_branch_pred1_in(ri_ooc_prediction1),
          .is_ooc_issue_NPC1_in(ri_ooc_NPC1),
          .is_ooc_issue_PC1_in(ri_ooc_PC1),
          .is_ooc_issue_IR1_in(ri_ooc_IR1),
          .is_ooc_alu_func1_in(ri_ooc_alu_func1),
          .is_ooc_opa_select1_in(ri_ooc_opa_select1),
          .is_ooc_opb_select1_in(ri_ooc_opb_select1),
          .is_ooc_rd_mem1_in(ri_ooc_rd_mem1),
          .is_ooc_wr_mem1_in(ri_ooc_wr_mem1),
          .is_ooc_halt1_in(ri_ooc_halt1),
          .is_ooc_instr_valid1_in(ri_ooc_valid_inst1),

          // input : instruction 2 from the issue stage
          .is_ooc_dest_PRN2_in(ri_ooc_dest_PRN2),
          .is_ooc_dest_PRN2_old_in(ri_ooc_dest_old_PRN2),
          .is_ooc_dest_ARN2_in(ri_ooc_dest_ARN2),
          .is_ooc_opa2_in(ri_ooc_opa2),
          .is_ooc_PRNa2_in(ri_ooc_PRNa2),
          .is_ooc_opa2_valid(ri_ooc_opa2_valid),
          .is_ooc_opb2_in(ri_ooc_opb2),
          .is_ooc_PRNb2_in(ri_ooc_PRNb2),
          .is_ooc_opb2_valid(ri_ooc_opb2_valid), 
          .is_ooc_cond_branch2_in(ri_ooc_cond_branch2),
          .is_ooc_uncond_branch2_in(ri_ooc_uncond_branch2),
          .is_ooc_pred_addr2_in(ri_ooc_pred_addr2),
          .is_ooc_branch_pred2_in(ri_ooc_prediction2),
          .is_ooc_issue_NPC2_in(ri_ooc_NPC2),
          .is_ooc_issue_PC2_in(ri_ooc_PC2),
          .is_ooc_issue_IR2_in(ri_ooc_IR2),
          .is_ooc_alu_func2_in(ri_ooc_alu_func2),
          .is_ooc_opa_select2_in(ri_ooc_opa_select2),
          .is_ooc_opb_select2_in(ri_ooc_opb_select2),
          .is_ooc_rd_mem2_in(ri_ooc_rd_mem2),
          .is_ooc_wr_mem2_in(ri_ooc_wr_mem2),
          .is_ooc_halt2_in(ri_ooc_halt2),
          .is_ooc_instr_valid2_in(ri_ooc_valid_inst2),

          .ooc_lsq_mem_tag_in(mem2proc_tag),
          .ooc_lsq_mem_response_in(Dmem2proc_response),
          .ooc_lsq_mem_value_in(Dcache_data_out),
          .ooc_lsq_mem_valid_in(Dcache_valid_out),
          .ooc_lsq_mem_addr_invalid_in(mem2proc_response==0),

          // outputs from RS
          .rs_stall_out(rs_stall_out),

          // outputs from ROB
          .ROB_stall_out(ROB_stall_out),

          // outputs from LSQ
          .lsq_stall_out(lsq_stall_out),

          .ooc_ROB_to_RRAT_PRN1_out(ooc_ROB_to_RRAT_PRN1_out),
          .ooc_ROB_to_RRAT_ARN1_out(ooc_ROB_to_RRAT_ARN1_out),
          .ooc_ROB_to_PRF_PRN_old1_out(ooc_ROB_to_PRF_PRN_old1_out),
          .ooc_ROB_to_fetch_target_addr1_out(ooc_ROB_to_fetch_target_addr1_out),
          .ooc_ROB_mis_predict1_out(ooc_ROB_mis_predict1_out),
          .ooc_ROB_halt1_out(ooc_ROB_halt1_out),
          .ooc_ROB_valid1_out(ooc_ROB_valid1_out),
          .ooc_ROB_PC1_out(ooc_ROB_PC1_out),
          .ooc_ROB_NPC1_out(ooc_NPC1_out),
          .ooc_ROB_IR1_out(ooc_IR1_out),
          .ooc_ROB_cond_br1_out(ooc_cond_br1_out),
          .ooc_ROB_uncond_br1_out(ooc_uncond_br1_out),
          .ooc_ROB_br_taken1_out(ooc_br_taken1_out),

          .ooc_ROB_to_RRAT_PRN2_out(ooc_ROB_to_RRAT_PRN2_out),
          .ooc_ROB_to_RRAT_ARN2_out(ooc_ROB_to_RRAT_ARN2_out),
          .ooc_ROB_to_PRF_PRN_old2_out(ooc_ROB_to_PRF_PRN_old2_out),
          .ooc_ROB_to_fetch_target_addr2_out(ooc_ROB_to_fetch_target_addr2_out),
          .ooc_ROB_mis_predict2_out(ooc_ROB_mis_predict2_out),
          .ooc_ROB_halt2_out(ooc_ROB_halt2_out),
          .ooc_ROB_valid2_out(ooc_ROB_valid2_out),
          .ooc_ROB_PC2_out(ooc_ROB_PC2_out),
          .ooc_ROB_NPC2_out(ooc_NPC2_out),
          .ooc_ROB_IR2_out(ooc_IR2_out),
          .ooc_ROB_cond_br2_out(ooc_cond_br2_out),
          .ooc_ROB_uncond_br2_out(ooc_uncond_br2_out),
          .ooc_ROB_br_taken2_out(ooc_br_taken2_out),

          //outputs from CDB to PRF
          .cdb1_result_out(cdb_to_prf_result1),
          .cdb1_PRN_out(cdb_to_prf_PRN1),
          .cdb1_valid_out(cdb_to_prf_valid1),
          .cdb1_take_branch(cdb1_take_branch),
          .cdb1_NPC(cdb1_NPC),

          .cdb2_result_out(cdb_to_prf_result2),
          .cdb2_PRN_out(cdb_to_prf_PRN2),
          .cdb2_valid_out(cdb_to_prf_valid2),
          .cdb2_take_branch(cdb2_take_branch),
          .cdb2_NPC(cdb2_NPC),

          // output of request from the LSQ to Dcache for LD or ST
          .ooc_lsq_mem_request_out(proc2Dcache_command),

          .ooc_store_data_out(proc2Dcache_data),
          .ooc_target_address_out(proc2Dcache_addr)
         );

endmodule  // module vericomplicated

