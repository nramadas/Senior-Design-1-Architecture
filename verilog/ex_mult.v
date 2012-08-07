module ex_mult(
	      //inputs
          clock,
          reset,

          mult1_stall,
          mult0_stall,

          // instruction 1 to mult
          ex_opa1_mult_in,
          ex_opb1_mult_in,
          ex_dest_PRN1_mult_in,
          ex_cond_branch1_mult_in,
          ex_uncond_branch1_mult_in,
          ex_NPC1_mult_in, 
          ex_IR1_mult_in,
          ex_alu_func1_mult_in,
          ex_ROB1_mult_in,
          ex_opa1_select,
          ex_opb1_select,
          ex_valid1,

          // instruction 2 to mult
          ex_opa2_mult_in,
          ex_opb2_mult_in,
          ex_dest_PRN2_mult_in,
          ex_cond_branch2_mult_in,
          ex_uncond_branch2_mult_in,
          ex_NPC2_mult_in, 
          ex_IR2_mult_in,
          ex_alu_func2_mult_in,
          ex_ROB2_mult_in,
          ex_opa2_select,
          ex_opb2_select,
          ex_valid2,

          //outputs
          ex_mult1_result_out,
          ex_mult2_result_out,
          ex_ROB2_mult_out,
          ex_ROB1_mult_out,
          ex_dest_PRN1_mult_out,
          ex_dest_PRN2_mult_out,
          mult0_done,
          mult1_done);

input         clock, reset;

input  [63:0] ex_opa1_mult_in;            // This ex' opa 
input  [63:0] ex_opb1_mult_in;            // This ex' opb 
input   [6:0] ex_dest_PRN1_mult_in;       // This ex' destination tag  
input         ex_cond_branch1_mult_in;
input         ex_uncond_branch1_mult_in;
input  [63:0] ex_NPC1_mult_in;            // PC+4 to EX for target address
input  [31:0] ex_IR1_mult_in;
input   [4:0] ex_alu_func1_mult_in;
input   [5:0] ex_ROB1_mult_in;            // ROB number passed into the FU
input   [1:0] ex_opa1_select;
input   [1:0] ex_opb1_select;	
	
input  [63:0] ex_opa2_mult_in;            // This ex' opa 
input  [63:0] ex_opb2_mult_in;            // This ex' opb 
input   [6:0] ex_dest_PRN2_mult_in;       // This ex' destination tag  
input         ex_cond_branch2_mult_in;
input         ex_uncond_branch2_mult_in;
input  [63:0] ex_NPC2_mult_in;            // PC+4 to EX for target address
input  [31:0] ex_IR2_mult_in;
input   [4:0] ex_alu_func2_mult_in;
input   [5:0] ex_ROB2_mult_in;            // ROB number passed into the FU
input   [1:0] ex_opa2_select;
input   [1:0] ex_opb2_select;

input         mult0_stall;
input         mult1_stall;
input	      ex_valid1;
input         ex_valid2;

reg    [63:0] opa_mux_out1, opb_mux_out1;
reg    [63:0] opa_mux_out2, opb_mux_out2;

output [63:0] ex_mult1_result_out;
output  [5:0] ex_ROB1_mult_out;
output  [6:0] ex_dest_PRN1_mult_out;
output [63:0] ex_mult2_result_out;
output  [5:0] ex_ROB2_mult_out;
output  [6:0] ex_dest_PRN2_mult_out;
output        mult0_done;
output        mult1_done;

wire          start0, start1;
wire   [63:0] ex_mult1_result_out;
wire    [5:0] ex_ROB1_mult_out;
wire    [6:0] ex_dest_PRN1_mult_out;
wire   [63:0] ex_mult2_result_out;
wire    [5:0] ex_ROB2_mult_out;
wire    [6:0] ex_dest_PRN2_mult_out;

wire [63:0] alu_imm1 = { 56'b0, ex_IR1_mult_in[20:13] };
wire [63:0] alu_imm2 = { 56'b0, ex_IR2_mult_in[20:13] };

assign start0 = (ex_valid1)  ? 1'b1 : 1'b0;
assign start1 = (ex_valid2)  ? 1'b1 : 1'b0;

mult m0 (.enable(~mult0_stall),
         .clock(clock),
         .reset(reset),
         .mplier(opa_mux_out1),
         .mcand(opb_mux_out1),
         .ROB_num_in(ex_ROB1_mult_in),
         .dest_PRN_in(ex_dest_PRN1_mult_in),
         .start(start0),

         .product(ex_mult1_result_out),
         .ROB_num_out(ex_ROB1_mult_out),
         .dest_PRN_out(ex_dest_PRN1_mult_out),
         .done(mult0_done));


mult m1 (.enable(~mult1_stall),
         .clock(clock),
         .reset(reset),
         .mplier(opa_mux_out2),
         .mcand(opb_mux_out2),
         .ROB_num_in(ex_ROB2_mult_in),
         .dest_PRN_in(ex_dest_PRN2_mult_in),
         .start(start1), 

         .product(ex_mult2_result_out),
         .ROB_num_out(ex_ROB2_mult_out),
         .dest_PRN_out(ex_dest_PRN2_mult_out),
         .done(mult1_done));

//
// ALU opA mux
//
always @*
begin
   opa_mux_out1 = 64'hbaadbeefdeadbeef;
   case (ex_opa1_select)
     `ALU_OPA_IS_REGA:     opa_mux_out1 = ex_opa1_mult_in;
   endcase
end

//
// ALU opB mux
//
always @*
begin
   // Default value, Set only because the case isnt full.  If you see this
   // value on the output of the mux you have an invalid opb_select
   opb_mux_out1 = 64'hbaadbeefdeadbeef;
   case (ex_opb1_select)
     `ALU_OPB_IS_REGB:     opb_mux_out1 = ex_opb1_mult_in;
     `ALU_OPB_IS_ALU_IMM:  opb_mux_out1 = alu_imm1;
   endcase 
end

//
// ALU opA mux
//
always @*
begin
   opa_mux_out2 = 64'hbaadbeefdeadbeef;
   case (ex_opa2_select)
     `ALU_OPA_IS_REGA:     opa_mux_out2 = ex_opa2_mult_in;
   endcase
end

//
// ALU opB mux
//
always @*
begin
   // Default value, Set only because the case isnt full.  If you see this
   // value on the output of the mux you have an invalid opb_select
   opb_mux_out2 = 64'hbaadbeefdeadbeef;
   case (ex_opb2_select)
     `ALU_OPB_IS_REGB:     opb_mux_out2 = ex_opb2_mult_in;
     `ALU_OPB_IS_ALU_IMM:  opb_mux_out2 = alu_imm2;
   endcase 
end

endmodule
