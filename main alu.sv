module M_alu (
input logic [31:0] a, 
input logic [31:0] b, // Inputs to the ALU
input logic [3:0] alucontrol, // ALU control signal
output logic [31:0] result, // Output of the ALU
output logic zero // Zero flag
);
always @(*) begin
    case (alucontrol)
        4'b0010: result = a + b; // ADD
        4'b0110: result = a - b; // SUB
        4'b0001: result = a << b; // SLL
        4'b0101: result = a >> b; // SRL
        4'b0100: result = $signed(a) >>>b; // SRA
        4'b0000: result = a ^ b; // XOR
        4'b0011: result = a & b; // AND
        4'b1000: result = a | b; // OR
        default: result = 32'b0; // Default case, should not happen
    endcase

    zero = (result == 32'b0); // Set zero flag if result is zero
end

endmodule
