`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2020 12:11:20
// Design Name: 
// Module Name: arpeggiator_tb
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


module arpeggiator_tb;

    reg CLK100MHZ;
    reg [7:0] SW;
    reg BTNL;
    wire AUD_PWM; 
    wire AUD_SD;
    wire [1:0] LED;
    
    arpeggiator arp (
        .CLK100MHZ(CLK100MHZ),
        .SW(SW),
        .BTNL(BTNL),
        .AUD_PWM(AUD_PWM), 
        .AUD_SD(AUD_SD),
        .LED(LED)        
    );
    
    wire [1:0] note;
    wire [25:0] note_switch;   
    wire [5:0] addra;
    
    assign note = arp.note;
    assign note_switch=arp.note_switch;
    assign addra = arp.addra;
    
    initial begin
    
        $display("\t\ttime,\t CLK100MHZ,\t SW");
        //    $monitor("%d,\t%b,\t\t%d",$time,CLK100MHZ,SW);        
        CLK100MHZ = 1;
    end    
    
    always begin
        #1;  CLK100MHZ = !CLK100MHZ;
    end
    
endmodule
