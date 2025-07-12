module reg_file (
    input logic clk,                  // Clock signal
    input logic [4:0] read_reg1,     // Register to read from (rs1)
    input logic [4:0] read_reg2,     // Register to read from (rs2)
    input logic [4:0] write_reg,     // Register to write to (rd)
    input logic [31:0] write_data,   // Data to write
    input logic regwrite,             // Write enable signal
    output logic [31:0] read_data1,  // Output data from read_reg1
    output logic [31:0] read_data2   // Output data from read_reg2
);

    logic [31:0] registers [31:0];   // 32 registers, 32 bits each

    always @(posedge clk) begin
        registers[0] <= 32'b0;       // Register x0 is hardwired to 0

        if (regwrite && (write_reg != 5'b0)) begin
            registers[write_reg] <= write_data; // Write data to specified register
        end
    end

    assign read_data1 = registers[read_reg1]; // Read data from register 1
    assign read_data2 = registers[read_reg2]; // Read data from register 2

endmodule
