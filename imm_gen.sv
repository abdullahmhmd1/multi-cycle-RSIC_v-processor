module imm_gen(
    input  logic [31:0] instruction, 
    input  logic [1:0] imm_src,
    output logic [31:0] imm          
);

    always @(*) begin
        case (imm_src) // Check the opcode
                  // Load instructions
            2'b00: // I-type immediate arithmetic
                imm = {{20{instruction[31]}}, instruction[31:20]}; // 12-bit sign-extend

           2'b01: // S-type store instructions
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // 12-bit sign-extend

            2'b10: // B-type branch instructions
                imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // 13-bit sign-extend
            2'b11: //
            imm= {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default:
                imm = 32'b0; // Fallback/default
        endcase
    end

endmodule
