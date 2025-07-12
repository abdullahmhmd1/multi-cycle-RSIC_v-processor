module mux2to1 (
    input logic [31:0] a, // First input
    input logic [31:0] b, // Second input
    input logic sel, // Select signal
    output logic [31:0] out // Output
);
    always @(*) begin
        if (sel) begin
            out = b; // If sel is 1, output b
        end else begin
            out = a; // If sel is 0, output a
        end
    end
    endmodule
    module mux3to1 (
        input logic [31:0] a, // First input
    input logic [31:0] b, // Second input
    input logic [31:0] c, // Second input
    input logic [1:0] sel, // Select signal
    output logic [31:0] out // Output
    );
    always @(*) begin
        case (sel)
            2'b00: out = a; // If sel is 00, output a
            2'b01: out = b; // If sel is 01, output b
            2'b10: out = c; // If sel is 10, output c
            2'b11: out = 32'bx; // If sel is 11
            default: out = 32'b0; // Default case, output 0
        endcase
    end
    endmodule
