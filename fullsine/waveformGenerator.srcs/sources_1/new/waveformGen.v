`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Matthew Lock, Lawrence Godfrey, Mahmoodah Jaffer
// 
// Create Date: 20.04.2020 14:19:53
// Design Name: 
// Module Name: waveformGen
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


module waveformGen(
    input  CLK100MHZ,
    input [7:0] SW,
    input BTNL,
    output AUD_PWM, 
    output AUD_SD,
    output [2:0] LED
    );
    
    // Memory IO
   reg ena = 1;
   reg wea = 0;
   reg [7:0] addra=0;
   reg [10:0] dina=0; //We're not putting data in, so we can leave this unassigned
   wire [10:0] douta;
   
   // Instantiate block memory 
   blk_mem_gen_0 bram (
     .clka(CLK100MHZ),    // input wire clka
     .ena(ena),      // input wire ena
     .wea(wea),      // input wire [0 : 0] wea
     .addra(addra),  // input wire [7 : 0] addra
     .dina(dina),    // input wire [10 : 0] dina
     .douta(douta)  // output wire [10 : 0] douta
   );
   
   //PWM Out - this gets tied to the BRAM
   reg [10:0] PWM;

   
   // Instantiate the PWM module
   // PWM should take in the clock, the data from memory
   // PWM should output to AUD_PWM (or whatever the constraints file uses for the audio out.
   pwm_module pwm_mod (
     .clk(CLK100MHZ),
     .PWM_in(PWM),
     .PWM_out(AUD_PWM)
   );
   
    reg [12:0] clkdiv = 0;
   
   always @(posedge CLK100MHZ) begin   
   
        PWM <= douta; // tie memory output to the PWM input
        clkdiv <= clkdiv + 1;
  
        if (clkdiv >= 1493) begin
          clkdiv[12:0] <= 0;
          addra <= addra +1;
        end   
        
    end
    
    assign AUD_SD = 1'b1;  // Enable audio out



endmodule
