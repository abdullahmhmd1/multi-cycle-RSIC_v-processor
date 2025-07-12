module pc(

    input logic clk, // Clock signal
    input logic [31:0] next_pc, // Next program counter value
    input logic en, // Enable signal for the PC
    output logic [31:0] pc_value // Current program counter value
);
    always @(posedge clk ) begin
        if (en) begin // Check if enable signal is high
           
            pc_value =next_pc; 
        end
    end

endmodule
module d2_ff (
input logic clk,
input logic en,
input logic [31:0]d1,
input logic [31:0]d2,
output logic [31:0]q1,
output logic [31:0]q2

);

  // Always block triggered on the positive edge of the clock signal
  always @(posedge clk)
    begin
        if(en)
             begin
                 q1<=d1;
                 q2<=d2;
             end
    end
endmodule
module d_ff_without_en (
input logic clk,
input logic [31:0] d,
output logic [31:0]q

);

  // Always block triggered on the positive edge of the clock signal
  always @(posedge clk)
    q<=d;
    endmodule