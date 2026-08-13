
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


    alu alu_data (
        .alu_op(alu_op),
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
        $dumpfile("tb_05_alu.vcd");
        $dumpvars(0, tb_05_alu);
        $readmemh("../testbenches/data/tb_05_alu.tv", testvectors);
        vectornum = 0; errors = 0;
        rst = 1; #10; rst = 0;
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk)
    begin
        #1;
        alu_op <= testvectors[vectornum][98:96];
        a <= testvectors[vectornum][95:64];
        b <= testvectors[vectornum][63:32];
        expected_result <= testvectors[vectornum][31:0];
        if (testvectors[vectornum] === 104'bx)
        begin
            $display("%0d tests completed with %0d errors", vectornum, errors);
            $finish;
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
