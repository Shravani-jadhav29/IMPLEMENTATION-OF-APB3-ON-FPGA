
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2026 01:06:53 AM
// Design Name: 
// Module Name: PWM
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
///////////////////////////////////////////////////////////////////////////////
module pwm_slave(

input clk,
input rst,


input psel,
input penable,
input pwrite,
input [7:0] pwdata,

output reg [7:0] prdata,
output reg pready,
output reg pslverr,



output reg pwm_out

);


reg [1:0] duty_sel;
reg [12:0] counter;
reg [12:0] duty;


parameter PERIOD = 13'd5000;




always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        duty_sel <= 2'b00;
        pready   <= 1'b0;
        pslverr  <= 1'b0;
        prdata   <= 8'h00;
    end

    else
    begin

        pready <= 1'b0;


        if(psel && penable)
        begin

            pready <= 1'b1;


            if(pwrite)
            begin
                duty_sel <= pwdata[1:0];
            end


            else
            begin
                prdata <= {6'b0,duty_sel};
            end

        end

    end

end




always @(posedge clk or posedge rst)
begin

    if(rst)
        counter <= 13'd0;


    else
    begin

        if(counter == PERIOD-1)
            counter <= 13'd0;

        else
            counter <= counter + 1'b1;

    end

end





always @(*)
begin

case(duty_sel)

    2'b00:
        duty = 13'd1250;   //25%


    2'b01:
        duty = 13'd2500;   //50%


    2'b10:
        duty = 13'd3750;   //75%


    2'b11:
        duty = 13'd5000;   //100%


    default:
        duty = 13'd1250;

endcase

end




always @(*)
begin

    if(counter < duty)
        pwm_out = 1'b1;

    else
        pwm_out = 1'b0;

end


endmodule
