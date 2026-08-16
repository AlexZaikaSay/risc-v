
module maindecoder 
(
    input  logic [6:0] opcode,
    output logic       branch,
    output logic [1:0] result_src,
    output logic       mem_write,
    output logic       alu_src,
    output logic [1:0] imm_src,
    output logic       reg_write,
    output logic [1:0] alu_op,
    output logic       jump
);
    always_comb
    begin
        case (opcode)
            7'b0110011: // R-type
            begin
                branch      = 1'b0;
                result_src  = 2'b00;
                mem_write   = 1'b0;
                alu_src     = 1'b0;
                imm_src     = 2'bxx;
                reg_write   = 1'b1;
                alu_op      = 2'b10;
                jump        = 1'b0;
            end

            7'b0000011: // Load
            begin
                branch      = 1'b0;
                result_src  = 2'b01;
                mem_write   = 1'b0;
                alu_src     = 1'b1;
                imm_src     = 2'b00;
                reg_write   = 1'b1;
                alu_op      = 2'b00;
                jump        = 1'b0;
            end

            7'b0100011: // Store
            begin
                branch      = 1'b0;
                result_src  = 2'bxx; // Don't care
                mem_write   = 1'b1;
                alu_src     = 1'b1;
                imm_src     = 2'b01;
                reg_write   = 1'b0;
                alu_op      = 2'b00;
                jump        = 1'b0;
            end

            7'b1100011: // Branch
            begin
                branch      = 1'b1;
                result_src  = 2'bxx; // Don't care
                mem_write   = 1'b0;
                alu_src     = 1'b0;
                imm_src     = 2'b10;
                reg_write   = 1'b0;
                alu_op      = 2'b01;
                jump        = 1'b0;
            end
            7'b0010011: // I-type (arithmetic)
            begin
                branch      = 1'b0;
                result_src  = 2'b00;
                mem_write   = 1'b0;
                alu_src     = 1'b1;
                imm_src     = 2'b00;
                reg_write   = 1'b1;
                alu_op      = 2'b10;
                jump        = 1'b0;
            end
            7'b1101111: // JAL
            begin
                branch      = 1'b0;
                result_src  = 2'b10;
                mem_write   = 1'b0;
                alu_src     = 1'bx; // Don't care
                imm_src     = 2'b11;
                reg_write   = 1'b1;
                alu_op      = 2'bxx; // Don't care
                jump        = 1'b1;
            end
            default: // Default case for unsupported opcodes
            begin
                branch      = 1'bx;
                result_src  = 2'bxx;
                mem_write   = 1'bx;
                alu_src     = 1'bx;
                imm_src     = 2'bxx;
                reg_write   = 1'bx;
                alu_op      = 2'bxx;
                jump        = 1'bx;
            end
        endcase
    end
endmodule
