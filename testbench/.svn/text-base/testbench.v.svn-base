/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  testbench.v                                         //
//                                                                     //
//  Description :  Testbench module for the verisimple pipeline;       //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

extern void print_header(string str);
extern void print_cycles();
extern void print_another_cycles();
extern void print_stage(string div, int inst, int npc, int valid_inst);
extern void print_reg(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                      int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
extern void print_rege(int i,int p1,int p0);
extern void print_commit(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                      int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
extern void print_membus(int proc2mem_command, int mem2proc_response,
                         int proc2mem_addr_hi, int proc2mem_addr_lo,
                         int proc2mem_data_hi, int proc2mem_data_lo);
extern void print_close();
extern void print_new_line();
extern void print_new_line_reg();

// New stuff
extern void reg_close();
extern void check_reset(int);
extern void print_reg_header();


module testbench;

// Registers and wires used in the testbench
reg        clock;
reg        reset;
reg [31:0] clock_count;
reg [31:0] instr_count;
reg [63:0] PC;
integer    wb_fileno;

wire [1:0]  proc2mem_command;
wire [63:0] proc2mem_addr;
wire [63:0] proc2mem_data;
wire [3:0]  mem2proc_response;
wire [63:0] mem2proc_data;
wire [3:0]  mem2proc_tag;

wire [63:0] cachemem_data;
wire	    cachemem_valid;
wire [63:0] Dcachemem_data;
wire	    Dcachemem_valid;
wire        Dcache_store_en;
wire  [6:0] Dcache_store_idx;
wire [21:0] Dcache_store_tag;
wire  [6:0] Icache_rd_idx;
wire [21:0] Icache_rd_tag;
wire  [6:0] Icache_wr_idx;
wire [21:0] Icache_wr_tag;
wire	    Icache_wr_en;
wire  [6:0] Dcache_rd_idx;
wire [21:0] Dcache_rd_tag;
wire  [6:0] Dcache_wr_idx;
wire [21:0] Dcache_wr_tag;
wire	    Dcache_wr_en;
wire [3:0]  pipeline_completed_insts;
wire [3:0]  pipeline_error_status;

wire [4:0]  pipeline_commit_wr_idx1;
wire [63:0] pipeline_commit_wr_data1;
wire        pipeline_commit_wr_en1;
wire [63:0] pipeline_commit_NPC1;

wire [4:0]  pipeline_commit_wr_idx2;
wire [63:0] pipeline_commit_wr_data2;
wire        pipeline_commit_wr_en2;
wire [63:0] pipeline_commit_NPC2;

// output from IF stage
wire [63:0] if_NPC1_out;
wire [63:0] if_PC1_out;
wire [31:0] if_IR1_out;
wire        if_valid_inst1_out;
wire [63:0] if_NPC2_out;
wire [63:0] if_PC2_out;
wire [31:0] if_IR2_out;
wire        if_valid_inst2_out;

// output from IF/ID stage
wire [63:0] if_id_NPC1;
wire [63:0] if_id_PC1;
wire [31:0] if_id_IR1;
wire        if_id_valid_inst1;
wire [63:0] if_id_NPC2;
wire [63:0] if_id_PC2;
wire [31:0] if_id_IR2;
wire        if_id_valid_inst2;

// output from ID/RI stage
wire [63:0] id_ri_NPC1;
wire [63:0] id_ri_PC1;
wire [31:0] id_ri_IR1;
wire        id_ri_valid_inst1;
wire [63:0] id_ri_NPC2;
wire [63:0] id_ri_PC2;
wire [31:0] id_ri_IR2;
wire        id_ri_valid_inst2;

// output from RI/OOC stage
wire [63:0] ri_ooc_NPC1;
wire [63:0] ri_ooc_PC1;
wire [31:0] ri_ooc_IR1;
wire        ri_ooc_valid_inst1;
wire [63:0] ri_ooc_NPC2;
wire [63:0] ri_ooc_PC2;
wire [31:0] ri_ooc_IR2;
wire        ri_ooc_valid_inst2;

// output from Commit (After OOC)
wire [31:0] ooc_IR1;
wire [63:0] ooc_NPC1;
wire        ooc_valid_inst1;
wire [31:0] ooc_IR2;
wire [63:0] ooc_NPC2;
wire        ooc_valid_inst2;

// Instantiate the Pipeline
pipeline pipeline_0 (// Inputs
                     .clock             (clock),
                     .reset             (reset),
                     .mem2proc_response (mem2proc_response),
                     .mem2proc_data     (mem2proc_data),
                     .mem2proc_tag      (mem2proc_tag),

                     .cachemem_data     (cachemem_data),
                     .cachemem_valid    (cachemem_valid),

                     .Dcachemem_data    (Dcachemem_data),
                     .Dcachemem_valid   (Dcachemem_valid),
                      // Outputs
                     .proc2mem_command  (proc2mem_command),
                     .proc2mem_addr     (proc2mem_addr),
                     .proc2mem_data     (proc2mem_data),

                     .Icache_rd_idx     (Icache_rd_idx),
                     .Icache_rd_tag     (Icache_rd_tag),
                     .Icache_wr_idx     (Icache_wr_idx),
                     .Icache_wr_tag	    (Icache_wr_tag),
                     .Icache_wr_en      (Icache_wr_en),
                     .Dcache_rd_idx     (Dcache_rd_idx),
                     .Dcache_rd_tag     (Dcache_rd_tag),
                     .Dcache_wr_idx     (Dcache_wr_idx),
                     .Dcache_wr_tag     (Dcache_wr_tag),
                     .Dcache_wr_en      (Dcache_wr_en),
                     .Dcache_store_idx  (Dcache_store_idx),
                     .Dcache_store_tag  (Dcache_store_tag),
                     .Dcache_store_en   (Dcache_store_en),

                     .pipeline_completed_insts(pipeline_completed_insts),
                     .pipeline_error_status(pipeline_error_status),

                     .pipeline_commit_wr_data1(pipeline_commit_wr_data1),
                     .pipeline_commit_wr_idx1(pipeline_commit_wr_idx1),
                     .pipeline_commit_wr_en1(pipeline_commit_wr_en1),
                     .pipeline_commit_NPC1(pipeline_commit_NPC1),

                     .pipeline_commit_wr_data2(pipeline_commit_wr_data2),
                     .pipeline_commit_wr_idx2(pipeline_commit_wr_idx2),
                     .pipeline_commit_wr_en2(pipeline_commit_wr_en2),
                     .pipeline_commit_NPC2(pipeline_commit_NPC2),

                     .if_NPC1_out(if_NPC1_out),
                     .if_PC1_out(if_PC1_out),
                     .if_IR1_out(if_IR1_out),
                     .if_valid_inst1_out(if_valid_inst1_out),
                     .if_id_NPC1(if_id_NPC1),
                     .if_id_PC1(if_id_PC1),
                     .if_id_IR1(if_id_IR1),
                     .if_id_valid_inst1(if_id_valid_inst1),
                     .id_ri_NPC1(id_ri_NPC1),
                     .id_ri_PC1(id_ri_PC1),
                     .id_ri_IR1(id_ri_IR1),
                     .id_ri_valid_inst1(id_ri_valid_inst1),
                     .ri_ooc_NPC1(ri_ooc_NPC1),
                     .ri_ooc_PC1(ri_ooc_PC1),
                     .ri_ooc_IR1(ri_ooc_IR1),
                     .ri_ooc_valid_inst1(ri_ooc_valid_inst1),
                     .ooc_NPC1_out(ooc_NPC1),
                     .ooc_ROB_valid1_out(ooc_valid_inst1),
                     .ooc_IR1_out(ooc_IR1),

                     .if_NPC2_out(if_NPC2_out),
                     .if_PC2_out(if_PC2_out),
                     .if_IR2_out(if_IR2_out),
                     .if_valid_inst2_out(if_valid_inst2_out),
                     .if_id_NPC2(if_id_NPC2),
                     .if_id_PC2(if_id_PC2),
                     .if_id_IR2(if_id_IR2),
                     .if_id_valid_inst2(if_id_valid_inst2),
                     .id_ri_NPC2(id_ri_NPC2),
                     .id_ri_PC2(id_ri_PC2),
                     .id_ri_IR2(id_ri_IR2),
                     .id_ri_valid_inst2(id_ri_valid_inst2),
                     .ri_ooc_NPC2(ri_ooc_NPC2),
                     .ri_ooc_PC2(ri_ooc_PC2),
                     .ri_ooc_IR2(ri_ooc_IR2),
                     .ri_ooc_valid_inst2(ri_ooc_valid_inst2),
                     .ooc_NPC2_out(ooc_NPC2),
                     .ooc_ROB_valid2_out(ooc_valid_inst2),
                     .ooc_IR2_out(ooc_IR2)
                    );

// Instantiate the Data Memory
mem memory (// Inputs
          .clk               (clock),
          .proc2mem_command  (proc2mem_command),
          .proc2mem_addr     (proc2mem_addr),
          .proc2mem_data     (proc2mem_data),

           // Outputs

          .mem2proc_response (mem2proc_response),
          .mem2proc_data     (mem2proc_data),
          .mem2proc_tag      (mem2proc_tag)
         );

cachemem128x64 cachememory (//Inputs
	  .clock	     (clock),
	  .reset	     (reset),
	  .wr1_en	     (Icache_wr_en),
	  .wr1_idx	     (Icache_wr_idx),
	  .wr1_tag	     (Icache_wr_tag),
	  .wr1_data	     (mem2proc_data),
	  
	  .rd1_idx	     (Icache_rd_idx),
	  .rd1_tag	     (Icache_rd_tag),

	  .rd1_data	     (cachemem_data),
	  .rd1_valid     (cachemem_valid)
	);


dcachemem128x64 dcachememory (//Inputs
	  .clock	     (clock),
	  .reset	     (reset),
	  .wr1_en	     (Dcache_wr_en),
	  .wr1_idx	     (Dcache_wr_idx),
	  .wr1_tag	     (Dcache_wr_tag),
	  .wr1_data	     (mem2proc_data),

      .wr2_en        (Dcache_store_en),
	  .wr2_idx	     (Dcache_store_idx),
	  .wr2_tag	     (Dcache_store_tag),
	  .wr2_data	     (proc2mem_data),
	  
	  .rd1_idx	     (Dcache_rd_idx),
	  .rd1_tag	     (Dcache_rd_tag),

	  .rd1_data	     (Dcachemem_data),
	  .rd1_valid     (Dcachemem_valid)
	);

// Generate System Clock
always
begin
  #(`VERILOG_CLOCK_PERIOD/2.0);
  clock = ~clock;
end

// Task to display # of elapsed clock edges
task show_clk_count;
      real cpi;

      begin
	 cpi = (clock_count + 1.0) / instr_count;
	 $display("@@  %0d cycles / %0d instrs = %f CPI\n@@",
		  clock_count+1, instr_count, cpi);
         $display("@@  %4.2f ns total time to execute\n@@\n",
                  clock_count*`VIRTUAL_CLOCK_PERIOD);
      end
      
endtask  // task show_clk_count 

// Show contents of a range of Unified Memory, in both hex and decimal
task show_mem_with_decimal;
 input [31:0] start_addr;
 input [31:0] end_addr;
 integer k;
 integer showing_data;
 begin
  $display("@@@");
  showing_data=0;
  for(k=start_addr;k<=end_addr; k=k+1)
    if (memory.unified_memory[k] != 0)
    begin
      $display("@@@ mem[%5d] = %x : %0d", k*8, memory.unified_memory[k], 
                                               memory.unified_memory[k]);
      showing_data=1;
    end
    else if(showing_data!=0)
    begin
      $display("@@@");
      showing_data=0;
    end
  $display("@@@");
 end
endtask  // task show_mem_with_decimal

initial
begin
  `ifdef DUMP
    $vcdplusdeltacycleon;
    $vcdpluson();
    $vcdplusmemon(memory.unified_memory);
  `endif

  //$monitor("pipeline_completed_insts:%d\ninstr count:%d", 
  //         pipeline_completed_insts, instr_count);

  clock = 1'b0;
  reset = 1'b0;

  // Pulse the reset signal
  $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
  reset = 1'b1;
  @(posedge clock);
  @(posedge clock);

  $readmemh("program.mem", memory.unified_memory);

  @(posedge clock);
  @(posedge clock);
  `SD;
  // This reset is at an odd time to avoid the pos & neg clock edges

  reset = 1'b0;
  $display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);

  wb_fileno = $fopen("writeback.out");

  //Open header AFTER throwing the reset otherwise the reset state is displayed
  print_header("                                                                              D-MEM Bus &\n");
  print_header("Cycle:      IF      |     ID      |     RI      |     OOC     |     CMT       Reg Result");
end

// Count the number of posedges and number of instructions completed
// till simulation ends
always @(posedge clock or posedge reset)
begin
  if(reset)
  begin
    clock_count <= `SD 0;
    instr_count <= `SD 0;
  end
  else
  begin
    //$display("instCount:%d, pipeCompleteCount:%d", instr_count, pipeline_completed_insts);
    clock_count <= `SD (clock_count + 1);
    instr_count <= `SD (instr_count + pipeline_completed_insts);
  end
end  


always @(negedge clock)
begin

  if(reset)
    $display("@@\n@@  %t : System STILL at reset, can't show anything\n@@",
             $realtime);
  else
  begin
    `SD;
    `SD;

     //$display("pipeline_completed_insts: %d", pipeline_completed_insts);
    
     // print the piepline stuff via c code to the pipeline.out
     print_cycles();
     print_stage(" ", if_IR1_out, if_NPC1_out[31:0], {31'b0,if_valid_inst1_out});
     print_stage("|", if_id_IR1, if_id_NPC1[31:0], {31'b0,if_id_valid_inst1});
     print_stage("|", id_ri_IR1, id_ri_NPC1[31:0], {31'b0,id_ri_valid_inst1});
     print_stage("|", ri_ooc_IR1, ri_ooc_NPC1[31:0], {31'b0,ri_ooc_valid_inst1});
     print_stage("|", ooc_IR1, ooc_NPC1[31:0], {31'b0,ooc_valid_inst1});
     print_reg(pipeline_commit_wr_data1[63:32], pipeline_commit_wr_data1[31:0],
               {27'b0,pipeline_commit_wr_idx1}, {31'b0,pipeline_commit_wr_en1});
     print_commit(pipeline_commit_wr_data1[63:32], pipeline_commit_wr_data1[31:0],
               {27'b0,pipeline_commit_wr_idx1}, {31'b0,pipeline_commit_wr_en1});
     print_membus({30'b0,proc2mem_command}, {28'b0,mem2proc_response},
                  proc2mem_addr[63:32], proc2mem_addr[31:0],
                  proc2mem_data[63:32], proc2mem_data[31:0]);
     print_rege({27'b0,pipeline_commit_wr_idx1},
                  pipeline_commit_wr_data1[63:32], pipeline_commit_wr_data1[31:0]);
     print_new_line();
     print_another_cycles();
     print_stage(" ", if_IR2_out, if_NPC2_out[31:0], {31'b0,if_valid_inst2_out});
     print_stage("|", if_id_IR2, if_id_NPC2[31:0], {31'b0,if_id_valid_inst2});
     print_stage("|", id_ri_IR2, id_ri_NPC2[31:0], {31'b0,id_ri_valid_inst2});
     print_stage("|", ri_ooc_IR2, ri_ooc_NPC2[31:0], {31'b0,ri_ooc_valid_inst2});
     print_stage("|", ooc_IR2, ooc_NPC2[31:0], {31'b0,ooc_valid_inst2});
     print_reg(pipeline_commit_wr_data2[63:32], pipeline_commit_wr_data2[31:0],
               {27'b0,pipeline_commit_wr_idx2}, {31'b0,pipeline_commit_wr_en2});
     print_commit(pipeline_commit_wr_data2[63:32], pipeline_commit_wr_data2[31:0],
               {27'b0,pipeline_commit_wr_idx2}, {31'b0,pipeline_commit_wr_en2});
     print_membus({30'b0,proc2mem_command}, {28'b0,mem2proc_response},
                  proc2mem_addr[63:32], proc2mem_addr[31:0],
                  proc2mem_data[63:32], proc2mem_data[31:0]);
     print_rege({27'b0,pipeline_commit_wr_idx2},
                  pipeline_commit_wr_data2[63:32], pipeline_commit_wr_data2[31:0]);
     print_new_line();

     // These part generate output for writeback.out

     if(pipeline_completed_insts >= 2) 
     begin
       if(pipeline_commit_wr_en1)
         $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x",
                   pipeline_commit_NPC1,
                   pipeline_commit_wr_idx1,
                   pipeline_commit_wr_data1);
       else
         $fdisplay(wb_fileno, "PC=%x, ---",
                   pipeline_commit_NPC1);

       if(pipeline_commit_wr_en2)
         $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x",
                   pipeline_commit_NPC2,
                   pipeline_commit_wr_idx2,
                   pipeline_commit_wr_data2);
       else
         $fdisplay(wb_fileno, "PC=%x, ---",
                   pipeline_commit_NPC2);
     end

     else if(pipeline_completed_insts == 1)
     begin
       if(pipeline_commit_wr_en1)
         $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x",
                   pipeline_commit_NPC1,
                   pipeline_commit_wr_idx1,
                   pipeline_commit_wr_data1);
       else if(pipeline_commit_wr_en2)
         $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x",
                   pipeline_commit_NPC2,
                   pipeline_commit_wr_idx2,
                   pipeline_commit_wr_data2);
       else
         $fdisplay(wb_fileno, "PC=%x, ---",
                   pipeline_commit_NPC1);
     end

    // deal with any halting conditions

    if(pipeline_error_status!=`NO_ERROR)
    begin
      $display("@@@ Unified Memory contents hex on left, decimal on right: ");
      show_mem_with_decimal(0,`MEM_64BIT_LINES - 1); 
        // 8Bytes per line, 16kB total

      $display("@@  %t : System halted\n@@", $realtime);

      case(pipeline_error_status)
        `HALTED_ON_MEMORY_ERROR:  
            $display("@@@ System halted on memory error");
        `HALTED_ON_HALT:          
            $display("@@@ System halted on HALT instruction");
        `HALTED_ON_ILLEGAL:
            $display("@@@ System halted on illegal instruction");
        default: 
            $display("@@@ System halted on unknown error code %x",
                     pipeline_error_status);
      endcase
      $display("@@@\n@@");
      show_clk_count;
      print_close(); // close the pipe_print output file
      $fclose(wb_fileno);
      $finish;
    end
  end  // if(reset)	 
end 

endmodule  // module testbench

