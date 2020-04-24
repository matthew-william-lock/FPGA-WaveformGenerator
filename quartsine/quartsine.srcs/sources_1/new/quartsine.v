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


module quartsine(
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
   reg [5:0] addra=0;
   reg [10:0] dina=0; //We're not putting data in, so we can leave this unassigned
   wire [10:0] douta;
   
   // Instantiate block memory 
   blk_mem_gen_1 bram (
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
    reg [1:0] phase = 0;
   
   always @(posedge CLK100MHZ) begin   
   
//        PWM <= douta; // tie memory output to the PWM input
        case(phase)
            2'b00: PWM <= douta;
            2'b01: PWM <= douta;
            2'b10: PWM <= ~douta;
            2'b11: PWM <= ~douta;        
        endcase        
        
        clkdiv <= clkdiv + 1;
  
        if (clkdiv >= 1493) begin
          clkdiv[12:0] <= 0;
          case (phase)
           
            2'b00: begin
                addra <= addra +1;
                if(addra>=62) phase<=phase+1'b1;
            end
            
            2'b01: begin
                addra <= addra -1;
                if(addra==1) phase<=phase+1'b1;
            end
            
            2'b10: begin
                addra <= addra +1;
                if(addra>=62) phase<=phase+1'b1;
            end
            
            2'b11: begin
                addra <= addra -1;
                if(addra==1) phase<=phase+1'b1;
            end
          
          endcase
          
        end   
        
    end
    
    assign AUD_SD = 1'b1;  // Enable audio out



endmodule
