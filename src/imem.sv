module imem
#(
    parameter string MEM_FILE = "./tests/t1.mem",
    parameter int MEM_SIZE = 'h100
)
(
    /* verilator lint_off UNUSED */
    input  logic [31:0] addr,
    /* verilator lint_off UNUSED */
    output logic [31:0] data_out
);

    localparam int ADDR_BITS = $clog2(MEM_SIZE);

    logic [31:0] data_array [0:MEM_SIZE-1];

    initial begin
        $readmemh(MEM_FILE, data_array);
    end

    assign data_out = data_array[addr[ADDR_BITS+1:2]];

endmodule
