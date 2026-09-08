
module mainfsm
(
    input  logic [6:0] opcode,
    input  logic       clk,
    input  logic       rst,
    output logic       branch,
    output logic       pc_update,
    output logic       reg_write,
    output logic       mem_write,
    output logic       ir_write,
    output logic [1:0] result_src,
    output logic [1:0] alu_src_a,
    output logic [1:0] alu_src_b,
    output logic       addr_src,
    output logic [1:0] alu_op
);
    typedef enum logic [3:0] {
        S0, // Fetch
        S1, // Decode
        S2, // MemAddr
        S3, // MemRead
        S4, // MemWB
        S5, // MemWrite
        S6, // ExecuteR
        S7, // AluWB
        S8, // ExecuteI
        S9, // JAL
        S10 // BEQ
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin 
        case (state)
            S0: begin
                next_state = S1; // Transition to Decode state
            end
            S1: begin
                // Decode state logic
                casez (opcode)
                    7'b0?00011: next_state = S2;  // MemAddr (Load/Store)
                    7'b0110011: next_state = S6;  // R-type
                    7'b0010011: next_state = S8;  // I-type
                    7'b1101111: next_state = S9;  // JAL
                    7'b1100011: next_state = S10; // Branch
                    default: next_state = S0;     // Default to Fetch state
                endcase
            end
            S2: begin
                // MemAddr state logic
                case (opcode)
                    7'b0000011: next_state = S3; // Load
                    7'b0100011: next_state = S5; // Store
                    default: next_state = S0;    // Default to Fetch state
                endcase
            end
            S3: begin
                next_state = S4; // Transition to MemWB state
            end
            S4: begin
                next_state = S0; // Transition to Fetch state
            end
            S5: begin
                next_state = S0; // Transition to Fetch state
            end
            S6: begin
                next_state = S7; // Transition to AluWB state
            end
            S7: begin
                next_state = S0; // Transition to Fetch state
            end
            S8: begin
                next_state = S7; // Transition to AluWB state
            end
            S9: begin
                next_state = S7; // Transition to AluWB state
            end
            S10: begin
                next_state = S0; // Transition to Fetch state
            end
            default: begin
                next_state = S0; // Default to Fetch state
            end
        endcase
    end

    always_comb begin 
        case (state)
            S0: begin
                // Fetch state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b1;    // Enable instruction register write
                alu_src_a = 2'b00;  // Use PC as ALU source A
                alu_src_b = 2'b10;  // Use immediate as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b10; // Result source for ALU result
                pc_update = 1'b1;   // Enable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S1: begin
                // Decode state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b01;  // Use old_pc as ALU source A
                alu_src_b = 2'b01;  // Use immediate as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b00; // Result source for ALU out
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S2: begin
                // MemAddr state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b10;  // Use r as ALU source A
                alu_src_b = 2'b01;  // Use immediate as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b00; // Result source for ALU out
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S3: begin
                    // MemRead state logic
                addr_src = 1'b1;    // Use result as address
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b00;  // Use pc as ALU source A
                alu_src_b = 2'b00;  // Use writedata as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b00; // Use ALU out as result source
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S4: begin
                    // MemWB state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b00;  // Use pc as ALU source A
                alu_src_b = 2'b00;  // Use writedata as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b01; // Use memory data as result source
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b1;   // Enable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S5: begin
                    // MemWrite state logic
                addr_src = 1'b1;    // Use result as address
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b00;  // Use pc as ALU source A
                alu_src_b = 2'b00;  // Use writedata as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b00; // Use ALU out as result source
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b1;   // Enable memory write
            end
            S6: begin
                    // ExecuteR state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b10;  // Use r as ALU source A
                alu_src_b = 2'b00;  // Use r as ALU source B
                alu_op = 2'b10;     // ALU operation for R-type
                result_src = 2'b00; // Use ALU out as result source
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S7: begin
                    // AluWB state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b00;  // Use pc as ALU source A
                alu_src_b = 2'b00;  // Use writedata as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b00; // Use ALU out as result source
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b1;   // Enable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S8: begin
                    // ExecuteI state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b10;  // Use r as ALU source A
                alu_src_b = 2'b01;  // Use immediate as ALU source B
                alu_op = 2'b10;     // ALU operation for I-type
                result_src = 2'b00; // Use ALU out as result source
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S9: begin
                    // JAL state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b01;  // Use old_pc as ALU source A
                alu_src_b = 2'b10;  // Use 4 as ALU source B
                alu_op = 2'b00;     // ALU operation for addition
                result_src = 2'b00; // Use ALU out as result source
                pc_update = 1'b1;   // Enable PC update
                branch = 1'b0;      // Disable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            S10: begin
                    // BEQ state logic
                addr_src = 1'b0;    // Use PC as address source
                ir_write = 1'b0;    // Disable instruction register write
                alu_src_a = 2'b10;  // Use r as ALU source A
                alu_src_b = 2'b00;  // Use r as ALU source B
                alu_op = 2'b01;     // ALU operation for subtraction
                result_src = 2'b00; // Use ALU out as result source
                pc_update = 1'b0;   // Disable PC update
                branch = 1'b1;      // Enable branch
                reg_write = 1'b0;   // Disable register write
                mem_write = 1'b0;   // Disable memory write
            end
            // Add other states here
            default: begin
                // Default state logic
                addr_src = 1'bx;
                ir_write = 1'bx;
                alu_src_a = 2'bxx;
                alu_src_b = 2'bxx;
                alu_op = 2'bxx;
                result_src = 2'bxx;
                pc_update = 1'bx;
                branch = 1'bx;
                reg_write = 1'bx;
                mem_write = 1'bx;
                
            end
        endcase
    end
endmodule
