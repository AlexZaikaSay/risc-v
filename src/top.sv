
`include "cpu.sv"
`include "mem.sv"
`include "imem.sv"

module top
(
    input  logic        clk,
    input  logic        rst
);

    logic [31:0] pc;
    logic [31:0] instr;
    logic [31:0] mem_addr;
    logic [31:0] mem_rd;
    logic [31:0] mem_wd;
    logic        we;

    cpu cpu (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instr(instr),
        .mem_addr(mem_addr),
        .read_data(mem_rd),
        .write_data(mem_wd),
        .we(we)
    );

    mem memory (
        .clk(clk),
        .addr(mem_addr),
        .data_out(mem_rd),
        .data_in(mem_wd),
        .we(we)
    );

    imem imem (
        .addr(pc),
        .data_out(instr)
    );

endmodule
