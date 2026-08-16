
`include "top.sv"

/* verilator lint_off STMTDLY */

module tb_07_1_cycle_cpu;

    logic clk;
    logic rst;
    logic [31:0] a;
    logic [31:0] b;
    logic [2:0] alu_op;
    logic [31:0] result;
    logic [31:0] expected_result;
    logic [31:0] pc;


    top #(
        .IMEM_FILE("./tests/tb_07_1_cycle_cpu.tv")
    )
    top_device
    (
        .clk(clk),
        .rst(rst),
        .pc_start(32'h00000000)
    );

    initial begin
        $dumpfile("tb_07_1_cycle_cpu.vcd");
        $dumpvars(0, tb_07_1_cycle_cpu);
        rst = 1; #2; rst = 0;
    end

    initial begin
        for (integer i = 0; i < 20; i++)
        begin
            clk = 0;
            #5;
            clk = 1;
            #5;
        end
    end

    always @(negedge clk)
    begin
        if (top_device.we && top_device.mem_addr === 100)
        begin
            if (top_device.mem_wd === 25)
                $display("Test passed");
            else
                $fatal(1, "TEST FAILED: mem_addr = %h, mem_wd = %h", top_device.mem_addr, top_device.mem_wd);
        end
    end

  
endmodule

/* verilator lint_on STMTDLY */
