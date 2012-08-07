module cdb(
      //inputs
      clock,
      reset,

      cdb_alu1_result_in,
      cdb_alu2_result_in,
      cdb_alu1_NPC,
      cdb_alu2_NPC,
      cdb_ROB2_alu_in,
      cdb_ROB1_alu_in,
      cdb_dest_PRN1_alu_in,
      cdb_dest_PRN2_alu_in,
      alu0_valid,
      alu1_valid,
   
      cdb_mult1_result_in,
      cdb_mult2_result_in,
      cdb_ROB2_mult_in,
      cdb_ROB1_mult_in,
      cdb_dest_PRN1_mult_in,
      cdb_dest_PRN2_mult_in,
      cdb1_take_branch_in,
      cdb2_take_branch_in,
      mult0_done,
      mult1_done,

      cdb_lsq1_result_in,
      cdb_ROB1_lsq_in,
      cdb_dest_PRN1_lsq_in,
      cdb_lsq2_result_in,
      cdb_ROB2_lsq_in,
      cdb_dest_PRN2_lsq_in,
      lsq0_valid,
      lsq1_valid,
   
      //outputs
      cdb1_result_out,
      cdb1_ROB_out,
      cdb1_PRN_out,
      cdb1_take_branch,
      cdb1_valid_out,
      cdb1_NPC,

      cdb2_result_out,
      cdb2_ROB_out,
      cdb2_PRN_out,
      cdb2_take_branch,
      cdb2_valid_out,
      cdb2_NPC,

      next_disable_vector
     );

input         clock;
input         reset;

input  [63:0] cdb_mult1_result_in;
input   [5:0] cdb_ROB1_mult_in;
input   [6:0] cdb_dest_PRN1_mult_in;
input  [63:0] cdb_mult2_result_in;
input   [5:0] cdb_ROB2_mult_in;
input   [6:0] cdb_dest_PRN2_mult_in;

input  [63:0] cdb_alu1_result_in;
input   [5:0] cdb_ROB1_alu_in;
input   [6:0] cdb_dest_PRN1_alu_in;
input  [63:0] cdb_alu1_NPC;
input  [63:0] cdb_alu2_result_in;
input   [5:0] cdb_ROB2_alu_in;
input   [6:0] cdb_dest_PRN2_alu_in;
input  [63:0] cdb_alu2_NPC;

input  [63:0] cdb_lsq1_result_in;
input   [5:0] cdb_ROB1_lsq_in;
input   [6:0] cdb_dest_PRN1_lsq_in;
input  [63:0] cdb_lsq2_result_in;
input   [5:0] cdb_ROB2_lsq_in;
input   [6:0] cdb_dest_PRN2_lsq_in;

input         cdb1_take_branch_in;
input         cdb2_take_branch_in;

input         alu0_valid;
input         alu1_valid;

input         mult0_done;
input         mult1_done;

input         lsq0_valid;
input         lsq1_valid;

output [63:0] cdb1_result_out;
output  [5:0] cdb1_ROB_out;
output  [6:0] cdb1_PRN_out;
output        cdb1_take_branch;
output        cdb1_valid_out;
output [63:0] cdb1_NPC;
   
output [63:0] cdb2_result_out;
output  [5:0] cdb2_ROB_out;
output  [6:0] cdb2_PRN_out;
output        cdb2_take_branch;
output        cdb2_valid_out;
output [63:0] cdb2_NPC;

output  [5:0] next_disable_vector;

reg    [63:0] next_cdb1_result_out;
reg     [5:0] next_cdb1_ROB_out;
reg     [6:0] next_cdb1_PRN_out;
reg           next_cdb1_take_branch;
reg           next_cdb1_valid_out;
reg    [63:0] next_cdb1_NPC;

reg    [63:0] next_cdb2_result_out;
reg     [5:0] next_cdb2_ROB_out;
reg     [6:0] next_cdb2_PRN_out;
reg           next_cdb2_take_branch;
reg           next_cdb2_valid_out;
reg   [63:0]  next_cdb2_NPC;
   
reg     [5:0] next_disable_vector;

wire    [5:0] valid_vector;

