// ROB: The Whole Thing
// Niranjan is awesome
// Everyone else is just okay

module ROB(
           // inputs:
           reset,
           clock,

           ROB_NPC1_in,
           ROB_PC1_in,
           ROB_dest_PRN1_in,
           ROB_dest_PRN_old1_in,
           ROB_dest_ARN1_in,
           ROB_br_pred1_in,
           ROB_br_actual1_in,
           ROB_pred_addr1_in,
           ROB_target_addr1_in,
           ROB_num1_in,
           ROB_lsq_num1_in,
           ROB_cdb_valid1_in,
           ROB_lsq_valid1_in,
           ROB_wr_mem1_in,
           ROB_halt1_in,
           ROB_instr_valid1_in,
           ROB_IR1_in,
           ROB_cond_br1_in,
           ROB_uncond_br1_in,

           ROB_NPC2_in,
           ROB_PC2_in,
           ROB_dest_PRN2_in,
           ROB_dest_PRN_old2_in,
           ROB_dest_ARN2_in,
           ROB_br_pred2_in,
           ROB_br_actual2_in,
           ROB_pred_addr2_in,
           ROB_target_addr2_in,
           ROB_num2_in,
           ROB_cdb_valid2_in,
           ROB_wr_mem2_in,
           ROB_halt2_in,
           ROB_instr_valid2_in,
           ROB_IR2_in,
           ROB_cond_br2_in,
           ROB_uncond_br2_in,

           // outputs:
           ROB_to_RRAT_PRN1_out,
           ROB_to_RRAT_ARN1_out,
           ROB_to_PRF_PRN_old1_out,
           ROB_to_fetch_target_addr1_out,
           ROB_mis_predict1_out,
           ROB_rs_ROB_num1_out,
           ROB_halt1_out,
           ROB_valid1_out,
           ROB_PC1_out,
           ROB_NPC1_out,
           ROB_IR1_out,
           ROB_cond_br1_out,
           ROB_uncond_br1_out,
           ROB_br_taken1_out,
           ROB_wr_LSQ_num1_out,
           ROB_wr_LSQ_num1_valid_out,

           ROB_to_RRAT_PRN2_out,
           ROB_to_RRAT_ARN2_out,
           ROB_to_PRF_PRN_old2_out,
           ROB_to_fetch_target_addr2_out,
           ROB_mis_predict2_out,
           ROB_rs_ROB_num2_out,
           ROB_halt2_out,
           ROB_valid2_out,
           ROB_PC2_out,
           ROB_NPC2_out,
           ROB_IR2_out,
           ROB_cond_br2_out,
           ROB_uncond_br2_out,
           ROB_br_taken2_out,
           ROB_wr_LSQ_num2_out,
           ROB_wr_LSQ_num2_valid_out,

           ROB_stall_out
          );

input         reset;
input         clock;

input  [63:0] ROB_NPC1_in;
input  [63:0] ROB_PC1_in;
input   [6:0] ROB_dest_PRN1_in;
input   [6:0] ROB_dest_PRN_old1_in;
input   [4:0] ROB_dest_ARN1_in;
input         ROB_br_pred1_in;
input         ROB_br_actual1_in;
input  [63:0] ROB_pred_addr1_in;
input  [63:0] ROB_target_addr1_in;
input   [5:0] ROB_num1_in;
input   [5:0] ROB_lsq_num1_in;
input         ROB_cdb_valid1_in;
input         ROB_lsq_valid1_in;
input         ROB_wr_mem1_in;
input         ROB_halt1_in;
input         ROB_instr_valid1_in;
input  [31:0] ROB_IR1_in;
input         ROB_cond_br1_in;
input         ROB_uncond_br1_in;

