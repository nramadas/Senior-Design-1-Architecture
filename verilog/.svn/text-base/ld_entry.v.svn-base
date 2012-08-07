module ld_entry(//inputs:
           reset,
           clock,

           ld_entry_load1_in,
           ld_entry_load2_in,

           ld_entry_use_enable,
           ld_entry_mem_value_valid_in,
           ld_entry_mem_addr_invalid_in,

           ld_entry_cdb1_in,
           ld_entry_cdb1_tag,
           ld_entry_cdb1_valid,

           ld_entry_cdb2_in,
           ld_entry_cdb2_tag,
           ld_entry_cdb2_valid,

           ld_entry_color_commit_in,
           ld_entry_color_commit_valid_in,

           ld_entry_dest_PRN1_in,
           ld_entry_regb1_in,
           ld_entry_regb1_tag_in,
           ld_entry_regb1_valid,
           ld_entry_ROB1_in,
           ld_entry_rd_mem1_in,
           ld_entry_IR1_in,
           ld_entry_instr_valid1_in,
           ld_entry_color1_in,
           ld_entry_no_color1_in,

           ld_entry_dest_PRN2_in,
           ld_entry_regb2_in,
           ld_entry_regb2_tag_in,
           ld_entry_regb2_valid,
           ld_entry_ROB2_in,
           ld_entry_rd_mem2_in,
           ld_entry_IR2_in,
           ld_entry_instr_valid2_in,
           ld_entry_color2_in,
           ld_entry_no_color2_in,

           // output
           ld_entry_avail_out, 
           ld_entry_ready_out,

           ld_entry_dest_tag_out,
           ld_entry_address_out,
           ld_entry_ROB_out,
           mem_in_process
          );

input          reset;
input          clock;

input          ld_entry_load1_in;
input          ld_entry_load2_in;

input          ld_entry_use_enable;
input          ld_entry_mem_value_valid_in;
input          ld_entry_mem_addr_invalid_in;

input   [63:0] ld_entry_cdb1_in;
input    [6:0] ld_entry_cdb1_tag;
input          ld_entry_cdb1_valid;

input   [63:0] ld_entry_cdb2_in;
input    [6:0] ld_entry_cdb2_tag;
input          ld_entry_cdb2_valid;

input    [2:0] ld_entry_color_commit_in;
input          ld_entry_color_commit_valid_in;

input    [6:0] ld_entry_dest_PRN1_in;
input   [63:0] ld_entry_regb1_in;
input    [6:0] ld_entry_regb1_tag_in;
input          ld_entry_regb1_valid;
input    [5:0] ld_entry_ROB1_in;
input          ld_entry_rd_mem1_in;
input   [31:0] ld_entry_IR1_in;
input          ld_entry_instr_valid1_in;
input    [2:0] ld_entry_color1_in;
input          ld_entry_no_color1_in;

input    [6:0] ld_entry_dest_PRN2_in;
input   [63:0] ld_entry_regb2_in;
input    [6:0] ld_entry_regb2_tag_in;
input          ld_entry_regb2_valid;
input    [5:0] ld_entry_ROB2_in;
input          ld_entry_rd_mem2_in;
input   [31:0] ld_entry_IR2_in;
input          ld_entry_instr_valid2_in;
input    [2:0] ld_entry_color2_in;
input          ld_entry_no_color2_in;

output         ld_entry_avail_out;
output         ld_entry_ready_out;

output  [63:0] ld_entry_address_out;
output   [6:0] ld_entry_dest_tag_out;
output   [5:0] ld_entry_ROB_out;
output         mem_in_process;

reg      [6:0] dest_tag;
reg     [63:0] regb;
reg      [6:0] regb_tag;
reg            regb_valid;
reg      [5:0] ROB_num;
reg     [31:0] IR;
reg      [2:0] color;
reg            store_complete;
reg            mem_in_process;

reg            in_use;

wire           LoadAFromCDB1;  // signal to load from the CDB
wire           LoadAFromCDB2;  // signal to load from the CDB

assign ld_entry_avail_out = ~in_use;
assign ld_entry_ready_out = in_use && regb_valid && store_complete;

assign ld_entry_dest_tag_out = mem_in_process ? dest_tag : 0;
assign ld_entry_ROB_out = mem_in_process ? ROB_num : 0;
assign ld_entry_address_out = mem_in_process ? (regb + {{48{IR[15]}},IR[15:0]}) : 64'b0;

