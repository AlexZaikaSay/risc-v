
`include "maindecoder.sv"
`include "aludecoder.sv"

module controlblock
(
    input  logic [6:0] opcode,
    input  logic       funct7_5_,
    input  logic [2:0] funct3,
    input  logic       zero,
    output logic       pc_src,
    output logic       result_src,
    output logic       mem_write,
    output logic [2:0] alu_control,
    output logic       alu_src,
    output logic [1:0] imm_src,
    output logic       reg_write
);

    logic branch;
    logic [1:0] alu_op;

    assign pc_src = branch & zero;

    maindecoder main_decoder (
        .opcode(opcode),
        .branch(branch),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write),
        .alu_op(alu_op)
    );

    aludecoder alu_decoder (
        .opcode_5_(opcode[5]),
        .func7_5_(funct7_5_),
        .func3(funct3),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );


endmodule
