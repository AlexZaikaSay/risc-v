
`include "alu.sv"

/* verilator lint_off STMTDLY */

module tb_05_alu;

    logic clk;
    logic rst;
    logic [31:0] a;
    logic [31:0] b;
    logic [2:0] alu_op;
    logic [31:0] result;
    logic [31:0] expected_result;
    logic [31:0] vectornum, errors;
    logic [103:0] testvectors[0:255];
    logic [4:0] dummy;


    alu alu_data (
        .alu_op(alu_op),
        .a(a),
        .b(b),
        .result(result),
        .c(),
        .z()
    );

    initial begin
        $dumpfile("tb_05_alu.vcd");
        $dumpvars(0, tb_05_alu);
        $readmemh("./tests/tb_05_alu.tv", testvectors);
        vectornum = 0; errors = 0;
        rst = 1; #22; rst = 0;
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk)
    begin
        if (~rst) 
        begin // skip during reset
            {dummy, alu_op, a, b, expected_result} <= testvectors[vectornum];
                        if (testvectors[vectornum] === 104'bx)
            begin
                if (errors != 0)
                    $fatal(1, "TEST FAILED: %0d errors across %0d tests", errors, vectornum);

                $display("TEST PASSED: %0d tests", vectornum);
                $finish;
            end
        end
    end

     always @(negedge clk)
        if (~rst) 
        begin // skip during reset
            if (result !== expected_result) 
            begin // check result
                $error("Error: a = %h b = %h alu_op = %b result = %h (expected %h) on step %0d", a, b, alu_op, result, expected_result, vectornum);
                errors <= errors + 1;
            end
            vectornum <= vectornum + 1;
        end

endmodule

/* verilator lint_on STMTDLY */
