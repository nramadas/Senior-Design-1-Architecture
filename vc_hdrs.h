/*************************************

   Version Y-2006.06_Full64 -- Thu Dec  4 18:06:25 2008

   Copyright (c) 1991-2006 by Synopsys Inc.

   Induced headers for external functions.
   Only actually called external functions.

*************************************/

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _VC_TYPES_
#define _VC_TYPES_
/* common definitions shared with DirectC.h */

typedef unsigned int U;
typedef unsigned char UB;
typedef unsigned char scalar;
typedef struct { U c; U d;} vec32;

#define scalar_0 0
#define scalar_1 1
#define scalar_z 2
#define scalar_x 3

extern long long int ConvUP2LLI(U* a);
extern void ConvLLI2UP(long long int a1, U* a2);
typedef struct VeriC_Descriptor *vc_handle;

#endif /* _VC_TYPES_ */



extern void print_rege(int i, int p1, int p0);
extern void print_reg(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo, int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
extern void print_cycles(void);
extern void print_header(const char* str);
extern void print_membus(int proc2mem_command, int mem2proc_response, int proc2mem_addr_hi, int proc2mem_addr_lo,
       int proc2mem_data_hi, int proc2mem_data_lo);
extern void print_commit(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo, int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
extern void print_stage(const char* div, int inst, int npc, int valid_inst);
extern void print_new_line(void);
extern void print_close(void);
extern void print_another_cycles(void);

#ifdef __cplusplus
}
#endif

