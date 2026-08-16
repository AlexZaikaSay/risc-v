
`include "cpu.sv"
`include "mem.sv"
`include "imem.sv"

module top
# (
    parameter IMEM_FILE = "",
    parameter MEM_FILE = "",
    parameter REGS_FILE = ""
)
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] pc_start
);

    logic [31:0] instr;
    logic [31:0] mem_addr;
    logic [31:0] mem_rd;
    logic [31:0] mem_wd;
    logic        we;
    logic [31:0] pc;

    cpu #(
        .REGS_FILE(REGS_FILE)
    ) cpu (
        .clk(clk),
        .rst(rst),
        .pc_start(pc_start),
        .pc(pc),
        .instr(instr),
        .mem_addr(mem_addr),
        .read_data(mem_rd),
        .write_data(mem_wd),
        .we(we)
    );

    mem #(
        .MEM_FILE(MEM_FILE)
    ) memory (
        .clk(clk),
        .addr(mem_addr),
        .data_out(mem_rd),
        .data_in(mem_wd),
        .we(we)
    );

    imem #(
        .IMEM_FILE(IMEM_FILE)
    ) imem (
        .addr(pc),
        .data_out(instr)
    );

endmodule
