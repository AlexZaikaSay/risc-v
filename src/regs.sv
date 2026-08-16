
module regs
#
(
    parameter REGS_FILE = ""
)
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
    logic [39:0] regs_script [0:255];

    initial
    begin
        $display("Loading registers from file: %s", REGS_FILE);
        for (int i = 0; i < 32; i++)
        begin
            regs_array[i] = 32'h0;
        end
        if (REGS_FILE != "")
        begin
            $readmemh(REGS_FILE, regs_script);
            for (int i = 0; regs_script[i][36:32] !== 5'bx; i++)
            begin
                $display("Loading: %0d register => %h", regs_script[i][36:32], regs_script[i][31:0]);
                regs_array[regs_script[i][36:32]] = regs_script[i][31:0];
            end
        end
    end

    always_ff @(posedge clk)
    begin
        if (we3)
            regs_array[a3] <= wd3;
    end

    assign rd1 = regs_array[a1];
    assign rd2 = regs_array[a2];

endmodule
