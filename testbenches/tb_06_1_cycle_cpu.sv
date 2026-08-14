
`include "top.sv"

/* verilator lint_off STMTDLY */

module tb_06_1_cycle_cpu;

    logic clk;
    logic rst;
    logic [31:0] a;
    logic [31:0] b;
    logic [2:0] alu_op;
    logic [31:0] result;
    logic [31:0] expected_result;


    top top_data (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        $dumpfile("tb_06_1_cycle_cpu.vcd");
        $dumpvars(0, tb_06_1_cycle_cpu);
        rst = 1; #10; rst = 0;
    end

    initial begin
        for (integer i = 0; i < 100; i++)
        begin
            clk = 0;
            #5;
            clk = 1;
            #5;
        end
        if (top_data.cpu.pc == 32'h000000)
            $display("Test passed");
        else
            $display("Test failed: pc = %h", top_data.cpu.pc);
        $finish;
    end

  
endmodule

/* verilator lint_on STMTDLY */
