module testbench;
	reg [3:0] enc;
	wire [15:0] gnt;

    pd test_pd(enc, gnt);

	initial 
	begin
		$monitor("enc:%b gnt:%b", enc, gnt);
		enc = 0;
		repeat (16)
			#5 enc = enc + 1;
 	end // initial

endmodule