reg    [63:0] cdb1_result_out;
reg     [5:0] cdb1_ROB_out;
reg     [6:0] cdb1_PRN_out;
reg           cdb1_take_branch;
reg           cdb1_valid_out;
reg    [63:0] cdb1_NPC;

reg    [63:0] cdb2_result_out;
reg     [5:0] cdb2_ROB_out;
reg     [6:0] cdb2_PRN_out;
reg           cdb2_take_branch;
reg           cdb2_valid_out;
reg   [63:0]  cdb2_NPC;

assign valid_vector = {lsq0_valid, lsq1_valid, mult0_done, mult1_done, alu0_valid, alu1_valid};

// look at all instructions based on priority put the 2 valid ones with highest priority on the CDB
always @*
begin
   next_cdb1_valid_out = 1'b0;
   next_cdb2_valid_out = 1'b0;

   if(lsq0_valid && lsq1_valid) //load 1 and load 2 valid
   begin
      //$display("load 1 and load 2 valid");
      next_cdb1_result_out = cdb_lsq1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_lsq2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_lsq_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_lsq_in;
      next_cdb2_take_branch = 1'b0;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = 64'b0;

      next_disable_vector = valid_vector ^ 6'b110000;
   end
   else if (lsq0_valid && mult0_done)// load1 and mult1 valid
   begin
      //$display("load 1 and mult 1 valid");
      next_cdb1_result_out = cdb_lsq1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_mult1_result_in;
      next_cdb2_ROB_out = cdb_ROB1_mult_in;
      next_cdb2_PRN_out = cdb_dest_PRN1_mult_in;
      next_cdb2_take_branch = 1'b0;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = 64'b0;
   
      next_disable_vector = valid_vector ^ 6'b101000;
   end
   else if(lsq0_valid && mult1_done) // load 1 and mult2 valid
   begin
      //$display("load 1 and mult 2 valid");
      next_cdb1_result_out = cdb_lsq1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_mult2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_mult_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_mult_in;
      next_cdb2_take_branch = 1'b0;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = 64'b0;
   
      next_disable_vector = valid_vector ^ 6'b100100;
   end
   else if(lsq0_valid && alu0_valid) // load 1 and alu1
   begin
      //$display("load 1 and alu 1 valid");
      next_cdb1_result_out = cdb_lsq1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu1_result_in;
      next_cdb2_ROB_out = cdb_ROB1_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN1_alu_in;
      next_cdb2_take_branch = cdb1_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu1_NPC;
   
      next_disable_vector = valid_vector ^ 6'b100010;
   end
   else if(lsq0_valid && alu1_valid) // load 1 and alu2
   begin
      //$display("load 1 and alu 2 valid");
      next_cdb1_result_out = cdb_lsq1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_alu_in;
      next_cdb2_take_branch = cdb2_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu2_NPC;
   
      next_disable_vector = valid_vector ^ 6'b100001;
   end
   else if(lsq1_valid && mult0_done) // load2 and mult1
   begin
      //$display("load 2 and mult 1 valid");
      next_cdb1_result_out = cdb_lsq2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_mult1_result_in;
      next_cdb2_ROB_out = cdb_ROB1_mult_in;
      next_cdb2_PRN_out = cdb_dest_PRN1_mult_in;
      next_cdb2_take_branch = 1'b0;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = 64'b0;
   
      next_disable_vector = valid_vector ^ 6'b011000;
   end
   else if(lsq1_valid && mult1_done) // load2 and mult2
   begin
      //$display("load 2 and mult 2 valid");
      next_cdb1_result_out = cdb_lsq2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_mult2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_mult_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_mult_in;
      next_cdb2_take_branch = 1'b0;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = 64'b0;
   
      next_disable_vector = valid_vector ^ 6'b010100;
   end
   else if(lsq1_valid && alu0_valid) // load2 and alu1
   begin
      //$display("load 2 and alu 1 valid");
      next_cdb1_result_out = cdb_lsq2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu1_result_in;
      next_cdb2_ROB_out = cdb_ROB1_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN1_alu_in;
      next_cdb2_take_branch = cdb1_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu1_NPC;
   
      next_disable_vector = valid_vector ^ 6'b010010;
   end
   else if(lsq1_valid && alu1_valid) // load2 and alu2
   begin
      //$display("load 2 and alu 2 valid");
      next_cdb1_result_out = cdb_lsq2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_alu_in;
      next_cdb2_take_branch = cdb2_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu2_NPC;
   
      next_disable_vector = valid_vector ^ 6'b010001;
   end
   else if(mult0_done && mult1_done) // mult1 and mult2
   begin
      //$display("mult 1 and mult 2 valid");
      next_cdb1_result_out = cdb_mult1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_mult_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_mult_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_mult2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_mult_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_mult_in;
      next_cdb2_take_branch = 1'b0;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = 64'b0;

      next_disable_vector = valid_vector ^ 6'b001100;
   end
   else if(mult0_done && alu0_valid) // mult1 and alu1
   begin
      //$display("mult 1 and alu 1 valid");
      next_cdb1_result_out = cdb_mult1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_mult_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_mult_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu1_result_in;
      next_cdb2_ROB_out = cdb_ROB1_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN1_alu_in;
      next_cdb2_take_branch = cdb1_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu1_NPC;
   
      next_disable_vector = valid_vector ^ 6'b001010;
   end
   else if(mult0_done && alu1_valid) // mult1 and alu2
   begin
      //$display("mult 1 and alu 2 valid");
      next_cdb1_result_out = cdb_mult1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_mult_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_mult_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_alu_in;
      next_cdb2_take_branch = cdb2_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu2_NPC;
   
      next_disable_vector = valid_vector ^ 6'b001001;
   end
   else if(mult1_done && alu0_valid) // mult2 and alu1
   begin
      //$display("mult 2 and alu 1 valid");
      next_cdb1_result_out = cdb_mult2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_mult_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_mult_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu1_result_in;
      next_cdb2_ROB_out = cdb_ROB1_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN1_alu_in;
      next_cdb2_take_branch = cdb1_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu1_NPC;
   
      next_disable_vector = valid_vector ^ 6'b000110;
   end
   else if(mult1_done && alu1_valid) // mult2 and alu2
   begin
      //$display("mult 2 and alu 2 valid");
      next_cdb1_result_out = cdb_mult2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_mult_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_mult_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = cdb_alu2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_alu_in;
      next_cdb2_take_branch = cdb2_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu2_NPC;
   
      next_disable_vector = valid_vector ^ 6'b000101;
   end
   else if(alu0_valid && alu1_valid) //alu1 alu2
   begin
      //$display("alu 1 and alu 1 valid");
      next_cdb1_result_out = cdb_alu1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_alu_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_alu_in;
      next_cdb1_take_branch = cdb1_take_branch_in;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = cdb_alu1_NPC;

      next_cdb2_result_out = cdb_alu2_result_in;
      next_cdb2_ROB_out = cdb_ROB2_alu_in;
      next_cdb2_PRN_out = cdb_dest_PRN2_alu_in;
      next_cdb2_take_branch = cdb2_take_branch_in;
      next_cdb2_valid_out = 1'b1;
      next_cdb2_NPC = cdb_alu2_NPC;
   
      next_disable_vector = valid_vector ^ 6'b000011;
   end
   else if(lsq0_valid)
   begin
      next_cdb1_result_out = cdb_lsq1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = 0;
      next_cdb2_ROB_out = 6'b0;
      next_cdb2_PRN_out = 7'd31;
      next_cdb2_take_branch = 0;
      next_cdb2_valid_out = 1'b0;
      next_cdb2_NPC = 64'b0;
 
      next_disable_vector = 0; 
   end
   else if(lsq1_valid)
   begin
      next_cdb1_result_out = cdb_lsq2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_lsq_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_lsq_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = 0;
      next_cdb2_ROB_out = 6'b0;
      next_cdb2_PRN_out = 7'd31;
      next_cdb2_take_branch = 0;
      next_cdb2_valid_out = 1'b0;
      next_cdb2_NPC = 64'b0;
 
      next_disable_vector = 0; 
   end
   else if(mult0_done)
   begin
      next_cdb1_result_out = cdb_mult1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_mult_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_mult_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = 0;
      next_cdb2_ROB_out = 6'b0;
      next_cdb2_PRN_out = 7'd31;
      next_cdb2_take_branch = 0;
      next_cdb2_valid_out = 1'b0;
      next_cdb2_NPC = 64'b0;
 
      next_disable_vector = 0; 
   end
   else if(mult1_done)
   begin
      next_cdb1_result_out = cdb_mult2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_mult_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_mult_in;
      next_cdb1_take_branch = 1'b0;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = 0;
      next_cdb2_ROB_out = 6'b0;
      next_cdb2_PRN_out = 7'd31;
      next_cdb2_take_branch = 0;
      next_cdb2_valid_out = 1'b0;
      next_cdb2_NPC = 64'b0;
 
      next_disable_vector = 0; 
   end
   else if(alu0_valid)
   begin
      next_cdb1_result_out = cdb_alu1_result_in;
      next_cdb1_ROB_out = cdb_ROB1_alu_in;
      next_cdb1_PRN_out = cdb_dest_PRN1_alu_in;
      next_cdb1_take_branch = cdb1_take_branch_in;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = cdb_alu1_NPC;

      next_cdb2_result_out = 0;
      next_cdb2_ROB_out = 6'b0;
      next_cdb2_PRN_out = 7'd31;
      next_cdb2_take_branch = 0;
      next_cdb2_valid_out = 1'b0;
      next_cdb2_NPC = 64'b0;
 
      next_disable_vector = 0; 
   end
   else if(alu1_valid)
   begin
      next_cdb1_result_out = cdb_alu2_result_in;
      next_cdb1_ROB_out = cdb_ROB2_alu_in;
      next_cdb1_PRN_out = cdb_dest_PRN2_alu_in;
      next_cdb1_take_branch = cdb2_take_branch_in;
      next_cdb1_valid_out = 1'b1;
      next_cdb1_NPC = cdb_alu2_NPC;

      next_cdb2_result_out = 0;
      next_cdb2_ROB_out = 6'b0;
      next_cdb2_PRN_out = 7'd31;
      next_cdb2_take_branch = 0;
      next_cdb2_valid_out = 1'b0;
      next_cdb2_NPC = 64'b0;
 
      next_disable_vector = 0; 
   end
   else
   begin
      next_cdb1_result_out = 0;
      next_cdb1_ROB_out = 6'b0;
      next_cdb1_PRN_out = 7'd31;
      next_cdb1_take_branch = 0;
      next_cdb1_valid_out = 1'b0;
      next_cdb1_NPC = 64'b0;

      next_cdb2_result_out = 0;
      next_cdb2_ROB_out = 6'b0;
      next_cdb2_PRN_out = 7'd31;
      next_cdb2_take_branch = 0;
      next_cdb2_valid_out = 1'b0;
      next_cdb2_NPC = 64'b0;

      next_disable_vector = 0; 
   end   
