
module mux3_1
(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,
    input  logic [1:0]  sel,
    output logic [31:0] y
);

    assign y = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b10) ? c :
               32'bx; // Default case for unsupported sel values

endmodule