input  [63:0] ROB_NPC2_in;
input  [63:0] ROB_PC2_in;
input   [6:0] ROB_dest_PRN2_in;
input   [6:0] ROB_dest_PRN_old2_in;
input   [4:0] ROB_dest_ARN2_in;
input         ROB_br_pred2_in;
input         ROB_br_actual2_in;
input  [63:0] ROB_pred_addr2_in;
input  [63:0] ROB_target_addr2_in;
input   [5:0] ROB_num2_in;
input         ROB_cdb_valid2_in;
input         ROB_wr_mem2_in;
input         ROB_halt2_in;
input         ROB_instr_valid2_in;
input  [31:0] ROB_IR2_in;
input         ROB_cond_br2_in;
input         ROB_uncond_br2_in;

output  [6:0] ROB_to_RRAT_PRN1_out;
output  [4:0] ROB_to_RRAT_ARN1_out;
output  [6:0] ROB_to_PRF_PRN_old1_out;
output [63:0] ROB_to_fetch_target_addr1_out;
output        ROB_mis_predict1_out;
output  [5:0] ROB_rs_ROB_num1_out;
output        ROB_halt1_out;
output        ROB_valid1_out;
output [63:0] ROB_PC1_out;
output [63:0] ROB_NPC1_out;
output [31:0] ROB_IR1_out;
output        ROB_cond_br1_out;
output        ROB_uncond_br1_out;
output        ROB_br_taken1_out;
output  [5:0] ROB_wr_LSQ_num1_out;
output        ROB_wr_LSQ_num1_valid_out;

output  [6:0] ROB_to_RRAT_PRN2_out;
output  [4:0] ROB_to_RRAT_ARN2_out;
output  [6:0] ROB_to_PRF_PRN_old2_out;
output [63:0] ROB_to_fetch_target_addr2_out;
output        ROB_mis_predict2_out;
output  [5:0] ROB_rs_ROB_num2_out;
output        ROB_halt2_out;
output        ROB_valid2_out;
output [63:0] ROB_PC2_out;
output [63:0] ROB_NPC2_out;
output [31:0] ROB_IR2_out;
output        ROB_cond_br2_out;
output        ROB_uncond_br2_out;
output        ROB_br_taken2_out;
output  [5:0] ROB_wr_LSQ_num2_out;
output        ROB_wr_LSQ_num2_valid_out;

output        ROB_stall_out;

wire          ROB_load_allowed1_in;
wire          ROB_load_allowed2_in;

integer       i;

reg     [6:0] ROB_to_RRAT_PRN1_out;
reg     [4:0] ROB_to_RRAT_ARN1_out;
reg     [6:0] ROB_to_PRF_PRN_old1_out;
reg    [63:0] ROB_to_fetch_target_addr1_out;
reg           ROB_mis_predict1_out;
reg           ROB_halt1_out;
reg           ROB_valid1_out;
reg    [63:0] ROB_PC1_out;
reg    [63:0] ROB_NPC1_out;
reg    [31:0] ROB_IR1_out;
reg           ROB_cond_br1_out;
reg           ROB_uncond_br1_out;
reg           ROB_br_taken1_out;
reg     [5:0] ROB_wr_LSQ_num1_out;
reg           ROB_wr_LSQ_num1_valid_out;

reg     [6:0] ROB_to_RRAT_PRN2_out;
reg     [4:0] ROB_to_RRAT_ARN2_out;
reg     [6:0] ROB_to_PRF_PRN_old2_out;
reg    [63:0] ROB_to_fetch_target_addr2_out;
reg           ROB_mis_predict2_out;
reg           ROB_halt2_out;
reg           ROB_valid2_out;
reg    [63:0] ROB_PC2_out;
reg    [63:0] ROB_NPC2_out;
reg    [31:0] ROB_IR2_out;
reg           ROB_cond_br2_out;
reg           ROB_uncond_br2_out;
reg           ROB_br_taken2_out;
reg     [5:0] ROB_wr_LSQ_num2_out;
reg           ROB_wr_LSQ_num2_valid_out;

