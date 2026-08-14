
module ff (
    input logic clk,
    input logic rst,
    input logic [31:0] d,
    output logic [31:0] q
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 32'b0;
        else
            q <= d;
    end
endmodule
