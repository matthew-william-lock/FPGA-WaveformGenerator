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


module blockmemory_tb;

    reg CLK100MHZ_tb;
    reg ena=1;
    reg wea=0;
    reg [7:0]addra=1;
    reg [10:0]dina;
    
    wire [10:0]douta;
    
    waveformGen gen(
        .CLK100MHZ(CLK100MHZ_tb)
    );
    
    blk_mem_gen_0 bram (
      .clka(CLK100MHZ_tb),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra),  // input wire [7 : 0] addra
      .dina(dina),    // input wire [10 : 0] dina
      .douta(douta)  // output wire [10 : 0] douta
    );
    
    initial begin
    
        $display("\t\ttime,\tCLK100MHZ_tb,\taddra,\tdouta");
        $monitor("%d,\t%b,\t\t%d,\t%d",$time,CLK100MHZ_tb,addra,douta);
        
        repeat (1) begin
            CLK100MHZ_tb=0; #10;
            CLK100MHZ_tb=1; #10;
        end
       
        repeat (2048) begin
            CLK100MHZ_tb=0; #10;
            CLK100MHZ_tb=1; #10;
            addra<=addra+1'b1;
        end   
    
    end

endmodule
