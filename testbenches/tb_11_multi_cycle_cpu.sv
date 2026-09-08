
`include "topmulti.sv"

/* verilator lint_off STMTDLY */

module tb_11_multi_cycle_cpu;

    logic clk;
    logic rst;
    logic [31:0] a;
    logic [31:0] b;
    logic [2:0] alu_op;
    logic [31:0] result;
    logic [31:0] expected_result;
    logic [31:0] pc;


    topmulti #(
        .IMEM_FILE("./tests/03-longer.tv")
    )
    top_device
    (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        $dumpfile("tb_11_multi_cycle_cpu.vcd");
        $dumpvars(0, tb_11_multi_cycle_cpu);
        rst = 1; #2; rst = 0;
    end

    initial begin
        for (integer i = 0; i < 200; i++)
        begin
            clk = 1; #5;
            clk = 0; #5;
        end
    end

    always @(negedge clk)
    begin
        if (top_device.we && top_device.addr === 216)
        begin
            if (top_device.mem_wd === 4140)
                $display("Test passed");
            else
                $fatal(1, "TEST FAILED: addr = %h, mem_wd = %h", top_device.addr, top_device.mem_wd);
        end
    end
  
endmodule

/* verilator lint_on STMTDLY */
