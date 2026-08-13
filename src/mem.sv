
module mem
#(
    parameter int MEM_SIZE = 'h4000
)
(
    input logic clk,
    input logic we,
    /* verilator lint_off UNUSED */
    input  logic [31:0] addr,
    /* verilator lint_off UNUSED */
    input  logic [31:0] data_in,
    output logic [31:0] data_out
);

    localparam int ADDR_BITS = $clog2(MEM_SIZE);

    logic [31:0] data_array [0:MEM_SIZE-1];

    always_ff @(posedge clk)
    begin
        if (we)
            data_array[addr[ADDR_BITS+1:2]] <= data_in;
    end

    assign data_out = data_array[addr[ADDR_BITS+1:2]];

endmodule
