`define SD #1

module dcachemem128x64(clock, reset, 
			wr1_en, wr1_tag, wr1_idx, wr1_data,
                        wr2_en, wr2_tag, wr2_idx, wr2_data,
			rd1_tag, rd1_idx, rd1_data, rd1_valid);

input clock, reset, wr1_en, wr2_en;
input [6:0] wr1_idx, rd1_idx, wr2_idx;
input [21:0] wr1_tag, rd1_tag, wr2_tag;
input [63:0] wr1_data, wr2_data; 

output [63:0] rd1_data;
output rd1_valid;

reg [63:0] data [127:0];
reg [21:0] tags [127:0]; 
reg [127:0] valids;

assign rd1_data = data[rd1_idx];
assign rd1_valid = valids[rd1_idx] && (tags[rd1_idx] == rd1_tag);

always @(posedge clock)
begin
  if(reset) valids <= `SD 128'b0;
  else
  begin 
  if(wr1_en) 
    valids[wr1_idx] <= `SD 1;
  if(wr2_en)
    valids[wr2_idx] <= `SD 1;
  end
end

always @(posedge clock)
begin
  if(wr1_en)
  begin
    data[wr1_idx] <= `SD wr1_data;
    tags[wr1_idx] <= `SD wr1_tag;
  end
  if(wr2_en)
  begin
    data[wr2_idx] <= `SD wr2_data;
    tags[wr2_idx] <= `SD wr2_tag;
  end
end

endmodule
