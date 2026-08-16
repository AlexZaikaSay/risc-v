
module ff (
    input logic clk,
    input logic rst,
    input logic [31:0] start_value,
    input logic [31:0] d,
    output logic [31:0] q
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= start_value;
        else
            q <= d;
    end
endmodule
