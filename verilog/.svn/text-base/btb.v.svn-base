module btb(
                clock,
                reset,
                take_branch1_in,
                target_pc1_in,
                unconditional_branch1,
                conditional_branch1,
                unconditional_branch2,
                conditional_branch2,
                take_branch2_in,
                target_pc2_in,
                ROB_pc1,
                ROB_pc2,
                valid_inst1_in,
                valid_inst2_in,

                current_pc1,
                current_pc2,

                //outputs
                valid1_out,
                target_pc1_btb_out,

                valid2_out,
                target_pc2_btb_out
           );

input         clock;
input         reset;

input  [63:0] current_pc1;
input  [63:0] current_pc2;

input  [63:0] ROB_pc1;
input  [63:0] ROB_pc2;
input         take_branch1_in;        // taken-branch signal
input  [63:0] target_pc1_in;          // target pc: use if take_branch is TRUE
input         take_branch2_in;        // taken-branch signal
input  [63:0] target_pc2_in;          // target pc: use if take_branch is TRUE
input         valid_inst1_in;
input         valid_inst2_in;

input         unconditional_branch1;
input         conditional_branch1;
input         unconditional_branch2;
input         conditional_branch2;

output        valid1_out;
output [63:0] target_pc1_btb_out;

output        valid2_out;
output [63:0] target_pc2_btb_out;

wire    [1:0] prediction1; 
wire    [1:0] prediction2; 
wire          valid1;
wire          valid2;
wire   [63:0] next_pc_btb1;
wire   [63:0] next_pc_btb2;

wire          uncond_branch;
wire          ROB_br1_history_found_on_BTB;
wire          ROB_br2_history_found_on_BTB;

reg           valid      [63:0];
reg    [63:0] pc         [63:0];
reg     [1:0] prediction [63:0];
reg    [63:0] target_pc  [63:0];

reg     [1:0] next_prediction1;
reg     [1:0] next_prediction2;

integer j;

assign ROB_br1_history_found_on_BTB = (ROB_pc1 == pc[ROB_pc1[7:2]]);
assign ROB_br2_history_found_on_BTB = (ROB_pc2 == pc[ROB_pc2[7:2]]);

// update prediction from ROB
always @*
begin   
  next_prediction1 = 2'b01;
  if(unconditional_branch1)
    next_prediction1 = 2'b11;

  else if(conditional_branch1)
  begin
    if(ROB_br1_history_found_on_BTB)
    begin
      if(take_branch1_in)
      begin
        if(prediction[ROB_pc1[7:2]] == 2'b11)
          next_prediction1 = prediction[ROB_pc1[7:2]];
        else
          next_prediction1 = prediction[ROB_pc1[7:2]] + 2'b01; 
      end
      else
      begin
        if(prediction[ROB_pc1[7:2]] == 2'b00)
          next_prediction1 = prediction[ROB_pc1[7:2]];
        else
          next_prediction1 = prediction[ROB_pc1[7:2]] - 2'b01;
      end
    end
    else  // if branch inst PC is no on the BTB
    begin
      if(take_branch1_in)
        next_prediction1 = 2'b10;
      else
        next_prediction1 = 2'b01;
    end
  end

  next_prediction2 = 2'b01;
  if(unconditional_branch2)
    next_prediction2 = 2'b11;

  else if(conditional_branch2)
  begin
    if(ROB_br2_history_found_on_BTB)
    begin
      if(take_branch2_in)
      begin
        if(prediction[ROB_pc2[7:2]] == 2'b11)
          next_prediction2 = prediction[ROB_pc2[7:2]];
        else
          next_prediction2 = prediction[ROB_pc2[7:2]] + 2'b01;
      end
      else
      begin
        if(prediction[ROB_pc2[7:2]] == 2'b00)
          next_prediction2 = prediction[ROB_pc2[7:2]];
        else
          next_prediction2 = prediction[ROB_pc2[7:2]] - 2'b01;
      end
    end    
    else  // if branch inst PC is no on the BTB
    begin
      if(take_branch2_in)
        next_prediction2 = 2'b10;
      else
        next_prediction2 = 2'b01;
    end
  end
end

//Outputs for Target Address
assign prediction1 = prediction[current_pc1[7:2]];
assign prediction2 = prediction[current_pc2[7:2]];

assign valid1 = (current_pc1 == pc[current_pc1[7:2]]) && valid[current_pc1[7:2]] && (prediction1[1] == 1'b1);
assign valid2 = (current_pc2 == pc[current_pc2[7:2]]) && valid[current_pc2[7:2]] && (prediction2[1] == 1'b1);

assign next_pc_btb1 = target_pc[current_pc1[7:2]];
assign next_pc_btb2 = target_pc[current_pc2[7:2]];

assign valid1_out = valid1 && valid_inst1_in;
assign target_pc1_btb_out =  valid1 && valid_inst1_in ? next_pc_btb1 : 64'b0;

assign valid2_out = valid2 && valid_inst2_in;
assign target_pc2_btb_out =  valid2 && valid_inst2_in ? next_pc_btb2 : 64'b0;


always @(posedge clock)
begin   
   if(reset)
   begin
      for(j = 0; j < 64; j=j+1)
      begin
         valid[j] <= `SD 1'b0;
         prediction[j] <= `SD 2'b01;
         target_pc[j] <= `SD 64'b0;
         pc[j] <= `SD 64'b0;
      end
   end
   else
   begin
      if(unconditional_branch1 || conditional_branch1)
      begin
         valid[ROB_pc1[7:2]] <= `SD 1'b1;
         prediction[ROB_pc1[7:2]] <= `SD next_prediction1;
         target_pc[ROB_pc1[7:2]] <= `SD target_pc1_in;
         pc[ROB_pc1[7:2]] <= `SD ROB_pc1;
     end
     else if(unconditional_branch2 || conditional_branch2)
     begin
         valid[ROB_pc2[7:2]] <= `SD 1'b1;
         prediction[ROB_pc2[7:2]] <= `SD next_prediction2;
         target_pc[ROB_pc2[7:2]] <= `SD target_pc2_in;
         pc[ROB_pc2[7:2]] <= `SD ROB_pc2;
     end
   end     
end
endmodule
