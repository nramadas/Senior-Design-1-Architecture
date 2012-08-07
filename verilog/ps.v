// Vikas Khurana
// EECS 470
// 47310641


module ps2(req, en, gnt, req_up);

	input [1:0] req;
	input en;
	output [1:0] gnt;
	output req_up;

	assign req_up = req[0] | req[1]; // returns true if either line has a request
	assign gnt[0] = en & ~req[1] & req[0];
	assign gnt[1] = en & req[1];

endmodule
// 4 bit
module ps4(req, en, gnt, req_up);

	input [3:0] req;
	input en;
	output [3:0] gnt;
	output req_up;
	
	wire [3:0] tmp;
	wire [1:0] tmp_req_up;
	wire [1:0] out;	
	
	ps2 right(.req(req[1:0]), .en(en),  .gnt(tmp[1:0]), .req_up(tmp_req_up[0]));
	ps2 left(.req(req[3:2]), .en(en), .gnt(tmp[3:2]), .req_up(tmp_req_up[1]));
	ps2 top(.req(tmp_req_up), .en(en), .gnt(out), .req_up(req_up));
	// Determine Correct Grant Output based on Req_up Bit
	assign gnt[3:0] = (out == 2'b01) ? {2'b00,tmp[1:0]}: {tmp[3:2],2'b00};// Concat 		

endmodule
// 8 bit
module ps8(req, en, gnt, req_up);

        input [7:0] req;
        input en;
        output [7:0] gnt;
        output req_up;

        wire [7:0] tmp;
        wire [1:0] tmp_req_up;
        wire [1:0] out;

        ps4 right(.req(req[3:0]), .en(en), .gnt(tmp[3:0]), .req_up(tmp_req_up[0]));
        ps4 left(.req(req[7:4]), .en(en), .gnt(tmp[7:4]), .req_up(tmp_req_up[1]));
	ps2 top(.req(tmp_req_up), .en(en), .gnt(out), .req_up(req_up));       
 
	assign gnt[7:0] = (out == 2'b01) ? {4'b0000,tmp[3:0]}:{tmp[7:4], 4'b0000}; 

endmodule

module ps16(req, en, gnt, req_up);
       input [15:0] req;
        input en;
        output [15:0] gnt;
        output req_up;

        wire [15:0] tmp;
        wire [1:0] tmp_req_up;
        wire [1:0] out;

        ps8 right(.req(req[7:0]), .en(en), .gnt(tmp[7:0]), .req_up(tmp_req_up[0]));
        ps8 left(.req(req[15:8]), .en(en), .gnt(tmp[15:8]), .req_up(tmp_req_up[1]));
	ps2 top(.req(tmp_req_up), .en(en), .gnt(out), .req_up(req_up));       
 
	assign gnt[15:0] = (out == 2'b01) ? {8'b00000000,tmp[7:0]}:{tmp[15:8], 8'b00000000}; 
endmodule

