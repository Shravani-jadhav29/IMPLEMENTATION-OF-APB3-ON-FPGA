module top(

input clk,
input rst,

input [15:0] sw,

input btnU,
input btnD,

output [9:0] led,
output [3:0] an,
output [6:0] seg,
output pwm_out

);

wire wr_db;
wire rd_db;

wire wr_pulse;
wire rd_pulse;

wire psel;
wire penable;
wire pwrite;

wire [7:0] paddr;
wire [7:0] pwdata;

wire [7:0] prdata;

wire pready;
wire pslverr;

wire [7:0] read_data;

wire done;
wire error;

wire pwm_pready;
wire pwm_pslverr;
wire [7:0] pwm_prdata;





// FIFO wires


wire fifo_full;
wire fifo_empty;
wire fifo_wr_en;
wire fifo_rd_en;
wire [7:0] fifo_data_in;
wire [7:0] fifo_data_out;

wire [7:0] fifo_prdata;
wire fifo_pready;
wire fifo_pslverr;

wire uart_sel;
wire gpio_sel;
wire fifo_sel;
wire pwm_sel;


//------------------------------------------------
// Debounce
//------------------------------------------------

debounce D1(
    .clk(clk),
    .rst(rst),
    .btn(btnU),
    .btn_db(wr_db)
);


debounce D2(
    .clk(clk),
    .rst(rst),
    .btn(btnD),
    .btn_db(rd_db)
);


//------------------------------------------------
// Edge Detector
//------------------------------------------------

edge_detector E1(
    .clk(clk),
    .rst(rst),
    .signal_in(wr_db),
    .pulse(wr_pulse)
);


edge_detector E2(
    .clk(clk),
    .rst(rst),
    .signal_in(rd_db),
    .pulse(rd_pulse)
);



apb3_master MASTER(

    .clk(clk),
    .rst(rst),

    .start(wr_pulse || rd_pulse),

    .rw(wr_pulse),

    .command_data(sw),

    .pready(pready),
    .pslverr(pslverr),

    .prdata(prdata),

    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),

    .paddr(paddr),
    .pwdata(pwdata),

    .read_data(read_data),

    .done(done),
    .error(error)

);


//------------------------------------------------
// APB SLAVE (Temporary)
//------------------------------------------------

assign pready =
        fifo_sel ? fifo_pready :
        pwm_sel  ? pwm_pready  :
        1'b0;

assign pslverr =
        fifo_sel ? fifo_pslverr :
        pwm_sel  ? pwm_pslverr  :
        1'b0;

assign prdata =
        fifo_sel ? fifo_prdata :
        pwm_sel  ? pwm_prdata  :
        8'h00;

apb3_decoder DEC(

    .psel(psel),
    .paddr(paddr),

    .uart_sel(uart_sel),
    .gpio_sel(gpio_sel),
    .fifo_sel(fifo_sel),
    .pwm_sel(pwm_sel)

    


);



apb_fifo_slave FIFO_SLAVE(

    .clk(clk),
    .rst(rst),

    .psel(fifo_sel),
    .penable(penable),
    .pwrite(pwrite),
    .pwdata(pwdata),

    .prdata(fifo_prdata),
    .pready(fifo_pready),
    .pslverr(fifo_pslverr),

    .wr_en(fifo_wr_en),
    .rd_en(fifo_rd_en),
    .data_in(fifo_data_in),

    .data_out(fifo_data_out),
    .full(fifo_full),
    .empty(fifo_empty)
    
 

);
FIFO F1(

    .clk(clk),
    .rst(rst),

    .wr_en(fifo_wr_en),
       .rd_en(fifo_rd_en),
     .data_in(fifo_data_in),
      .data_out(fifo_data_out),

    .full(fifo_full),
    .empty(fifo_empty)

);


display_mux DISP(

    .clk(clk),

    .data(fifo_data_out),

    .an(an),

    .seg(seg)

);

pwm_slave PWM
(
.clk(clk),
.rst(rst),

.psel(pwm_sel),
.penable(penable),
.pwrite(pwrite),
.pwdata(pwdata),

.prdata(pwm_prdata),
.pready(pwm_pready),
.pslverr(pwm_pslverr),

.pwm_out(pwm_out)

);



//------------------------------------------------
// LED STATUS
//------------------------------------------------

assign led[0] = psel;
assign led[1] = penable;
assign led[2] = pwrite;

assign led[3] = done;
assign led[4] = error;

assign led[5] = wr_pulse;
assign led[6] = rd_pulse;

assign led[7] = fifo_full;
assign led[8] = fifo_empty;

assign led[9] = pwm_out;




endmodule
