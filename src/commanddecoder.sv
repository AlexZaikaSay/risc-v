

module commanddecoder 
(
    input  logic [6:0] opcode,
    output logic [1:0] imm_src
);
    always_comb
    begin
        case (opcode)
            7'b0110011: // R-type
                imm_src     = 2'bxx;
            7'b0000011: // Load
                imm_src     = 2'b00;
            7'b0100011: // Store
                imm_src     = 2'b01;
            7'b1100011: // Branch
                imm_src     = 2'b10;
            7'b0010011: // I-type (arithmetic)
                imm_src     = 2'b00;
            7'b1101111: // JAL
                imm_src     = 2'b11;
            default: // Default case for unsupported opcodes
                imm_src     = 2'bxx;
        endcase
    end
endmodule
