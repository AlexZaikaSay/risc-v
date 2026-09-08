
`include "ff.sv"
`include "ffen.sv"
`include "mux2_1.sv"
`include "mux3_1.sv"
`include "alu.sv"
`include "regs.sv"
`include "signext.sv"
`include "controlblockmulti.sv"

module cpumulti
# (
    parameter REGS_FILE = ""
)
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] read_data,
    output logic [31:0] addr,
    output logic [31:0] write_data,
    output logic        we
);

    logic        zero;
    logic        pc_write;
    logic        ir_write;
    logic        addr_src;
    logic [1:0]  alu_src_a;
    logic [1:0]  alu_src_b;
    logic [2:0]  alu_control;
    logic [1:0]  result_src;
    logic        reg_write;

    logic [31:0] pc;
    logic [31:0] result;
    logic [31:0] alu_result;
    logic [31:0] instr;
    logic [31:0] old_pc;
    logic [31:0] data;
    logic [31:0] rd1;
    logic [31:0] rd2;
    logic [31:0] alu_out;
    logic [31:0] src_a;
    logic [31:0] src_b;
    logic [31:0] a;
    logic [31:0] imm_ext;
    logic [1:0]  imm_src;

    ffen pc_ff (
        .clk(clk),
        .rst(rst),
        .d(result),
        .q(pc),
        .enabled(pc_write)
    );

    mux2_1 pc_mux (
        .a(pc),
        .b(result),
        .sel(addr_src),
        .y(addr)
    );

    ffen old_pc_ff (
        .clk(clk),
        .rst(rst),
        .d(pc),
        .q(old_pc),
        .enabled(ir_write)
    );

    ffen instr_ff (
        .clk(clk),
        .rst(rst),
        .d(read_data),
        .q(instr),
        .enabled(ir_write)
    );

    ff data_ff (
        .clk(clk),
        .rst(rst),
        .d(read_data),
        .q(data)
    );

    regs #(
        .REGS_FILE(REGS_FILE)
    ) regs_file (
        .clk(clk),
        .we3(reg_write),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .rd1(rd1),
        .rd2(rd2),
        .wd3(result)
    );

    ff rd1_ff (
        .clk(clk),
        .rst(rst),
        .d(rd1),
        .q(a)
    );

    ff rd2_ff (
        .clk(clk),
        .rst(rst),
        .d(rd2),
        .q(write_data)
    );

    signext sign_ext (
        .instr(instr),
        .ext_op(imm_src),
        .extended(imm_ext)
    );

    mux3_1 src_a_mux (
        .a(pc),
        .b(old_pc),
        .c(a),
        .sel(alu_src_a),
        .y(src_a)
    );

    mux3_1 src_b_mux (
        .a(write_data),
        .b(imm_ext),
        .c(32'd4),
        .sel(alu_src_b),
        .y(src_b)
    );

    alu alu_unit (
        .a(src_a),
        .b(src_b),
        .alu_op(alu_control),
        .result(alu_result),
        .z(zero),
        .c()
    );

    ff alu_result_ff (
        .clk(clk),
        .rst(rst),
        .d(alu_result),
        .q(alu_out)
    );

    mux3_1 result_mux (
        .a(alu_out),
        .b(data),
        .c(alu_result),
        .sel(result_src),
        .y(result)
    );


    controlblockmulti ctrl_block (
        .clk(clk),
        .rst(rst),
        .opcode(instr[6:0]),
        .funct7_5_(instr[30]),
        .funct3(instr[14:12]),
        .zero(zero),
        .pc_write(pc_write),
        .addr_src(addr_src),
        .mem_write(we),
        .ir_write(ir_write),
        .result_src(result_src),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_control(alu_control),
        .imm_src(imm_src),
        .reg_write(reg_write)
    );


endmodule

