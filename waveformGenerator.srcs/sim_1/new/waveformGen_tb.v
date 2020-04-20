`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2020 15:38:03
// Design Name: 
// Module Name: waveformGen_tb
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


module waveformGen_tb;

    reg  CLK100MHZ_tb;
    
    waveformGen gen(
        .CLK100MHZ(CLK100MHZ_tb)
    );
    
    initial begin
    
    $display("\t\ttime,\tCLK100MHZ_tb");
    $monitor("%d",CLK100MHZ_tb);
    
    CLK100MHZ_tb=0; #10;
    CLK100MHZ_tb=1; #10;
    CLK100MHZ_tb=0; #10;
    CLK100MHZ_tb=1; #10;
    
    
    end

endmodule
