`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2026 11:06:53 AM
// Design Name: 
// Module Name: FIFO
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


module FIFO(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

reg [7:0] mem [7:0];
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
reg [3:0] count;

integer i;

always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 3'd0;
        rd_ptr <= 3'd0;
        count  <= 4'd0;
        data_out <= 8'd0;

        for (i = 0; i < 8; i = i + 1)
            mem[i] <= 8'd0;
    end
    else begin
        if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;    //mem[0] = input data1                                    //mem[1] = input data
            wr_ptr <= wr_ptr + 1'b1;   //mem[0] = input data2
            count <= count + 1'b1;
        end

        if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
            count <= count - 1'b1;
        end
    end
end

assign full = (count == 4'd8);
assign empty = (count == 4'd0);

endmodule
  
     
 
 
