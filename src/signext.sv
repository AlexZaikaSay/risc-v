
module signext
(
    /* verilator lint_off UNUSED */
    input logic[31:0] instr,
    /* verilator lint_on UNUSED */
    input logic[1:0] ext_op,
    output logic[31:0] extended
);
    
    always @(instr[31:7] or ext_op)
    begin
        case (ext_op)
            // I-type
            2'b00: extended = {{21{instr[31]}}, instr[30:20]};
            // S-type
            2'b01: extended = {{21{instr[31]}}, instr[30:25], instr[11:7]}; 
            // B-type
            2'b10: extended = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; 
            // J-type
            2'b11: extended = {{13{instr[31]}}, instr[19:12], instr[20], instr[30:21]};
        endcase
    end
endmodule
