// Number of cachelines. must update both on a change
`define ICACHE_IDX_BITS       5      // log2(ICACHE_LINES)
`define ICACHE_LINES (1<<`ICACHE_IDX_BITS)

module icache(
  // inputs
  clock,
  reset,
  
  Imem2proc_response,
  Imem2proc_data,
  Imem2proc_tag,

  proc2Icache_addr,
  cachemem_data,
  cachemem_valid,
  mispredict,

  // outputs
  proc2Imem_command,
  proc2Imem_addr,

  Icache_data_out,
  Icache_valid_out,   

  current_index,
  current_tag,
  last_index,
  last_tag,
  data_write_enable

);

  input         clock;
  input         reset;
  input   [3:0] Imem2proc_response;
  input  [63:0] Imem2proc_data;
  input   [3:0] Imem2proc_tag;
  //input         is_current_pc;
  input  [63:0] proc2Icache_addr;
  input  [63:0] cachemem_data;
  input         cachemem_valid;
  input         mispredict;


 
  output  [1:0] proc2Imem_command;
  output [63:0] proc2Imem_addr;

  //ouptuts to processor
  output [63:0] Icache_data_out;     // value is memory[proc2Icache_addr]
  output        Icache_valid_out;    // when this is high

 
  output  [6:0] current_index;
  output [21:0] current_tag;
  output  [6:0] last_index;
  output [21:0] last_tag;
  output        data_write_enable;

  reg    [63:0] prefetch_pc;

  reg      [15:0] valid_storage;
  reg     [63:0] addr_storage [15:0];

  wire    [6:0] current_index;
  wire   [21:0] current_tag;
  wire          changed_addr;
  reg     [6:0] prev_index;
  reg    [21:0] prev_tag;

  wire          start_pretch; 
  wire   [63:0] Icache_data_out;
  wire   [63:0] next_prefetch_pc;

  integer i;


  assign changed_addr = (prev_index!=current_index) || (prev_tag!=current_tag);

  assign start_prefetch = (!cachemem_valid && (Imem2proc_response!=4'b0) && !changed_addr); //&& !mispredict; 

  assign {current_tag, current_index} = proc2Icache_addr[31:3];
   
  /*always @(posedge clock)
  begin
  $display("Current Index: %d | Prev Index: %d | Fetch Request: %h | Imem2proc_response: %d | Imem2proc_tag: %d | Imem2proc_data: %h | Addr Request: %h | Prefetch Request: %h | Icache_data_out: %h | Start Prefetch? %h | WriteEn %d", current_index,prev_index,proc2Icache_addr,Imem2proc_response, Imem2proc_tag, Imem2proc_data, proc2Imem_addr, prefetch_pc, Icache_data_out, start_prefetch, data_write_enable);
  end
*/

  assign Icache_data_out  = cachemem_data;
  assign Icache_valid_out = cachemem_valid;


  assign proc2Imem_addr = (start_prefetch) ? {prefetch_pc[63:3],3'b0} : {proc2Icache_addr[63:3],3'b0};

  assign proc2Imem_command = (reset) ? `BUS_NONE : `BUS_LOAD;

  assign data_write_enable = (valid_storage[Imem2proc_tag]) && (Imem2proc_tag!=0);

  assign {last_tag, last_index} = addr_storage[Imem2proc_tag][31:3];
  assign next_prefetch_pc = prefetch_pc + 8;

  always @(posedge clock)
  begin
     if(reset)
     begin
        for(i = 0; i < 16; i = i + 1)
        begin
           addr_storage[i] <= `SD 0;
        end
        valid_storage <= `SD 0;
        prefetch_pc <= `SD 0;
        prev_index <= `SD 0;
        prev_tag <= `SD 0;
     end
     else
     begin
        prev_index <= `SD current_index;
        prev_tag   <= `SD current_tag;
        addr_storage[Imem2proc_response] <= `SD proc2Imem_addr;
        valid_storage[Imem2proc_response] <= `SD 1'b1;

        if(start_prefetch)
           prefetch_pc <= `SD next_prefetch_pc;
        else
           prefetch_pc <= `SD proc2Icache_addr;   

        if(data_write_enable)
           valid_storage[Imem2proc_tag] <= `SD 1'b0;
     end
  end

endmodule

