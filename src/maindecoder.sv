
module maindecoder 
(
    input  logic [6:0] opcode,
    output logic       branch,
    output logic       result_src,
    output logic       mem_write,
    output logic       alu_src,
    output logic [1:0] imm_src,
    output logic       reg_write,
    output logic [1:0] alu_op
);
    always_comb
    begin
        case (opcode)
            7'b0110011: // R-type
            begin
                branch      = 1'b0;
                result_src  = 1'b0;
                mem_write   = 1'b0;
                alu_src     = 1'b0;
                imm_src     = 2'bxx;
                reg_write   = 1'b1;
                alu_op      = 2'b10;
            end

            7'b0000011: // Load
            begin
                branch      = 1'b0;
                result_src  = 1'b1;
                mem_write   = 1'b0;
                alu_src     = 1'b1;
                imm_src     = 2'b00;
                reg_write   = 1'b1;
                alu_op      = 2'b00;
            end

            7'b0100011: // Store
            begin
                branch      = 1'b0;
                result_src  = 1'bx; // Don't care
                mem_write   = 1'b1;
                alu_src     = 1'b1;
                imm_src     = 2'b01;
                reg_write   = 1'b0;
                alu_op      = 2'b00;
            end

            7'b1100011: // Branch
            begin
                branch      = 1'b1;
                result_src  = 1'bx; // Don't care
                mem_write   = 1'b0;
                alu_src     = 1'b0;
                imm_src     = 2'b10;
                reg_write   = 1'b0;
                alu_op      = 2'b01;
            end

            default: // Default case for unsupported opcodes
            begin
                branch      = 1'bx;
                result_src  = 1'bx;
                mem_write   = 1'bx;
                alu_src     = 1'bx;
                imm_src     = 2'bxx;
                reg_write   = 1'bx;
                alu_op      = 2'bxx; 
            end
        endcase
    end
endmodule
