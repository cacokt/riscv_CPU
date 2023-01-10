`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2022 23:32:47
// Design Name: 
// Module Name: Instunction_Memory
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


module Instunction_Memory(
        input   [31:0]   inp,
        output  [31:0]  outp
);
    reg [31:0] memory [0:255];
    
    wire [9:2] addr_inp = inp[9:2];
    
    assign outp = memory[addr_inp];
    
    initial $readmemb("C:/Users/71559389/Desktop/переезд/CPU/CPU.srcs/sources_1/new/programm.mem",memory);

endmodule
