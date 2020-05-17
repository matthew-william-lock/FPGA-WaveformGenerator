`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2020 16:43:01
// Design Name: 
// Module Name: blockmemory_tb
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


// From running this simulation, we have found that the memory block reads in an address
// and then outputs the data at that address on the next clock cycle

module quartsin_tb;

    reg CLK100MHZ;
    wire AUD_SD;
    wire AUD_PWM;
    
     wire [10:0] addra;
     wire [1:0] phase;
     wire [12:0] clkdiv;
     wire [0:0] rep;
     wire [10:0] douta;
     
    
    
    quartsine quart (
        .CLK100MHZ(CLK100MHZ),
        .AUD_PWM(AUD_PWM),
        .AUD_SD(AUD_SD)
    );
    
    
    assign addra=quart.addra;
    assign phase=quart.phase;
    assign clkdiv=quart.clkdiv;    
    assign rep = quart.rep;
    assign douta=quart.PWM;
        
    
    initial begin
    
//        $display("\t\ttime,\tCLK100MHZ,\taddra,\tdouta");
//        $monitor("%d,\t%b,\t\t%d,\t%d",$time,CLK100MHZ,addra,douta);
        
        CLK100MHZ=0;
    
    end
    
    always begin
        #1;  CLK100MHZ = !CLK100MHZ;
    end

endmodule
