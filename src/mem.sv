
module mem
#(
    parameter MEM_FILE = "",
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
    initial
        $display("MEM_SIZE = %0d, ADDR_BITS = %0d", MEM_SIZE, ADDR_BITS);

    logic [31:0] data_array [MEM_SIZE-1:0];
    logic [63:0] mem_script [0:255];

    initial
    begin
        for (int i = 0; i < MEM_SIZE; i++)
        begin
            data_array[i] = 32'h0;
        end
        if (MEM_FILE != "")
        begin
            $readmemh(MEM_FILE, mem_script);
            for (int i = 0; mem_script[i][31:0] !== 32'bx; i++)
            begin
                $display("set mem[%h] = %h", mem_script[i][63:32], mem_script[i][31:0]);
                data_array[mem_script[i][63:32]] = mem_script[i][31:0];
            end
        end
    end

    
    always_ff @(posedge clk)
    begin
        if (we)
            data_array[addr[ADDR_BITS-1:0]] <= data_in;
    end

    assign data_out = data_array[addr[ADDR_BITS-1:0]];

endmodule
