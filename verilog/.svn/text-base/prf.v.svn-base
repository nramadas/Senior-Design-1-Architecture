/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  prf.v                                               //
//                                                                     //
//  Description :  				                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module prf(rda2_idx, rda2_out, //rda2_en,               
           rdb2_idx, rdb2_out, //rdb2_en,            
           rda1_idx, rda1_out, //rda1_en,
           rdb1_idx, rdb1_out, //rdb1_en,
	   rda2_valid_out, rdb2_valid_out, rda1_valid_out, rdb1_valid_out,
           wr_idx1, wr_data1, wr_idx2, wr_data2,
           wr_en, wr_en1, wr_en2, wr_en3, wr_clk, wr_valid1, wr_valid2,
           wr_idx3, wr_idx4, wr_en4, wr_en5,
	   RRAT_free_list, Branch_Mispredict	
	   ); // write port
	       

  input   [6:0] rda1_idx, rdb1_idx, rda2_idx, rdb2_idx, wr_idx1, wr_idx2, wr_valid1, wr_valid2;
  input  [63:0] wr_data1, wr_data2;
  input         wr_en, wr_en1, wr_en2, wr_en3, wr_clk;
  input         wr_en4, wr_en5;
  input   [6:0] wr_idx3, wr_idx4;

  input  [95:0] RRAT_free_list;
  input         Branch_Mispredict;
  output [63:0] rda2_out, rdb2_out, rda1_out, rdb1_out;
  output        rda2_valid_out, rdb2_valid_out, rda1_valid_out, rdb1_valid_out;
  
  reg    [63:0] rda1_out, rdb1_out, rda2_out, rdb2_out;
  reg 		rda2_valid_out, rdb2_valid_out, rda1_valid_out, rdb1_valid_out;
  reg    [63:0] registers[95:0];   // 96, 64-bit Registers
  reg    [95:0] valid;

  wire   [63:0] rda2_reg;
  wire   [63:0] rdb2_reg; 
  wire   [63:0] rda1_reg;
  wire   [63:0] rdb1_reg; 
  wire          rdb2_valid;
  wire          rda2_valid;
  wire          rdb1_valid;
  wire          rda1_valid;

  wire [95:0] next_valid;

  assign rda1_valid  = valid[rda1_idx];
  assign rda2_valid  = valid[rda2_idx];
  assign rdb1_valid  = valid[rdb1_idx];
  assign rdb2_valid  = valid[rdb2_idx];

  assign rda1_reg = registers[rda1_idx];
  assign rda2_reg = registers[rda2_idx];
  assign rdb1_reg = registers[rdb1_idx];
  assign rdb2_reg = registers[rdb2_idx];

  integer i;

  //
  // Read port A1
  //
  always @*
   begin
      rda1_out = rda1_reg;
      rda1_valid_out = 1'b0;

      if (rda1_idx == {2'b0,`ZERO_REG})
      begin
         rda1_out = 0;
         rda1_valid_out = 1'b1;
      end
      else if (wr_en && (wr_idx1 == rda1_idx))
      begin
         rda1_out = wr_data1;  // internal forwarding
         rda1_valid_out = 1'b1;
      end
      else if(wr_en1 && (wr_idx2 == rda1_idx))
      begin
         rda1_out = wr_data2;
         rda1_valid_out = 1'b1;
      end
      else if(rda1_valid)
      begin
         rda1_out = rda1_reg;
         rda1_valid_out = 1'b1;
      end
   end
  //
  // Read port A2
  //
  always @*
  begin
     rda2_out = rda2_reg;
     rda2_valid_out = 1'b0;
 
     if (rda2_idx == {2'b0,`ZERO_REG})
     begin
        rda2_out = 0;
        rda2_valid_out = 1'b1;
     end
     else if (wr_en && (wr_idx1 == rda2_idx))
     begin
        rda2_out = wr_data1;  // internal forwarding
        rda2_valid_out = 1'b1;
     end
     else if(wr_en1 && (wr_idx2 == rda2_idx))
     begin
        rda2_out = wr_data2;
        rda2_valid_out = 1'b1;
     end
     else if(rda2_valid)
     begin
        rda2_out = rda2_reg;
        rda2_valid_out = 1'b1;
     end
  end

 //
  // Read port B1
  //
  always @*
  begin
     rdb1_out = rdb1_reg;
     rdb1_valid_out = 1'b0;

     if (rdb1_idx == {2'b0,`ZERO_REG})
     begin
        rdb1_out = 0;
        rdb1_valid_out = 1'b1;
     end
     else if (wr_en && (wr_idx1 == rdb1_idx))
     begin
        rdb1_out = wr_data1;  // internal forwarding
        rdb1_valid_out = 1'b1;
     end
     else if(wr_en1 && (wr_idx2 == rdb1_idx))
     begin
        rdb1_out = wr_data2;
        rdb1_valid_out = 1'b1;
     end
     else if(rdb1_valid)
     begin
        rdb1_out = rdb1_reg;
        rdb1_valid_out = 1'b1;
     end
  end

 //
  // Read port B2
  //
  always @*
  begin
     rdb2_out = rdb2_reg;
     rdb2_valid_out = 1'b0;

     if (rdb2_idx == {2'b0,`ZERO_REG})
     begin
        rdb2_out = 0;
        rdb2_valid_out = 1'b1;
     end
     else if (wr_en && (wr_idx1 == rdb2_idx))
     begin
        rdb2_out = wr_data1;  // internal forwarding
        rdb2_valid_out = 1'b1;
     end
     else if(wr_en1 && (wr_idx2 == rdb2_idx))
     begin
        rdb2_out = wr_data2;
        rdb2_valid_out = 1'b1;
     end
     else if(rdb2_valid)
     begin
        rdb2_out = rdb2_reg;
        rdb2_valid_out = 1'b1;
     end
  end

  assign next_valid = ~RRAT_free_list & valid; 
  //
  // Write port
  //
  always @(posedge wr_clk)
  begin
     if (wr_en1 && !Branch_Mispredict)
     begin
        registers[wr_idx2] <= `SD wr_data2;
        valid[wr_idx2] <= `SD 1'b1;
     end

     if (wr_en2  && !Branch_Mispredict)
     begin
        valid[wr_valid1] <= `SD 1'b0;
     end

     if (wr_en3 && !Branch_Mispredict)
     begin
        valid[wr_valid2] <= `SD 1'b0;
     end

     if (wr_en4)
     begin
        valid[wr_idx3] <= `SD 1'b0;
     end

     if (wr_en5)
     begin
        valid[wr_idx4] <= `SD 1'b0;
     end

     if (wr_en  && !Branch_Mispredict)
     begin
        registers[wr_idx1] <= `SD wr_data1;
        valid[wr_idx1] <= `SD 1'b1;
     end

     if (Branch_Mispredict)
     begin
        valid <= `SD next_valid; 
     end
  end

endmodule 
