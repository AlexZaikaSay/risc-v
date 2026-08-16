
module aludecoder 
(
    input  logic opcode_5_,
    input  logic func7_5_,
    input  logic [2:0] func3,
    input  logic [1:0] alu_op,
    output logic [2:0] alu_control
);
    always_comb
    begin
        case (alu_op)
            2'b00: // Load/Store
                alu_control = 3'b000; // ADD
            2'b01: // Branch
                alu_control = 3'b001; // SUB
            2'b10: // R-type
            begin
                casez ({func3, opcode_5_, func7_5_})
                    5'b000_00: alu_control = 3'b000; // ADD
                    5'b000_01: alu_control = 3'b000; // ADD
                    5'b000_10: alu_control = 3'b000; // ADD
                    5'b000_11: alu_control = 3'b001; // SUB
                    5'b010_??: alu_control = 3'b101; // SLT
                    5'b110_??: alu_control = 3'b011; // OR
                    5'b111_??: alu_control = 3'b010; // AND
                    default: alu_control = 3'bxxx; // Don't care
                endcase
            end
            default: // Default case for unsupported alu_op
                alu_control = 3'bxxx; // Don't care
        endcase
    end
endmodule
