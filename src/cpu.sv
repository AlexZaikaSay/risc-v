
`include "ff.sv"
`include "mux2_1.sv"
`include "mux3_1.sv"
`include "alu.sv"
`include "regs.sv"
`include "signext.sv"
`include "controlblock.sv"

module cpu
# (
    parameter REGS_FILE = ""
)
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr,
    input  logic [31:0] read_data,
    input  logic [31:0] pc_start,
    output logic [31:0] pc,
    output logic [31:0] mem_addr,
    output logic [31:0] write_data,
    output logic        we
);

    logic [31:0] pc_next;
    logic [31:0] pc_plus4;
    logic [31:0] pc_target;
    logic [31:0] src_a;
    logic [31:0] src_b;
    logic [31:0] result;
    logic        zero;
    logic [31:0] imm_ext;
    logic [1:0]  imm_src;
    logic [2:0]  alu_control;
    logic        alu_src;
    logic [1:0]  result_src;
    logic        reg_write;
    logic        pc_src;

    ff pc_ff (
        .clk(clk),
        .rst(rst),
        .d(pc_next),
        .start_value(pc_start),
        .q(pc)
    );

    mux2_1 pc_mux (
        .a(pc_plus4),
        .b(pc_target),
        .sel(pc_src),
        .y(pc_next)
    );

    mux2_1 src_b_mux (
        .a(write_data),
        .b(imm_ext),
        .sel(alu_src),
        .y(src_b) 
    );

    mux3_1 result_mux (
        .a(mem_addr),
        .b(read_data),
        .c(pc_plus4),
        .sel(result_src),
        .y(result)
    );

    regs #(
        .REGS_FILE(REGS_FILE)
    ) regs_file (
        .clk(clk),
        .we3(reg_write),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .rd1(src_a),
        .rd2(write_data),
        .wd3(result)
    );

    signext sign_ext (
        .instr(instr),
        .ext_op(imm_src),
        .extended(imm_ext)
    );

    alu alu_unit (
        .a(src_a),
        .b(src_b),
        .alu_op(alu_control),
        .result(mem_addr),
        .z(zero),
        .c()
    );

    controlblock ctrl_block (
        .opcode(instr[6:0]),
        .funct7_5_(instr[30]),
        .funct3(instr[14:12]),
        .zero(zero),
        .pc_src(pc_src),
        .result_src(result_src),
        .mem_write(we),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write)
    );

    assign pc_plus4 = pc + 4;
    assign pc_target = pc + imm_ext;

endmodule

