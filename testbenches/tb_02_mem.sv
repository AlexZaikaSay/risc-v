
`include "mem.sv"

/* verilator lint_off STMTDLY */

module tb_02_mem;


    logic clk;
    logic we;
    logic [31:0] addr;
    logic [31:0] data_out;
    logic [31:0] data_in;
    int unsigned errors;

    mem mem_data (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        errors = 0;
        $dumpfile("tb_02_mem.vcd");
        $dumpvars(0, tb_02_mem);
        $dumpvars(0, mem_data);
        addr = 'h2000;
        for (int i = 0; i < 5; i++)
        begin
            addr = i * 4;
            data_in = i;
            we = 1;
            #10;
            we = 0;
            #10;
        end
        for (int i = 0; i < 5; i++)
        begin
            addr = i * 4;
            #1;
            if (data_out !== i) 
            begin // check result
                $error("Error: addr = %h data_out = %h on step %0d", addr, data_out, i);
                errors++;
            end
            #10;
        end
        if (errors != 0)
            $fatal(1, "TEST FAILED: %0d errors", errors);

        $display("TEST PASSED");
        $finish;
    end


endmodule

/* verilator lint_on STMTDLY */
