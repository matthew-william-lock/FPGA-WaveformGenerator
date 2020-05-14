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


module arpeggiator(
    input  CLK100MHZ,
    input [7:0] SW,
    input ARP_ON,
    output AUD_PWM, 
    output AUD_SD,
    output [2:0] LED
    );
    
    
   // Arpeggiator Function
   reg [2:0] note =0;
   reg [25:0] note_switch =0;
   reg [10:0]f_base;
   
   assign LED = note;
    
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
    reg [0:0] rep = 0;
    reg [1:0] return;
    
    function [1:0] determineAddra ; // Determine which address to play according to state of the phase
        input [1:0] phasein;
        
        begin
        
        case (phasein)
                   
            2'b00: begin                    
                if (!rep) addra = addra +1;
                if(addra>=63) begin
                    if (!rep) begin
                        rep=1'b1;
                    end
                    else begin
                        phase=phase+1'b1;
                        rep=1'b0;
                    end
                end               
            end
            
            2'b01: begin         
                if (!rep) addra = addra -1;
                if(addra<=0) begin
                    if (!rep) begin
                        rep=1'b1;
                    end
                    else begin
                        phase=phase+1'b1;
                        rep=1'b0;
                    end
                end               
            end
            
            2'b10: begin               
                if (!rep) addra = addra +1;
                if(addra>=63) begin
                    if (!rep) begin
                        rep=1'b1;
                    end
                    else begin
                        phase=phase+1'b1;
                        rep=1'b0;
                    end
                end                
            end
            
            2'b11: begin          
            if (!rep) addra = addra -1;
                if(addra<=0) begin
                    if (!rep) begin
                        rep=1'b1;
                    end
                    else begin
                        phase=phase+1'b1;
                        rep=1'b0;
                    end
                end            
            end
          
          endcase
          
        determineAddra = 2'b01;
        end
    endfunction
   
   always @(posedge CLK100MHZ) begin   
   
//        PWM <= douta; // tie memory output to the PWM input

        case(phase)
            2'b00: PWM <= douta;
            2'b01: PWM <= douta;
            2'b10: PWM <= ~douta;
            2'b11: PWM <= ~douta;        
        endcase
    
        clkdiv <= clkdiv + 1;
        
        f_base[10:0] <= 1493 + {3'b000,SW[7:0]};
        
        note_switch = note_switch + 1; // keep track of when to change notes
        
        if (ARP_ON && note_switch == 50000000) begin
            if (note!=3)note <= note +1;
            else note<=0;
            note_switch <= 0;
        end
        
        else if (!ARP_ON) begin
             note<=4; // Only play middle C
             note_switch<=0; // Reset time to start play notes
         end
         
        else if (ARP_ON && note==4) note<=0; //Account for transition between arp on and off
        
        case (note)
        
            0: begin
                if (clkdiv >= f_base) begin
                    clkdiv[12:0] <= 0;
                    return<=determineAddra(phase);
                end                              
            end
            
            1: begin
                if (clkdiv >= f_base/5*4) begin
                    clkdiv[12:0] <= 0;
                    return<=determineAddra(phase);
                end            
            end 
            
            2: begin
                if (clkdiv >= f_base/3*2) begin
                    clkdiv[12:0] <= 0;
                    return<=determineAddra(phase);
                end            
            end
            
            3: begin
                if (clkdiv >= f_base/2) begin
                    clkdiv[12:0] <= 0;
                    return<=determineAddra(phase);
                end            
            end
            
            4: begin
                if (clkdiv >= 1493) begin
                    clkdiv[12:0] <= 0;
                    return<=determineAddra(phase);
                end                              
            end
            
            
            default: begin
                if (clkdiv >= 1493) begin
                    clkdiv[12:0] <= 0;
                    return<=determineAddra(phase);
                end                              
            end
        
        endcase
  
         
        
    end
    
    assign AUD_SD = 1'b1;  // Enable audio out



endmodule
