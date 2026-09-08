
`include "mainfsm.sv"
`include "commanddecoder.sv"
`include "aludecoder.sv"

module controlblockmulti
(
    input  logic       clk,
    input  logic       rst,
    input  logic [6:0] opcode,
    input  logic       funct7_5_,
    input  logic [2:0] funct3,
    input  logic       zero,
    output logic       pc_write,
    output logic       reg_write,
    output logic       mem_write,
    output logic       ir_write,
    output logic [1:0] result_src,
    output logic [1:0] alu_src_a,
    output logic [1:0] alu_src_b,
    output logic       addr_src,
    output logic [2:0] alu_control,
    output logic [1:0] imm_src
);

    logic branch;
    logic pc_update;
    logic [1:0] alu_op;

    assign pc_write = (branch & (zero ^ funct3[0])) | pc_update;

    mainfsm main_fsm (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .branch(branch),
        .pc_update(pc_update),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .ir_write(ir_write),
        .result_src(result_src),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .addr_src(addr_src),
        .alu_op(alu_op)
    );

    aludecoder alu_decoder (
        .opcode_5_(opcode[5]),
        .func7_5_(funct7_5_),
        .func3(funct3),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    commanddecoder command_decoder (
        .opcode(opcode),
        .imm_src(imm_src)
    );


endmodule