end

always @(posedge clock)
begin
   //$display("disble_vector:%b", next_disable_vector);
   //$display("valid_vector: %b", valid_vector);
   if (reset)
   begin
      cdb1_result_out<= `SD 0;
      cdb1_ROB_out<= `SD 0;
      cdb1_PRN_out<= `SD 0;
      cdb1_take_branch<= `SD 0;
      cdb1_valid_out <= `SD 0;
      cdb1_NPC <= `SD 0;

      cdb2_result_out<= `SD 0;
      cdb2_ROB_out<= `SD 0;
      cdb2_PRN_out<= `SD 0;
      cdb2_take_branch<= `SD 0;
      cdb2_valid_out <= `SD 0;
      cdb2_NPC  <= `SD 0;
   end
   else
   begin
      cdb1_result_out<= `SD next_cdb1_result_out;
      cdb1_ROB_out<= `SD next_cdb1_ROB_out;
      cdb1_PRN_out<= `SD next_cdb1_PRN_out;
      cdb1_take_branch<= `SD next_cdb1_take_branch;
      cdb1_valid_out <= `SD next_cdb1_valid_out;
      cdb1_NPC <= `SD next_cdb1_NPC;

      cdb2_result_out<= `SD next_cdb2_result_out;
      cdb2_ROB_out<= `SD next_cdb2_ROB_out;
      cdb2_PRN_out<= `SD next_cdb2_PRN_out;
      cdb2_take_branch<= `SD next_cdb2_take_branch;
      cdb2_valid_out <= `SD next_cdb2_valid_out;
      cdb2_NPC <= `SD next_cdb2_NPC;
   end
end
endmodule