reg    [63:0] NPC[63:0];
reg    [63:0] PC[63:0];
reg     [6:0] dest_PRN[63:0];
reg     [6:0] dest_PRN_old[63:0];
reg     [4:0] dest_ARN[63:0];
reg    [63:0] br_pred; //[63:0];
reg    [63:0] br_actual; //[63:0];
reg    [63:0] pred_addr[63:0];
reg    [63:0] target_addr[63:0];
reg    [63:0] ex_done;
reg           halt[63:0];
reg           wr_mem[63:0];
reg    [31:0] IR[63:0];
reg           valid[63:0];
reg           cond_br[63:0];
reg           uncond_br[63:0];

reg     [5:0] ROB_head_pointer1;
reg     [5:0] ROB_tail_pointer1;

wire    [5:0] next_ROB_head_pointer1;
wire    [5:0] next_ROB_tail_pointer1;

wire    [5:0] ROB_head_pointer2;
wire    [5:0] ROB_tail_pointer2;
wire    [5:0] next_ROB_head_pointer2;
wire    [5:0] next_ROB_tail_pointer2;

wire    [5:0] ROB_rs_ROB_num1_out;
wire    [5:0] ROB_rs_ROB_num2_out;

wire          mispredict1;
wire          mispredict2;
wire          mispredictJump1;
wire          mispredictJump2;

assign ROB_rs_ROB_num1_out = ROB_tail_pointer1;
assign ROB_rs_ROB_num2_out = ROB_tail_pointer2;

assign ROB_load_allowed1_in = (next_ROB_tail_pointer1 != ROB_head_pointer1) &&
                              ROB_instr_valid1_in  ? 1'b1 : 1'b0;
assign ROB_load_allowed2_in = (next_ROB_tail_pointer2 != ROB_head_pointer2) &&
                              ROB_instr_valid2_in ? 1'b1 : 1'b0;

assign ROB_stall_out = (next_ROB_tail_pointer1 == ROB_head_pointer1) ||
                       (next_ROB_tail_pointer2 == ROB_head_pointer1);

assign mispredict1 = (br_actual[ROB_head_pointer1] != br_pred[ROB_head_pointer1]) &&
                     (cond_br[ROB_head_pointer1] || uncond_br[ROB_head_pointer1]);
assign mispredict2 = (br_actual[ROB_head_pointer2] != br_pred[ROB_head_pointer2]) &&
                     (cond_br[ROB_head_pointer2] || uncond_br[ROB_head_pointer2]);
assign mispredictJump1 = (uncond_br[ROB_head_pointer1] || cond_br[ROB_head_pointer1]) &&
                         br_pred[ROB_head_pointer1] && (pred_addr[ROB_head_pointer1]!=target_addr[ROB_head_pointer1]);
assign mispredictJump2 = (uncond_br[ROB_head_pointer2] || cond_br[ROB_head_pointer2]) &&
                         br_pred[ROB_head_pointer2] && (pred_addr[ROB_head_pointer2]!=target_addr[ROB_head_pointer2]);

assign ROB_head_pointer2 = ROB_head_pointer1 + 1;
assign ROB_tail_pointer2 = ROB_tail_pointer1 + 1;

assign next_ROB_tail_pointer2 = ROB_tail_pointer2 + 2;
assign next_ROB_head_pointer2 = ROB_head_pointer2 + 2;

assign next_ROB_tail_pointer1 = ROB_tail_pointer1 + 2;
assign next_ROB_head_pointer1 = ROB_head_pointer1 + 2;


