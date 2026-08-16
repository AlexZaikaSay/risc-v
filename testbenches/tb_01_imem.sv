
`include "imem.sv"

/* verilator lint_off STMTDLY */

module  tb_01_imem;

    logic [31:0] addr;
    logic [31:0] instruction;

    imem #(
        .IMEM_FILE("./tests/tb_06_imem.tv"),
        .IMEM_SIZE(16)
    ) imem_inst (
        .addr(addr),
        .data_out(instruction)
    );

    initial begin
        $dumpfile("tb_01_imem.vcd");
        $dumpvars(0, tb_01_imem);
        for (int i = 0; i < 5; i++) begin
            addr = i * 4;
            #10;
        end
        $finish;
    end


endmodule

/* verilator lint_on STMTDLY */
