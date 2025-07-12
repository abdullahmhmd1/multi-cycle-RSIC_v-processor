module control_unit (
    input  logic        zero,
    input  logic        reset_n,
    input  logic        clk,
    input  logic        funct7,
    input  logic [6:0]  op,
    input  logic [2:0]  funct3,
    output logic        pc_write,
    output logic        reg_write,
    output logic        mem_write,
    output logic        ir_write,
    output logic        adr_src,
    output logic [1:0]  result_src,
    output logic [1:0]  alu_srcB,
    output logic [1:0]  alu_srcA,
    output logic [1:0]  imm_src,
    output logic [3:0]  alu_control
);

// Internal control logic
logic branch, pc_update;
logic [1:0] alu_op;
assign pc_write = (zero & branch) | pc_update;

// FSM state definitions
logic [3:0] state_reg, state_next;
localparam s0  = 0, s1  = 1, s2  = 2, s3  = 3, s4  = 4,
           s5  = 5, s6  = 6, s7  = 7, s8  = 8, s9  = 9, s10 = 10;

// Sequential state update
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n)
        state_reg <= s0;
    else
        state_reg <= state_next;
end

// FSM logic
always_comb begin
    case (state_reg)
        s0: begin
            state_next   = s1;
            adr_src      = 0;
            ir_write     = 1;
            pc_update    = 1;
            alu_srcA     = 2'b00;
            alu_srcB     = 2'b10;
            alu_op       = 2'b00;
            result_src   = 2'b10;
            mem_write    = 0;
            reg_write    = 0;
            branch       = 0;
        end

        s1: case (op)
            7'b0000011, 7'b0100011: begin // lw or sw
                state_next   = s2;
                alu_srcA     = 2'b01;
                alu_srcB     = 2'b01;
                alu_op       = 2'b00;
                adr_src      = 1'bx;
                ir_write     = 0;
                pc_update    = 0;
                result_src   = 2'bxx;
                mem_write    = 0;
                reg_write    = 0;
                branch       = 0;
            end

            7'b0110011: begin // R-type
                state_next   = s6;
                alu_srcA     = 2'b01;
                alu_srcB     = 2'b01;
                alu_op       = 2'b00;
                adr_src      = 1'bx;
                ir_write     = 0;
                pc_update    = 0;
                result_src   = 2'bxx;
                mem_write    = 0;
                reg_write    = 0;
                branch       = 0;
            end

            7'b0010011: begin // I-type
                state_next   = s8;
                alu_srcA     = 2'b01;
                alu_srcB     = 2'b01;
                alu_op       = 2'b00;
                adr_src      = 1'bx;
                ir_write     = 0;
                pc_update    = 0;
                result_src   = 2'bxx;
                mem_write    = 0;
                reg_write    = 0;
                branch       = 0;
            end

            7'b1101111: begin // JAL
                state_next   = s9;
                alu_srcA     = 2'b01;
                alu_srcB     = 2'b01;
                alu_op       = 2'b00;
                adr_src      = 1'bx;
                ir_write     = 0;
                pc_update    = 0;
                result_src   = 2'bxx;
                mem_write    = 0;
                reg_write    = 0;
                branch       = 0;
            end

            7'b1100011: begin // BEQ
                state_next   = s10;
                alu_srcA     = 2'b01;
                alu_srcB     = 2'b01;
                alu_op       = 2'b00;
                adr_src      = 1'bx;
                ir_write     = 0;
                pc_update    = 0;
                result_src   = 2'bxx;
                mem_write    = 0;
                reg_write    = 0;
                branch       = 0;
            end

            default: begin
            state_next = state_reg;
                alu_srcA     = 2'bxx;
                alu_srcB     = 2'bxx;
                alu_op       = 2'bxx;
                adr_src      = 1'bx;
                ir_write     = 0;
                pc_update    = 0;
                result_src   = 2'bxx;
                mem_write    = 0;
                reg_write    = 0;
                branch       = 0;
            end
        endcase

        s2: case (op)
            7'b0000011: begin // lw
                state_next = s3;
                result_src = 2'bxx;
                adr_src    = 1'bx;
                ir_write   = 0;
                pc_update  = 0;
                alu_srcA   = 2'b10;
                alu_srcB   = 2'b01;
                alu_op     = 2'b00;
                mem_write  = 0;
                reg_write  = 0;
                branch     = 0;
            end
            7'b0100011: begin // sw
                state_next = s5;
                result_src = 2'bxx;
                adr_src    = 1'bx;
                ir_write   = 0;
                pc_update  = 0;
                alu_srcA   = 2'b10;
                alu_srcB   = 2'b01;
                alu_op     = 2'b00;
                mem_write  = 0;
                reg_write  = 0;
                branch     = 0;
            end
            default: begin
                state_next = state_reg;
                adr_src    = 1'bx;
                ir_write   = 0;
                pc_update  = 0;
                alu_srcA   = 2'bxx;
                alu_srcB   = 2'bxx;
                alu_op     = 2'bxx;
                result_src = 2'bxx;
                mem_write  = 0;
                reg_write  = 0;
                branch     = 0;
            end
        endcase

        s3: begin
            state_next = s4;
            result_src = 2'b00;
            reg_write  = 0;
            adr_src    = 1;
            ir_write   = 0;
            pc_update  = 0;
            alu_srcA   = 2'bxx;
            alu_srcB   = 2'bxx;
            alu_op     = 2'bxx;
            mem_write  = 0;
            branch     = 0;
        end

        s4: begin
            state_next = s0;
            result_src = 2'b01;
            reg_write  = 1;
            adr_src    = 1'bx;
            ir_write   = 0;
            pc_update  = 0;
            alu_srcA   = 2'bxx;
            alu_srcB   = 2'bxx;
            alu_op     = 2'bxx;
            mem_write  = 0;
            branch     = 0;
        end

        s5: begin
            state_next = s0;
            result_src = 2'b00;
            adr_src    = 1;
            mem_write  = 1;
            ir_write   = 0;
            pc_update  = 0;
            alu_srcA   = 2'bxx;
            alu_srcB   = 2'bxx;
            alu_op     = 2'bxx;
            reg_write  = 0;
            branch     = 0;
        end

        s6: begin
            state_next = s7;
            alu_srcA   = 2'b10;
            alu_srcB   = 2'b00;
            alu_op     = 2'b10;
            adr_src    = 1'bx;
            ir_write   = 0;
            pc_update  = 0;
            result_src = 2'bxx;
            mem_write  = 0;
            reg_write  = 0;
            branch     = 0;
        end

        s7: begin
            state_next = s0;
            result_src = 2'b00;
            reg_write  = 1;
            adr_src    = 1'bx;
            ir_write   = 0;
            pc_update  = 0;
            alu_srcA   = 2'bxx;
            alu_srcB   = 2'bxx;
            alu_op     = 2'bxx;
            mem_write  = 0;
            branch     = 0;
        end

        s8: begin
            state_next = s7;
            alu_srcA   = 2'b10;
            alu_srcB   = 2'b01;
            alu_op     = 2'b10;
            adr_src    = 1'bx;
            ir_write   = 0;
            pc_update  = 0;
            result_src = 2'bxx;
            mem_write  = 0;
            reg_write  = 0;
            branch     = 0;
        end

        s9: begin
            state_next = s7;
            alu_srcA   = 2'b01;
            alu_srcB   = 2'b10;
            alu_op     = 2'b00;
            result_src = 2'b00;
            pc_update  = 1;
            adr_src    = 1'bx;
            ir_write   = 0;
            mem_write  = 0;
            reg_write  = 0;
            branch     = 0;
        end

        s10: begin
            state_next = s0;
            alu_srcA   = 2'b10;
            alu_srcB   = 2'b00;
            alu_op     = 2'b01;
            result_src = 2'b00;
            branch     = 1;
            adr_src    = 1'bx;
            ir_write   = 0;
            pc_update  = 0;
            mem_write  = 0;
            reg_write  = 0;
        end

        default: begin
            state_next = s0;
            adr_src    = 1'bx;
            ir_write   = 0;
            pc_update  = 0;
            alu_srcA   = 2'bxx;
            alu_srcB   = 2'bxx;
            alu_op     = 2'bxx;
            result_src = 2'bxx;
            mem_write  = 0;
            reg_write  = 0;
            branch     = 0;
        end
    endcase