// Has the tag we are waiting for shown up on the CDB 
assign LoadAFromCDB1 = (ld_entry_cdb1_tag == regb_tag) && (ld_entry_cdb1_tag != 7'd31) && !regb_valid &&
                       in_use && ld_entry_cdb1_valid;
assign LoadAFromCDB2 = (ld_entry_cdb2_tag == regb_tag) && (ld_entry_cdb2_tag != 7'd31) && !regb_valid &&
                       in_use && ld_entry_cdb2_valid;


always @(posedge clock) 
begin 
   if (reset) 
   begin 
      dest_tag <= `SD 7'd31; 
      regb <= `SD 64'b0;
      regb_tag <= `SD 7'b0; 
      regb_valid <= `SD 1'b0;
      in_use <= `SD 1'b0;
      ROB_num <= `SD 6'b0;
      IR <= `SD 64'b0;
      color <= `SD 3'b0;
      store_complete <= `SD 1'b0;
      mem_in_process <= `SD 1'b0;
   end 
   else
   begin 
      if (ld_entry_load1_in && ld_entry_rd_mem1_in && ld_entry_instr_valid1_in)
      begin
         dest_tag <= `SD ld_entry_dest_PRN1_in; 
         regb <= `SD ld_entry_regb1_in;
         regb_tag <= `SD ld_entry_regb1_tag_in; 
         regb_valid <= `SD ld_entry_regb1_valid;
         IR <= `SD ld_entry_IR1_in;
         ROB_num <= `SD ld_entry_ROB1_in;
         color <= `SD ld_entry_color1_in;
         in_use <= `SD 1'b1;

         // If no color
         if(ld_entry_no_color1_in)
         begin
            //$display("store complete cuz there aint no store");
            store_complete <= `SD 1'b1;
         end
         else
            store_complete <= `SD 1'b0;

         // Ships passing in the night
         if(ld_entry_cdb1_tag == ld_entry_regb1_tag_in && (ld_entry_cdb1_tag != 7'd31))
         begin
            //$display("regb valid - ships");
            regb <= `SD ld_entry_cdb1_in;
            regb_valid <= `SD ld_entry_cdb1_valid;
         end
         if(ld_entry_cdb2_tag == ld_entry_regb1_tag_in && (ld_entry_cdb2_tag != 7'd31))
         begin
            regb <= `SD ld_entry_cdb2_in;
            regb_valid <= `SD ld_entry_cdb2_valid;
         end
         if(ld_entry_color_commit_valid_in && (ld_entry_color_commit_in==ld_entry_color1_in))
            store_complete <= `SD 1'b1;
      end
      else if (ld_entry_load2_in && ld_entry_rd_mem2_in && ld_entry_instr_valid2_in)
      begin
         dest_tag <= `SD ld_entry_dest_PRN2_in; 
         regb <= `SD ld_entry_regb2_in;
         regb_tag <= `SD ld_entry_regb2_tag_in; 
         regb_valid <= `SD ld_entry_regb2_valid;
         IR <= `SD ld_entry_IR2_in;
         ROB_num <= `SD ld_entry_ROB2_in;
         color <= `SD ld_entry_color2_in;
         in_use <= `SD 1'b1;
         // If no color
         if(ld_entry_no_color2_in)
         begin
            store_complete <= `SD 1'b1;
         end
         else
            store_complete <= `SD 1'b0;

         // Ships passing in the night
         if(ld_entry_cdb1_tag == ld_entry_regb2_tag_in && (ld_entry_cdb1_tag != 7'd31))
         begin
            regb <= `SD ld_entry_cdb1_in;
            regb_valid <= `SD ld_entry_cdb1_valid;
         end
         if(ld_entry_cdb2_tag == ld_entry_regb2_tag_in && (ld_entry_cdb2_tag != 7'd31))
         begin
            regb <= `SD ld_entry_cdb2_in;
            regb_valid <= `SD ld_entry_cdb2_valid;
         end
         if(ld_entry_color_commit_valid_in && (ld_entry_color_commit_in==ld_entry_color2_in))
            store_complete <= `SD 1'b1;
      end
      else
      begin
         if(LoadAFromCDB1)
         begin
            regb <= `SD ld_entry_cdb1_in;
            regb_valid <= `SD ld_entry_cdb1_valid;
         end
         if(LoadAFromCDB2)
         begin
            regb <= `SD ld_entry_cdb2_in;
            regb_valid <= `SD ld_entry_cdb2_valid;
         end
         if(ld_entry_color_commit_valid_in && (ld_entry_color_commit_in==color))
            store_complete <= `SD 1'b1;

         if(ld_entry_use_enable)
            mem_in_process <= `SD 1'b1;

         if(mem_in_process && (ld_entry_mem_value_valid_in || ld_entry_mem_addr_invalid_in))
         begin
            in_use <= `SD 1'b0;
            mem_in_process <= `SD 1'b0;
         end
      end
   end
end // end always

endmodule
