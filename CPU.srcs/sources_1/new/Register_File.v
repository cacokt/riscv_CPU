`timescale 1ns / 1ps
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

module Register_File(
        input           clk,
        input   [4:0]   RA1,
        input   [4:0]   RA2,
        input   [4:0]   WA,
        input   [31:0]  WD,
        input           WE,
        output  [31:0]  RD1,
        output  [31:0]  RD2
);

    reg [31:0] memory[1:31];
    
    
    assign RD1 = RA1 ? memory[RA1] : 32'b0;
    assign RD2 = RA2 ? memory[RA2] : 32'b0;
    
    always @(posedge clk) begin
        if (WE) memory[WA] <= WD;
    end

endmodule