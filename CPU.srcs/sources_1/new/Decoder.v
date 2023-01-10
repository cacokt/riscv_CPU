`include "opcode_define.v"

`timescale 1ns / 1ps

module decoder_riscv(
  input       [31:0]  fetched_instr_i,
  output  reg [1:0]   ex_op_a_sel_o,
  output  reg [2:0]   ex_op_b_sel_o, 
  output  reg [4:0]   alu_op_o,
  output  reg         mem_req_o, 
  output  reg         mem_we_o,
  output  reg [2:0]   mem_size_o,
  output  reg         gpr_we_a_o,
  output  reg         wb_src_sel_o,
  output  reg         illegal_instr_o,
  output  reg         branch_o,
  output  reg         jal_o,
  output  reg         jalr_o 
);

always @(*) begin
    ex_op_a_sel_o   <= 2'b00;
    ex_op_b_sel_o   <= 3'b000;
    alu_op_o        <= 5'b00000;
    mem_req_o       <= 1'b0;
    mem_we_o        <= 1'b0;
    mem_size_o      <= 3'b000;
    gpr_we_a_o      <= 1'b0;
    wb_src_sel_o    <= 1'b0;
    illegal_instr_o <= 1'b0;
    branch_o        <= 1'b0;
    jal_o           <= 1'b0;
    jalr_o          <= 1'b0;
    
    if (fetched_instr_i[1:0] != 2'b11) begin
        illegal_instr_o <= 1;
    end else begin
        case(fetched_instr_i[6:2])
        `LUI_OPCODE :       begin
                                ex_op_a_sel_o   <= `OP_A_ZERO;
                                ex_op_b_sel_o   <= `OP_B_IMM_U;
                                alu_op_o        <= `ALU_ADD;
                                wb_src_sel_o    <= `WB_EX_RESULT;
                                gpr_we_a_o      <= 1'b1;
                            end
        `AUIPC_OPCODE :     begin
                                ex_op_a_sel_o   <= `OP_A_CURR_PC;
                                ex_op_b_sel_o   <= `OP_B_IMM_U;
                                alu_op_o        <= `ALU_ADD;
                                wb_src_sel_o    <= `WB_EX_RESULT;
                                gpr_we_a_o      <= 1'b1;
                            end
        `JAL_OPCODE :       begin
                                ex_op_a_sel_o   <= `OP_A_CURR_PC;
                                ex_op_b_sel_o   <= `OP_B_INCR;
                                alu_op_o        <= `ALU_ADD;
                                wb_src_sel_o    <= `WB_EX_RESULT;
                                gpr_we_a_o      <= 1'b1;
                                jal_o           <= 1'b1;
                            end
        `JALR_OPCODE :      begin
                                if (fetched_instr_i[14:12] != 3'b000) begin
                                    illegal_instr_o <= 1;
                                end else begin
                                    ex_op_a_sel_o   <= `OP_A_CURR_PC;
                                    ex_op_b_sel_o   <= `OP_B_INCR;
                                    alu_op_o        <= `ALU_ADD;
                                    wb_src_sel_o    <= `WB_EX_RESULT;
                                    gpr_we_a_o      <= 1'b1;
                                    jalr_o          <= 1'b1;
                                end
                            end
        `BRANCH_OPCODE :    begin
                                if (fetched_instr_i[14:12] == 3'b010 || fetched_instr_i[14:12] == 3'b011) begin
                                    illegal_instr_o <= 1;
                                end else begin
                                    ex_op_a_sel_o   <= `OP_A_RS1;
                                    ex_op_b_sel_o   <= `OP_B_RS2;
                                    alu_op_o        <= {2'b11, fetched_instr_i[14:12]};
                                    branch_o        <= 1'b1;
                                end
                            end
        `LOAD_OPCODE :      begin
                                if (fetched_instr_i[14:12] == 3'b011 || fetched_instr_i[14:12] == 3'b110 || fetched_instr_i[14:12] == 3'b111) begin
                                    illegal_instr_o <= 1;
                                end else begin
                                    ex_op_a_sel_o   <= `OP_A_RS1;
                                    ex_op_b_sel_o   <= `OP_B_IMM_I;
                                    alu_op_o        <= `ALU_ADD;
                                    mem_req_o       <= 1'b1;
                                    mem_size_o      <= {fetched_instr_i[14:12]};
                                    gpr_we_a_o      <= 1'b1;
                                    wb_src_sel_o    <= `WB_LSU_DATA;
                                end
                            end
        `STORE_OPCODE :     begin
                                if ( (fetched_instr_i[14] == 1) || (fetched_instr_i[13:12] == 2'b11) )
                                    illegal_instr_o <= 1;
                                else begin
                                    ex_op_a_sel_o   <= `OP_A_RS1;
                                    ex_op_b_sel_o   <= `OP_B_IMM_S;
                                    alu_op_o        <= `ALU_ADD;
                                    mem_req_o       <= 1'b1;
                                    mem_we_o        <= 1'b1;
                                    mem_size_o      <= {fetched_instr_i[14:12]};
                                end
                            end
        `OP_IMM_OPCODE :    begin
                                if (    ( fetched_instr_i[14:12] == 3'b001 && fetched_instr_i[31:25] != 7'b000_0000 )
                                    || ( fetched_instr_i[14:12] == 3'b101 && fetched_instr_i[31:25] != 7'b000_0000
                                                          && fetched_instr_i[31:25] != 7'b010_0000 )
                                    )
                                    illegal_instr_o <= 1;
                                else begin
                                    ex_op_a_sel_o   <= `OP_A_RS1;
                                    ex_op_b_sel_o   <= `OP_B_IMM_I;
                                    alu_op_o        <= {2'b00, fetched_instr_i[14:12]};
                                    wb_src_sel_o    <= `WB_EX_RESULT;
                                    gpr_we_a_o      <= 1'b1;
                                end                                
                            end
        `OP_OPCODE :        begin
                                if ( ( (fetched_instr_i[31:25] != 7'b000_0000) && (fetched_instr_i[31:25] != 7'b010_0000) ) 
                                   // || ( (fetched_instr_i[14:12] == 3'b000) && (fetched_instr_i[31:25] != 7'b010_0000) )
                                   // || ( (fetched_instr_i[14:12] == 3'b101) && (fetched_instr_i[31:25] != 7'b010_0000) )
                                   )
                                    illegal_instr_o <= 1;
                                else begin
                                    ex_op_a_sel_o   <= `OP_A_RS1;
                                    ex_op_b_sel_o   <= `OP_B_RS2;
                                    alu_op_o        <= {fetched_instr_i[31:30], fetched_instr_i[14:12]};
                                    wb_src_sel_o    <= `WB_EX_RESULT;
                                    gpr_we_a_o      <= 1'b1;
                                end
                            end
        `SYSTEM_OPCODE : ;
        `MISC_MEM_OPCODE : ;
         default:
                            illegal_instr_o <= 1;
        endcase
    end
end
endmodule