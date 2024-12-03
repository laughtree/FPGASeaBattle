module ScreenController(
    input clk,
    input rst,
    output [11:0] vgaRGB,
    output hsync,
    output vsync
    );

    wire clk_div22;
    wire valid;
    wire [9:0] h_cnt, v_cnt;
    wire [12:0] pixel_addr;
    wire [11:0] data;
    wire [11:0] pixel;

    clock_divider #(.n(22))clk22(
        .clk(clk),
        .clk_div(clk_div22)
    );

    vga_controller vga(
        .pclk(clk_div22),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );

    pixel_addr_gen pag(
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .part(1),
        .pixel_addr(pixel_addr)
    );

    blk_mem_gen_0 blk_mem_inst (
        .clka(clk),
        .wea(0),
        .addra(pixel_addr),
        .dina(data),
        .douta(pixel)
    );

    assign vgaRGB = (h_cnt < 40 && v_cnt < 40) ?pixel :12'b0;
endmodule
