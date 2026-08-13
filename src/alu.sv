module alu #(
    parameter int N = 32
) (
    input  logic [2:0] alu_op,
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] result,
    output logic  c
);

    logic [N-1:0] and_out;
    logic [N-1:0] or_out;
    logic [N-1:0] add_out;
    logic [N-1:0] b_in;
    logic slt;

    always @*
    begin

        if (alu_op[0]) 
            b_in = ~b + 1;
        else 
            b_in = b;

        {c, add_out} = a + b_in;
        and_out = a & b;
        or_out  = a | b;

        slt = (~(alu_op[0] ^ b[N-1] ^ a[N-1]) & (add_out[N-1] ^ a[N-1]) & ~alu_op[1]) ^ add_out[N-1];

        casez (alu_op)
            3'b00?: result = add_out;
            3'b010: result = and_out;
            3'b011: result = or_out;
            3'b101: result = { {(N-1){1'b0}}, slt};
            default: result = {N{1'bz}};
        endcase
    end
endmodule
