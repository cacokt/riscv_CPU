`timescale 1ns / 1ps
`include "Defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2022 12:31:50
// Design Name: 
// Module Name: ALU_RISCV
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU_RISCV(
    input[4:0]      ALUOp,
    input[31:0]     A,
    input[31:0]     B,
    output[31:0]    Result,
    output          Flag
);
    
    reg[31:0]   Result_reg;
    reg         Flag_reg;
    
    always @(*) begin
        case (ALUOp)
            `ALU_ADD    : Result_reg <= A + B;
            `ALU_SUB    : Result_reg <= A - B;
            `ALU_SLL    : Result_reg <= A << B;
            `ALU_SLTS   : Result_reg <= ($signed(A) < $signed(B));
            `ALU_SLTU   : Result_reg <= (A < B);
            `ALU_XOR    : Result_reg <= (A ^ B);
            `ALU_SRL    : Result_reg <= A >> B;
            `ALU_SRA    : Result_reg <= $signed(A) >>> B;
            `ALU_OR     : Result_reg <= A | B;
            `ALU_AND    : Result_reg <= A & B;
            default     : Result_reg <= 32'b0;
        endcase
    end

    always @(*) begin
        case (ALUOp)
            `ALU_EQ     : Flag_reg <= (A == B);
            `ALU_NE     : Flag_reg <= (A != B);
            `ALU_LTS    : Flag_reg <= ($signed(A) < $signed(B));
            `ALU_GES    : Flag_reg <= ($signed(A) >= $signed(B));
            `ALU_LTU    : Flag_reg <= (A < B);
            `ALU_GEU    : Flag_reg <= (A >= B);
            default     : Flag_reg <= 0;
         endcase
    end
    
    assign Result   = Result_reg;
    assign Flag     = Flag_reg;
    
endmodule