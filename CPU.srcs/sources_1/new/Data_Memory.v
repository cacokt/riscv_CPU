`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2022 19:55:24
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory(
    input           clk,
    input           WE,
    input  [31:0]   WD,
    input  [31:0]   A,
    
    output [31:0]   RD
    );
    
      reg [31:0]   regs [0:255];
    
      wire         valid_addr = A[31:10] == 22'b1000_0010_0000_0000_0000_00; 
      wire [9:2]   word_addr  = A[9:2];
    
      always @( posedge clk ) begin
        if ( WE && valid_addr )
          regs[word_addr] = WD;
      end
    
      assign RD = valid_addr ? regs[word_addr] : 32'd0; 
    
    
endmodule
