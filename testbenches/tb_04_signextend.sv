
`include "signext.sv"

/* verilator lint_off STMTDLY */

module tb_04_signextend;

    logic clk;
    logic rst;
    logic [31:0] inst;
    logic [1:0] ext_op;
    logic [5:0] dummy;
    logic [31:0] extended;
    logic [31:0] extended_expected;
    logic [31:0] vectornum, errors;
    logic [71:0] testvectors[0:255];


    signext signext_data (
        .instr(inst),
        .ext_op(ext_op),
        .extended(extended)
    );

    initial begin
        $dumpfile("tb_04_signextend.vcd");
        $dumpvars(0, tb_04_signextend);
        $readmemh("./tests/tb_04_signextend.tv", testvectors);
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
        {dummy, ext_op, inst, extended_expected} = testvectors[vectornum];
    end

     always @(negedge clk)
        if (~rst) 
        begin // skip during reset
            if (extended !== extended_expected) 
            begin // check result
                $error("Error: inst = %h ext_op = %b extended = %h (expected %h) on step %0d", inst, ext_op, extended, testvectors[vectornum][31:0], vectornum);
                errors = errors + 1;
            end
            vectornum = vectornum + 1;

            if (testvectors[vectornum][71:66] === 6'b111111)
            begin
                if (errors != 0)
                    $fatal(1, "TEST FAILED: %0d errors across %0d tests", errors, vectornum);

                $display("TEST PASSED: %0d tests", vectornum);
                $finish;
            end
        end

endmodule

/* verilator lint_on STMTDLY */
