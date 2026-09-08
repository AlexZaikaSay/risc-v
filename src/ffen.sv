
module ffen
(
    input logic clk,
    input logic rst,
    input logic enabled,
    input logic [31:0] d,
    output logic [31:0] q
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 0;
        else if (enabled)
            q <= d;
    end
endmodule
