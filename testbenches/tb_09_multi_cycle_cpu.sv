
`include "topmulti.sv"

/* verilator lint_off STMTDLY */

module tb_09_multi_cycle_cpu;

    logic clk;
    logic rst;
    logic [31:0] a;
    logic [31:0] b;
    logic [2:0] alu_op;
    logic [31:0] result;
    logic [31:0] expected_result;
    logic [31:0] pc;


    topmulti #(
        .MEM_FILE("./tests/tb_06_mem.tv"),
        .IMEM_FILE("./tests/01-short.tv"),
        .REGS_FILE("./tests/tb_06_regs.tv")
    )
    top_device
    (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        $dumpfile("tb_09_multi_cycle_cpu.vcd");
        $dumpvars(0, tb_09_multi_cycle_cpu);
        rst = 1; #2; rst = 0;
    end

    initial begin
        for (integer i = 0; i < 17; i++)
        begin
            clk = 1; #5;
            clk = 0; #5;
        end
        if (top_device.cpu.pc == 32'h00000000)
            $display("Test passed");
        else
                $fatal(1, "TEST FAILED: pc = %h", top_device.cpu.pc);
        $finish;
    end
  
endmodule

/* verilator lint_on STMTDLY */
