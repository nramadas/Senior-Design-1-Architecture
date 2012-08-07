// Number of cachelines. must update both on a change
`define dcache_IDX_BITS       5      // log2(dcache_LINES)
`define dcache_LINES (1<<`dcache_IDX_BITS)

module dcache(
  // inputs
  clock,
  reset,
  
  dmem2proc_response,
  dmem2proc_data,
  dmem2proc_tag,

  proc2dcache_addr,
  proc2dcache_command,
  proc2dcache_data,

  dcachemem_data,
  dcachemem_valid,  

  // outputs
  proc2dmem_command,
  proc2dmem_addr,
  proc2dmem_data,

  dcache_data_out,
  dcache_valid_out,   

  current_index,
  current_tag,
  last_index,
  last_tag,
  store_index,
  store_tag,
  store_write_enable,
  data_write_enable

);

  input         clock;
  input         reset;
  input   [3:0] dmem2proc_response;
  input  [63:0] dmem2proc_data;
  input   [3:0] dmem2proc_tag;

  input  [63:0] proc2dcache_addr;
  input   [1:0] proc2dcache_command;
  input  [63:0] proc2dcache_data;

  input  [63:0] dcachemem_data;
  input         dcachemem_valid;


 
  output  [1:0] proc2dmem_command;
  output [63:0] proc2dmem_addr;
  output [63:0] proc2dmem_data;

  //ouptuts to processor
  output [63:0] dcache_data_out;     // value is memory[proc2dcache_addr]
  output        dcache_valid_out;    // when this is high

 
  output  [6:0] current_index;
  output [21:0] current_tag;
  output  [6:0] last_index;
  output [21:0] last_tag;
  output  [6:0] store_index;
  output [21:0] store_tag;
  output        store_write_enable;
  output        data_write_enable;

  reg     [3:0] current_mem_tag;

  reg           miss_outstanding;

  wire    [6:0] current_index;
  wire   [21:0] current_tag;

  assign {current_tag, current_index} = proc2dcache_addr[31:3];

  assign {store_tag, store_index} = proc2dcache_addr[31:3];
  assign store_write_enable = (proc2dcache_command  == `BUS_STORE) ? 1'b1 : 1'b0;

  reg     [6:0] last_index;
  reg    [21:0] last_tag;

  wire changed_addr = (current_index!=last_index) || (current_tag!=last_tag);

  wire send_request = miss_outstanding && !changed_addr;

  wire   [63:0] dcache_data_out = dcachemem_data;

  assign dcache_valid_out = dcachemem_valid && (proc2dcache_command!=`BUS_NONE); 

  assign proc2dmem_addr = {proc2dcache_addr[63:3],3'b0};
  assign proc2dmem_data = proc2dcache_data;
  assign proc2dmem_command = (proc2dcache_command  == `BUS_STORE) ? `BUS_STORE :
                             (miss_outstanding && !changed_addr && (proc2dcache_command  == `BUS_LOAD)) ? `BUS_LOAD : `BUS_NONE;

  wire data_write_enable = (current_mem_tag==dmem2proc_tag) && (current_mem_tag!=0);

  wire update_mem_tag = changed_addr | miss_outstanding | data_write_enable;

  wire unanswered_miss = 
      changed_addr ? !dcache_valid_out
                   : miss_outstanding & (dmem2proc_response==0);

  always @(posedge clock)
  begin
    //$display("proc2dcache_command:%d", proc2dcache_command);
    //$display("proc2dmem_command:%d", proc2dmem_command);
    if(reset)
    begin
      last_index       <= `SD -1;   // These are -1 to get ball rolling when
      last_tag         <= `SD -1;   // reset goes low because addr "changes"
      current_mem_tag  <= `SD 0;              
      miss_outstanding <= `SD 0;
    end
    else
    begin
      last_index       <= `SD current_index;
      last_tag         <= `SD current_tag;
      miss_outstanding <= `SD unanswered_miss;
      if(update_mem_tag)
        current_mem_tag <= `SD dmem2proc_response;
    end
  end

endmodule