end

// ALU decoder
always_comb begin
    case (alu_op)
        2'b00: alu_control = 4'b0010; // ADD
        2'b01: alu_control = 4'b0110; // SUB
        2'b10: begin // R-type or I-type
            case (funct3)
                3'b000: alu_control = (funct7 == 1'b0) ? 4'b0010 : 4'b0110; // ADD/SUB
                3'b001: alu_control = 4'b0001; // SLL
                3'b100: alu_control = 4'b0000; // XOR
                3'b101: alu_control = (funct7 == 1'b1) ? 4'b0100 : 4'b0101; // SRA/SRL
                3'b110: alu_control = 4'b1000; // OR
                3'b111: alu_control = 4'b0011; // AND
                default: alu_control = 4'b0000;
            endcase
        end
        default: alu_control = 4'b0000;
    endcase
end

// Immediate decoder
always_comb begin
    case (op)
        7'b0000011,
        7'b0010011: imm_src = 2'b00; // I-type (lw, addi)
        7'b0100011: imm_src = 2'b01; // S-type (sw)
        7'b1100011: imm_src = 2'b10; // B-type (beq)
        7'b1101111: imm_src = 2'b11; // J-type (jal)
        7'b0110011: imm_src = 2'bxx; // R-type (no imm)
        default:    imm_src = 2'bxx;
    endcase
end

endmodule
