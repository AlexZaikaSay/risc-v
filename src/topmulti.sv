
`include "cpumulti.sv"
`include "mem.sv"

module topmulti
# (
    parameter MEM_FILE = "",
    parameter IMEM_FILE = "",
    parameter REGS_FILE = ""
)
(
    input  logic        clk,
    input  logic        rst
);

    logic [31:0] instr;
    logic [31:0] addr;
    logic [31:0] mem_rd;
    logic [31:0] mem_wd;
    logic        we;
    logic [31:0] pc;

    cpumulti #(
        .REGS_FILE(REGS_FILE)
    ) cpu (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .read_data(mem_rd),
        .write_data(mem_wd),
        .we(we)
    );

    mem #(
        .MEM_FILE(MEM_FILE),
        .IMEM_FILE(IMEM_FILE)
    ) memory (
        .clk(clk),
        .addr(addr),
        .data_out(mem_rd),
        .data_in(mem_wd),
        .we(we)
    );


endmodule
