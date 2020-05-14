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

module blockmemory_tb;

    reg CLK100MHZ_tb;
    reg ena=1;
    reg wea=0;
    reg [7:0]addra=0;
    reg [10:0]dina=0;
    
    wire [10:0]douta;
    

    reg AUD_PWM;
    reg AUD_SD;
    
    waveformGen gen(
        .CLK100MHZ(CLK100MHZ_tb),
        .AUD_PWM(AUD_PWM),
        .AUD_SD(AUD_SD)
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
        
        repeat (0) begin
            CLK100MHZ_tb=0; #1;
            CLK100MHZ_tb=1; #1;
        end
       
        repeat ('d256) begin
            CLK100MHZ_tb=0; #1;
            addra<=addra+1'b1;
            CLK100MHZ_tb=1; #1;
        end  
        
        repeat (0) begin
            CLK100MHZ_tb=0; #1;
            CLK100MHZ_tb=1; #1;
        end 
    
    end

endmodule
