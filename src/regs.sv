
module regs
(
    input logic clk,
    input logic we3,
    input  logic[4:0] a1,
    input  logic[4:0] a2,
    input  logic[4:0] a3,
    input  logic [31:0] wd3,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);
    // 32 registers, each 32 bits wide
    logic [31:0] regs_array [0:31]; 

    always_ff @(posedge clk)
    begin
        if (we3)
            regs_array[a3] <= wd3;
    end

    assign rd1 = regs_array[a1];
    assign rd2 = regs_array[a2];

endmodule
