// This is one stage of an 8 stage (9 depending on how you look at it)
// pipelined multiplier that multiplies 2 64-bit integers and returns
// the low 64 bits of the result.  This is not an ideal multiplier but
// is sufficient to allow a faster clock period than straight *
module mult_stage(clock,
                  reset,
                  enable,
                  product_in,
                  mplier_in,
                  mcand_in,
                  ROB_num_in,
                  PRN_num_in,
                  start,

                  product_out,
                  mplier_out,
                  mcand_out,
                  ROB_num_out,
                  PRN_num_out,
                  done);

  input         clock,  reset,  start,  enable;
  input [63:0]  product_in, mplier_in, mcand_in;
  input  [5:0]  ROB_num_in;
  input  [6:0]  PRN_num_in;

  output        done;
  output [63:0] product_out, mplier_out, mcand_out;
  output  [5:0] ROB_num_out;
  output  [6:0] PRN_num_out;

  reg  [63:0]   prod_in_reg, partial_prod_reg;
  wire [63:0]   partial_product, next_mplier, next_mcand;
  wire  [5:0]   next_ROB_num;
  wire  [6:0]   next_PRN_num;

  reg [63:0]    mplier_out, mcand_out;
  reg  [5:0]    ROB_num_out;
  reg  [6:0]    PRN_num_out;
  reg done;

  assign product_out = prod_in_reg + partial_prod_reg;
  assign partial_product = mplier_in[15:0] * mcand_in;

  assign next_mplier = {16'b0,mplier_in[63:16]};
  assign next_mcand = {mcand_in[47:0],16'b0};
  assign next_ROB_num = ROB_num_in;
  assign next_PRN_num = PRN_num_in;

  always @(posedge clock)
  begin
    if(enable)
    begin
    prod_in_reg      <= #1 product_in;
    partial_prod_reg <= #1 partial_product;
    mplier_out       <= #1 next_mplier;
    mcand_out        <= #1 next_mcand;
    ROB_num_out      <= #1 next_ROB_num;
    PRN_num_out      <= #1 next_PRN_num;
    end
  end

  always @(posedge clock)
  begin
    if(reset)
      done <= #1 1'b0;
    else
      done <= #1 start;
  end

endmodule

