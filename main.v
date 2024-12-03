module main(
    input wire clk,
    input wire rst,
    inout PS2_CLK,
    inout PS2_DATA,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire HSYNC,
    output wire VSYNC
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
