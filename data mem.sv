module data_mem (
    input  logic        clk,         // Clock signal
    input  logic [31:0] address,     // Address to read/write data
    input  logic [31:0] write_data,  // Data to write (if write enable is high)
    input  logic        mem_write,   // Write enable signal
    output logic [31:0] read_data    // Data read from memory
);
   logic [31:0] memory [0:255]; // Memory array (256 words of 32 bits each)(0->63 instructions, 64->255 data)
       
       
    assign  read_data = memory[address[31:2]]; // Read data from memory at the specified address
    // Write operation on positive clock edge
    always_ff @(posedge clk) begin
        if (mem_write) begin
            memory[address[31:2]] <= write_data; // Write data to memory at the specified address
        end
    end
    // Read operation always

endmodule
