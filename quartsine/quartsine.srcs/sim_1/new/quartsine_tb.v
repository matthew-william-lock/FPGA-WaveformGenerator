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
    reg ena=1;
    reg wea=0;
    reg [5:0]addra=0;
    reg [10:0]dina;
    
    wire [10:0]douta;
    
    
    blk_mem_gen_1 bram (
      .clka(CLK100MHZ_tb),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra),  // input wire [7 : 0] addra
      .dina(dina),    // input wire [10 : 0] dina
      .douta(douta)  // output wire [10 : 0] douta
    );
    
    reg [10:0] PWM;
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
    
    initial begin
    
        $display("\t\ttime,\tCLK100MHZ,\taddra,\tdouta");
        $monitor("%d,\t%b,\t\t%d,\t%d",$time,CLK100MHZ,addra,douta);
        
        repeat (0) begin
            CLK100MHZ=0; #1;
            CLK100MHZ=1; #1;
        end
       
        repeat ('d256) begin
            CLK100MHZ=0; #1;
            CLK100MHZ=1; #1;
        end  
        
        repeat (0) begin
            CLK100MHZ=0; #1;
            CLK100MHZ=1; #1;
        end 
    
    end

endmodule
