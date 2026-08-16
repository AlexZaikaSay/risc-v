module imem
#(
    parameter IMEM_FILE = "",
    parameter int IMEM_SIZE = 'h100
)
(
    /* verilator lint_off UNUSED */
    input  logic [31:0] addr,
    /* verilator lint_off UNUSED */
    output logic [31:0] data_out
);

    localparam int ADDR_BITS = $clog2(IMEM_SIZE);

    logic [31:0] data_array [0:IMEM_SIZE-1];

    initial
    begin
        if (IMEM_FILE != "")
            $readmemh(IMEM_FILE, data_array);
    end

    assign data_out = data_array[addr[ADDR_BITS+1:2]];

endmodule
