// This is an 4 stage pipelined 
// multiplier that multiplies 2 64-bit integers and returns the low 64 bits 
// of the result.  This is not an ideal multiplier but is sufficient to 
// allow a faster clock period than straight *
// This module instantiates 8 pipeline stages as an array of submodules.
module mult(clock,
           reset,
           enable,
           mplier,
           mcand,
           ROB_num_in,
           dest_PRN_in,
           start,

           product,
           ROB_num_out,
           dest_PRN_out,
           done);

  input         clock, reset, start, enable;
  input  [63:0] mcand, mplier;
  input   [5:0] ROB_num_in;
  input   [6:0] dest_PRN_in;

  output [63:0] product;
  output  [5:0] ROB_num_out;
  output  [6:0] dest_PRN_out;
  output        done;

  wire   [63:0] mcand_out, mplier_out;
  //wire    [5:0] ROB_number_out;
  //wire    [6:0] dest_PR_num_out;

  wire [(3*64)-1:0] internal_products, internal_mcands, internal_mpliers;
  wire  [(3*6)-1:0] internal_ROB_num;
  wire  [(3*7)-1:0] internal_PRN_num;
  wire        [2:0] internal_dones;

  mult_stage mstage [3:0](.enable(enable),
                          .clock(clock),
                          .reset(reset),
                          .product_in({internal_products,64'h0}),
                          .mplier_in({internal_mpliers,mplier}),
                          .mcand_in({internal_mcands,mcand}),
                          .ROB_num_in({internal_ROB_num,ROB_num_in}),
                          .PRN_num_in({internal_PRN_num,dest_PRN_in}),
                          .start({internal_dones,start}),

                          .product_out({product,internal_products}),
                          .mplier_out({mplier_out,internal_mpliers}),
                          .mcand_out({mcand_out,internal_mcands}),
                          .ROB_num_out({ROB_num_out,internal_ROB_num}),
                          .PRN_num_out({dest_PRN_out,internal_PRN_num}),
                          .done({done,internal_dones}));

endmodule
