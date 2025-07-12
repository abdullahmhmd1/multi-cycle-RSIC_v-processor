module M_RSIC_V(
input logic clk,
input logic reset_n
);
wire pc_write;
wire adr_src;
wire mem_write;
wire ir_write;
wire [1:0]result_src;
wire [3:0]alu_control;
wire [1:0]alu_srcA;
wire [1:0]alu_srcB;
wire [1:0]imm_src;
wire reg_write;
wire zero;
wire [31:0]instr;
wire [31:0]data;
wire [31:0]alu_out;
wire [31:0]old_pc;
wire [31:0]a;
wire [31:0]imm;
wire [31:0]rd1;
wire [31:0]rd2;
wire [31:0]scrA;
wire [31:0]scrB;
wire [31:0]pc;
wire [31:0]read_data;
wire[31:0]result;
wire [31:0]write_data;
wire [31:0]alu_res;
wire [31:0]adr;
control_unit cu(
.zero(zero),
.reset_n(reset_n),
.clk(clk),
.funct7(instr[30]),
.op(instr[6:0]),
.funct3(instr[14:12]),
.pc_write(pc_write),
.reg_write(reg_write),
.mem_write(mem_write),
.ir_write(ir_write),
.adr_src(adr_src),
.result_src(result_src),
.alu_srcA(alu_srcA),
.alu_srcB(alu_srcB),
.imm_src(imm_src),
.alu_control(alu_control)
);
imm_gen imm_ex(
.instruction(instr),
.imm_src(imm_src),
.imm(imm)
);
data_mem memo(
.clk(clk),
.address(adr),
.write_data(write_data),
.mem_write(mem_write),
.read_data(read_data)

);
M_alu alu(
.a(scrA),
.b(scrB),
.alucontrol(alu_control),
.result(alu_res),
.zero(zero)
);
reg_file rf(
.clk(clk),
.read_reg1(instr[19:15]),
.read_reg2(instr[24:20]),
.write_reg(instr[11:7]),
.regwrite(reg_write),
.write_data(result),
.read_data1(rd1),
.read_data2(rd2)
);
mux2to1 mux1(
.a(pc),
.b(result),
.sel(adr_src),
.out(adr)

);
mux3to1 mux2(
.a(pc),
.b(old_pc),
.c(a),
.sel(alu_srcA),
.out(scrA)
);
mux3to1 mux3(
.a(write_data),
.b(imm),
.c(32'd4),
.sel(alu_srcB),
.out(scrB)
);
mux3to1 mux4(
.a(alu_out),
.b(data),
.c(alu_res),
.sel(result_src),
.out(result)
);
pc d1(
.clk(clk),
.en(pc_write),
.next_pc(result),
.pc_value(pc)
);
d_ff_without_en d2(
.clk(clk),
.d(read_data),
.q(data)
);
d_ff_without_en d3(
.clk(clk),
.d(alu_res),
.q(alu_out)

);
d2_ff d4(
.clk(clk),
.en(ir_write),
.d1(pc),
.d2(read_data),
.q1(old_pc),
.q2(instr)
);
d_ff_without_en d5(
.clk(clk),
.d(rd1),
.q(a)

);
d_ff_without_en d6(
.clk(clk),
.d(rd2),
.q(write_data)
);

endmodule