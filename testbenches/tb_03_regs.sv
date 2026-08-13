
`include "regs.sv"

/* verilator lint_off STMTDLY */

module tb_03_regs;


    logic clk;
    logic we;
    

    logic [4:0] a1;
    logic [4:0] a2;
    logic [4:0] a3;
    logic [31:0] rd1;
    logic [31:0] rd2;
    logic [31:0] wd3;

    regs regs_data (
        .clk(clk),
        .we3(we),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        $dumpfile("tb_03_regs.vcd");
        $dumpvars(0, tb_03_regs);
        $dumpvars(0, regs_data);
        a3 = 0;
        for (int i = 0; i < 32; i++)
        begin
            a3 = i[4:0];
            wd3 = i << 16;
            we = 1;
            #10;
            we = 0;
            #10;
        end
        for (int i = 0; i < 32; i++)
        begin
            a1 = i[4:0];
            a2 = i[4:0];
            #1;
            if (rd1 !== i << 16) 
            begin // check result
                $error("Error: a1 = %h rd1 = %h (expected %h) on step %0d", a1, rd1, i << 16, i);
            end
            if (rd2 !== i << 16) 
            begin // check result
                $error("Error: a2 = %h rd2 = %h (expected %h) on step %0d", a2, rd2, i << 16, i);
            end
            #19;
        end
        $finish;
    end


endmodule

/* verilator lint_on STMTDLY */
