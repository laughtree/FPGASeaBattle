module main(
    input wire clk,
    input wire rst,
    inout wire PS2_CLK,
    inout wire PS2_DATA,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output HSYNC,
    output VSYNC
    );

    FSM FSM_inst (
        .clk(clk),
        .rst(rst)
    );

    ScreenController SC(
        .clk(clk),
        .rst(rst),
        .vgaRGB({VGA_R, VGA_G, VGA_B}),
        .hsync(HSYNC),
        .vsync(VSYNC)
    );
endmodule
