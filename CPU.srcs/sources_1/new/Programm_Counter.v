`timescale 1ns / 1ps

module Programm_Counter(
    input               clk,
    input               rst,
    input               EN,
    
    input [31:0]        imm_I,
    input [31:0]        imm_J,
    input [31:0]        imm_B,
    
    input [31:0]        RD1,
    
    input               jalr,
    input               jal,
    input               branch,
    input               alu_flag,
    
    output reg [31:0]   PC
);

wire    en = ~EN;

wire    Br_a_ALU_j      = alu_flag && branch;
wire    jump            = jal         || Br_a_ALU_j;

wire [31:0] jump_addr   = branch ? imm_B : imm_J;
wire [31:0] addr        = jump   ? jump_addr : 32'd4;

wire [31:0] new_PC_addr = PC + addr;
wire [31:0] new_PC_imm  = RD1 + imm_I;

reg  [31:0] new_PC;

    always @(*) begin
        case(jalr)
        2'b01: new_PC <= new_PC_imm;
        2'b00: new_PC <= addr;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if( rst )
            PC <= 32'd0;
        else if( clk )
            PC <= new_PC;
    end

endmodule