// issuing to the ROB
always @(posedge clock)
begin
/*
   $display("H1:%d, T1:%d", ROB_head_pointer1, ROB_tail_pointer1);
   $display("H2:%d, T2:%d", ROB_head_pointer2, ROB_tail_pointer2);
   for(i = 0; i < 64; i = i + 2)
   begin
      $display("[%2d] PC:%h, IR:%h, ExDone:%b, dest_ARN:%d, dest_PRN:%d ||  [%2d] PC:%h, IR:%h, ExDone:%b, dest_ARN:%d, dest_PRN:%d",
               i, PC[i], IR[i], ex_done[i], dest_ARN[i], dest_PRN[i], i+1, PC[i+1], IR[i+1], ex_done[i+1], dest_ARN[i+1], dest_PRN[i+1]);
   end
*/
   if(reset)
   begin
      for(i = 0; i < 64; i = i + 1)
      begin
         NPC[i] <= `SD 64'b0;
         PC[i]  <= `SD 64'b0;
         dest_PRN[i] <= `SD 7'b0;
         dest_PRN_old[i] <= `SD 7'b0;
         dest_ARN[i] <= `SD 5'b0;
         br_pred[i] <= `SD 1'b0;
         br_actual[i] <= `SD 1'b0;
         pred_addr[i] <= `SD 64'b0;
         target_addr[i] <= `SD 64'b0;
         ex_done[i] <= `SD 1'b0;
         halt[i] <= `SD 1'b0;
         wr_mem[i] <= `SD 1'b0;
         IR[i] <= `SD `NOOP_INST;
         valid[i] <= `SD 1'b0;
         cond_br[i] <= `SD 1'b0;
         uncond_br[i] <= `SD 1'b0; 
      end
      ROB_head_pointer1 <= `SD 6'b0;
      ROB_tail_pointer1 <= `SD 6'b0;

      ROB_to_RRAT_PRN1_out <= `SD 7'b0;
      ROB_to_RRAT_ARN1_out <= `SD 5'b0;
      ROB_to_PRF_PRN_old1_out <= `SD 7'b0;
      ROB_to_fetch_target_addr1_out <= `SD 64'b0;
      ROB_mis_predict1_out <= `SD 1'b0;
      ROB_valid1_out <= `SD 1'b0;
      ROB_PC1_out <= `SD 64'b0;
      ROB_NPC1_out <= `SD 64'b0;
      ROB_IR1_out <= `SD `NOOP_INST;
      ROB_halt1_out <= `SD 1'b0;
      ROB_cond_br1_out <= `SD 1'b0;
      ROB_uncond_br1_out <= `SD 1'b0;
      ROB_br_taken1_out <= `SD 1'b0;
      ROB_wr_LSQ_num1_out <= `SD 6'b0;
      ROB_wr_LSQ_num1_valid_out <= `SD 1'b0;

      ROB_to_RRAT_PRN2_out <= `SD 7'b0;
      ROB_to_RRAT_ARN2_out <= `SD 5'b0;
      ROB_to_PRF_PRN_old2_out <= `SD 7'b0;
      ROB_to_fetch_target_addr2_out <= `SD 64'b0;
      ROB_mis_predict2_out <= `SD 1'b0;
      ROB_valid2_out <= `SD 1'b0;
      ROB_PC2_out <= `SD 64'b0;
      ROB_NPC2_out <= `SD 64'b0;
      ROB_IR2_out <= `SD `NOOP_INST;
      ROB_halt2_out <= `SD 1'b0;
      ROB_cond_br2_out <= `SD 1'b0;
      ROB_uncond_br2_out <= `SD 1'b0;
      ROB_br_taken2_out <= `SD 1'b0;
      ROB_wr_LSQ_num2_out <= `SD 6'b0;
      ROB_wr_LSQ_num2_valid_out <= `SD 1'b0;
   end
   else
   begin
      if(ROB_load_allowed1_in && ROB_load_allowed2_in)
      begin
         NPC[ROB_tail_pointer1] <= `SD ROB_NPC1_in;
         PC[ROB_tail_pointer1]  <= `SD ROB_PC1_in;
         dest_PRN[ROB_tail_pointer1] <= `SD ROB_dest_PRN1_in;
         dest_PRN_old[ROB_tail_pointer1] <= `SD ROB_dest_PRN_old1_in;
         dest_ARN[ROB_tail_pointer1] <= `SD ROB_dest_ARN1_in;
         br_pred[ROB_tail_pointer1] <= `SD ROB_br_pred1_in;
         br_actual[ROB_tail_pointer1] <= `SD 1'b0;
         pred_addr[ROB_tail_pointer1] <= `SD ROB_pred_addr1_in;
         target_addr[ROB_tail_pointer1] <= `SD 0;//ROB_target_addr1_in;
         halt[ROB_tail_pointer1] <= `SD ROB_halt1_in;
         wr_mem[ROB_tail_pointer1] <= `SD ROB_wr_mem1_in;
         IR[ROB_tail_pointer1] <= `SD ROB_IR1_in;
         cond_br[ROB_tail_pointer1] <= `SD ROB_cond_br1_in;
         uncond_br[ROB_tail_pointer1] <= `SD ROB_uncond_br1_in;
         valid[ROB_tail_pointer1] <= `SD 1'b1;
         ex_done[ROB_tail_pointer1] <= `SD 1'b0;

         NPC[ROB_tail_pointer2] <= `SD ROB_NPC2_in;
         PC[ROB_tail_pointer2]  <= `SD ROB_PC2_in;
         dest_PRN[ROB_tail_pointer2] <= `SD ROB_dest_PRN2_in;
         dest_PRN_old[ROB_tail_pointer2] <= `SD ROB_dest_PRN_old2_in;
         dest_ARN[ROB_tail_pointer2] <= `SD ROB_dest_ARN2_in;
         br_pred[ROB_tail_pointer2] <= `SD ROB_br_pred2_in;
         br_actual[ROB_tail_pointer2] <= `SD 1'b0;
         pred_addr[ROB_tail_pointer2] <= `SD ROB_pred_addr2_in;
         target_addr[ROB_tail_pointer2] <= `SD 0;//ROB_target_addr2_in;
         halt[ROB_tail_pointer2] <= `SD ROB_halt2_in;
         wr_mem[ROB_tail_pointer2] <= `SD ROB_wr_mem2_in;
         IR[ROB_tail_pointer2] <= `SD ROB_IR2_in;
         cond_br[ROB_tail_pointer2] <= `SD ROB_cond_br2_in;
         uncond_br[ROB_tail_pointer2] <= `SD ROB_uncond_br2_in;
         valid[ROB_tail_pointer2] <= `SD 1'b1;
         ex_done[ROB_tail_pointer2] <= `SD 1'b0;

         ROB_tail_pointer1 <= `SD next_ROB_tail_pointer1;
      end
      else if(ROB_load_allowed1_in && ~ROB_load_allowed2_in)
      begin
         NPC[ROB_tail_pointer1] <= `SD ROB_NPC1_in;
         PC[ROB_tail_pointer1]  <= `SD ROB_PC1_in;
         dest_PRN[ROB_tail_pointer1] <= `SD ROB_dest_PRN1_in;
         dest_PRN_old[ROB_tail_pointer1] <= `SD ROB_dest_PRN_old1_in;
         dest_ARN[ROB_tail_pointer1] <= `SD ROB_dest_ARN1_in;
         br_pred[ROB_tail_pointer1] <= `SD ROB_br_pred1_in;
         br_actual[ROB_tail_pointer1] <= `SD 1'b0;
         pred_addr[ROB_tail_pointer1] <= `SD ROB_pred_addr1_in;
         target_addr[ROB_tail_pointer1] <= `SD 0;//ROB_target_addr1_in;
         wr_mem[ROB_tail_pointer1] <= `SD ROB_wr_mem1_in;
         halt[ROB_tail_pointer1] <= `SD ROB_halt1_in;
         ex_done[ROB_tail_pointer1] <= `SD 1'b0;
         IR[ROB_tail_pointer1] <= `SD ROB_IR1_in;
         cond_br[ROB_tail_pointer1] <= `SD ROB_cond_br1_in;
         uncond_br[ROB_tail_pointer1] <= `SD ROB_uncond_br1_in;
         valid[ROB_tail_pointer1] <= `SD 1'b1;

         ROB_tail_pointer1 <= `SD ROB_tail_pointer2;
      end
      else if(~ROB_load_allowed1_in && ROB_load_allowed2_in)
      begin
         NPC[ROB_tail_pointer1] <= `SD ROB_NPC2_in;
         PC[ROB_tail_pointer1]  <= `SD ROB_PC2_in;
         dest_PRN[ROB_tail_pointer1] <= `SD ROB_dest_PRN2_in;
         dest_PRN_old[ROB_tail_pointer1] <= `SD ROB_dest_PRN_old2_in;
         dest_ARN[ROB_tail_pointer1] <= `SD ROB_dest_ARN2_in;
         br_pred[ROB_tail_pointer1] <= `SD ROB_br_pred2_in;
         br_actual[ROB_tail_pointer1] <= `SD 1'b0;
         pred_addr[ROB_tail_pointer1] <= `SD ROB_pred_addr2_in;
         target_addr[ROB_tail_pointer1] <= `SD 0;//ROB_target_addr2_in;
         wr_mem[ROB_tail_pointer1] <= `SD ROB_wr_mem2_in;
         halt[ROB_tail_pointer1] <= `SD ROB_halt2_in;
         IR[ROB_tail_pointer1] <= `SD ROB_IR2_in;
         ex_done[ROB_tail_pointer1] <= `SD 1'b0;
         cond_br[ROB_tail_pointer1] <= `SD ROB_cond_br2_in;
         uncond_br[ROB_tail_pointer1] <= `SD ROB_uncond_br2_in;
         valid[ROB_tail_pointer1] <= `SD 1'b1;

         ROB_tail_pointer1 <= `SD ROB_tail_pointer2;
      end

      if(ROB_cdb_valid1_in)
      begin
         ex_done[ROB_num1_in] <= `SD 1'b1;
      end

      if(ROB_cdb_valid2_in)
      begin
         ex_done[ROB_num2_in] <= `SD 1'b1;
      end

      if(ROB_lsq_valid1_in)
      begin
         ex_done[ROB_lsq_num1_in] <= `SD 1'b1;
      end

      if(ROB_halt1_in)
      begin
         ex_done[ROB_tail_pointer1] <= `SD 1'b1;
      end
      else if(!ROB_halt1_in && ROB_instr_valid1_in && ROB_halt2_in)
      begin
         ex_done[ROB_tail_pointer2] <= `SD 1'b1;
      end
      else if(!ROB_instr_valid1_in && ROB_halt2_in)
      begin
         ex_done[ROB_tail_pointer1] <= `SD 1'b1;
      end

      if(ROB_cdb_valid1_in && ROB_br_actual1_in)
      begin
         br_actual[ROB_num1_in] <= `SD 1'b1;
         target_addr[ROB_num1_in] <= `SD ROB_target_addr1_in;
      end

      if(ROB_cdb_valid2_in && ROB_br_actual2_in)
      begin
         br_actual[ROB_num2_in] <= `SD 1'b1;
         target_addr[ROB_num2_in] <= `SD ROB_target_addr2_in;
      end
   end

   if(~reset)
   begin
      ROB_wr_LSQ_num1_out <= `SD ROB_head_pointer1;
      ROB_wr_LSQ_num1_valid_out <= `SD valid[ROB_head_pointer1];
      ROB_wr_LSQ_num2_out <= `SD ROB_head_pointer2;
      ROB_wr_LSQ_num2_valid_out <= `SD valid[ROB_head_pointer2];
      //////////////////////////////////////////////////////////////////////////
      // The instruction at the head of ROB, which pointed by Head Pointer 1  //
      //////////////////////////////////////////////////////////////////////////
      if(ex_done[ROB_head_pointer1])
      begin
         ROB_to_RRAT_PRN1_out <= `SD dest_PRN[ROB_head_pointer1];
         ROB_to_RRAT_ARN1_out <= `SD dest_ARN[ROB_head_pointer1];
         ROB_to_PRF_PRN_old1_out <= `SD dest_PRN_old[ROB_head_pointer1];
         ROB_halt1_out <= `SD halt[ROB_head_pointer1];
         ROB_valid1_out <= `SD 1'b1;
         ROB_PC1_out <= `SD PC[ROB_head_pointer1];
         ROB_NPC1_out <= `SD NPC[ROB_head_pointer1];
         ROB_IR1_out <= `SD IR[ROB_head_pointer1];
         ROB_cond_br1_out <= `SD cond_br[ROB_head_pointer1];
         ROB_uncond_br1_out <= `SD uncond_br[ROB_head_pointer1];
         ROB_to_fetch_target_addr1_out <= `SD target_addr[ROB_head_pointer1];
         ROB_br_taken1_out <= `SD br_actual[ROB_head_pointer1];

         ex_done[ROB_head_pointer1] <= `SD 1'b0;
         valid[ROB_head_pointer1] <= `SD 1'b0;

         ROB_mis_predict1_out <= `SD 1'b0;
         if(mispredict1 || mispredictJump1)
         begin
            //ROB_tail_pointer1 <= `SD ROB_head_pointer1;
            ROB_mis_predict1_out <= `SD 1'b1;
            for(i = 0; i < 64; i = i + 1)
            begin
               NPC[i] <= `SD 64'b0;
               PC[i]  <= `SD 64'b0;
               dest_PRN[i] <= `SD 7'b0;
               dest_PRN_old[i] <= `SD 7'b0;
               dest_ARN[i] <= `SD 5'b0;
               br_pred[i] <= `SD 1'b0;
               br_actual[i] <= `SD 1'b0;
               pred_addr[i] <= `SD 64'b0;
               target_addr[i] <= `SD 64'b0;
               ex_done[i] <= `SD 1'b0;
               halt[i] <= `SD 1'b0;
               wr_mem[i] <= `SD 1'b0;
               IR[i] <= `SD `NOOP_INST;
               valid[i] <= `SD 1'b0;
               cond_br[i] <= `SD 1'b0;
               uncond_br[i] <= `SD 1'b0; 
            end
         end

         if(~ex_done[ROB_head_pointer2] || mispredict2 || mispredictJump2 ||
            (wr_mem[ROB_head_pointer1] && wr_mem[ROB_head_pointer2]))
         begin
            if(~(mispredict1 || mispredictJump1))
            begin
               ROB_mis_predict2_out <= `SD 1'b0;
               ROB_head_pointer1 <= `SD ROB_head_pointer2;
            end
         end
         else if(~(mispredict1 || mispredictJump1))
         begin
            ROB_head_pointer1 <= `SD next_ROB_head_pointer1;
         end
      end
      else
      begin
         ROB_to_RRAT_PRN1_out <= `SD 7'd31;
         ROB_to_RRAT_ARN1_out <= `SD `ZERO_REG;
         ROB_to_PRF_PRN_old1_out <= `SD 7'd31;
         ROB_to_fetch_target_addr1_out <= `SD 64'b0;
         ROB_mis_predict1_out <= `SD 1'b0;
         ROB_valid1_out <= `SD 1'b0;
         ROB_halt1_out <= `SD 1'b0;
         ROB_PC1_out <= `SD 64'b0;
         ROB_NPC1_out <= `SD 64'b0;
         ROB_IR1_out <= `SD `NOOP_INST;
         ROB_cond_br1_out <= `SD 1'b0;
         ROB_uncond_br1_out <= `SD 1'b0;
         ROB_br_taken1_out <= `SD 1'b0;
      end

      //////////////////////////////////////////////////////////////////////////
      // The instruction at the head of ROB, which pointed by Head Pointer 2  //
      //////////////////////////////////////////////////////////////////////////

      if(ex_done[ROB_head_pointer1] && ex_done[ROB_head_pointer2] && !mispredict1 &&
         !mispredictJump1 && !(wr_mem[ROB_head_pointer1] && wr_mem[ROB_head_pointer2])
          && !halt[ROB_head_pointer1])
      begin
         ROB_to_RRAT_PRN2_out <= `SD dest_PRN[ROB_head_pointer2];
         ROB_to_RRAT_ARN2_out <= `SD dest_ARN[ROB_head_pointer2];
         ROB_to_PRF_PRN_old2_out <= `SD dest_PRN_old[ROB_head_pointer2];
         ROB_halt2_out <= `SD halt[ROB_head_pointer2];
         ROB_valid2_out <= `SD 1'b1;
         ROB_PC2_out <= `SD PC[ROB_head_pointer2];
         ROB_NPC2_out <= `SD NPC[ROB_head_pointer2];
         ROB_IR2_out <= `SD IR[ROB_head_pointer2];
         ROB_cond_br2_out <= `SD cond_br[ROB_head_pointer2];
         ROB_uncond_br2_out <= `SD uncond_br[ROB_head_pointer2];
         ROB_to_fetch_target_addr2_out <= `SD target_addr[ROB_head_pointer2];
         ROB_br_taken2_out <= `SD br_actual[ROB_head_pointer2];

         ex_done[ROB_head_pointer2] <= `SD 1'b0;
         valid[ROB_head_pointer2] <= `SD 1'b0;

         ROB_mis_predict2_out <= `SD 1'b0;
         if(mispredict2 || mispredictJump2)
         begin
            //ROB_tail_pointer1 <= `SD ROB_head_pointer2;
            ROB_mis_predict2_out <= `SD 1'b1;
            for(i = 0; i < 64; i = i + 1)
            begin
               NPC[i] <= `SD 64'b0;
               PC[i]  <= `SD 64'b0;
               dest_PRN[i] <= `SD 7'b0;
               dest_PRN_old[i] <= `SD 7'b0;
               dest_ARN[i] <= `SD 5'b0;
               br_pred[i] <= `SD 1'b0;
               br_actual[i] <= `SD 1'b0;
               pred_addr[i] <= `SD 64'b0;
               target_addr[i] <= `SD 64'b0;
               ex_done[i] <= `SD 1'b0;
               halt[i] <= `SD 1'b0;
               wr_mem[i] <= `SD 1'b0;
               IR[i] <= `SD `NOOP_INST;
               valid[i] <= `SD 1'b0;
               cond_br[i] <= `SD 1'b0;
               uncond_br[i] <= `SD 1'b0; 
            end
         end
      end // end if
      else
      begin
         ROB_to_RRAT_PRN2_out <= `SD 7'd31;
         ROB_to_RRAT_ARN2_out <= `SD `ZERO_REG;
         ROB_to_PRF_PRN_old2_out <= `SD 7'd31;
         ROB_to_fetch_target_addr2_out <= `SD 64'b0;
         ROB_mis_predict2_out <= `SD 1'b0;
         ROB_valid2_out <= `SD 1'b0;
         ROB_halt2_out <= `SD 1'b0;
         ROB_PC2_out <= `SD 64'b0;
         ROB_NPC2_out <= `SD 64'b0;
         ROB_IR2_out <= `SD `NOOP_INST;
         ROB_cond_br2_out <= `SD 1'b0;
         ROB_uncond_br2_out <= `SD 1'b0;
         ROB_br_taken2_out <= `SD 1'b0;
      end
   end
end // end always
endmodule
