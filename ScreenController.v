module ScreenController(
    input clk,
    input rst,
    output [11:0] vgaRGB,
    output hsync,
    output vsync
    );

    wire clk_div25MHz;
    wire valid;
    wire [9:0] h_cnt, v_cnt;
    wire [12:0] pixel_addr;
    wire [11:0] data;
    wire [11:0] pixel;
    integer position;

    always @* begin
        position = (h_cnt<80 || h_cnt >= 560) ?-1 :(h_cnt-80)/40 + v_cnt/40*12; 
    end

    clock_divider #(.n(2))clk2(
        .clk(clk),
        .clk_div(clk_div25MHz)
    );

    vga_controller vga(
        .pclk(clk_div25MHz),
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
        .part(3'b101),
        .pixel_addr(pixel_addr)
    );

    blk_mem_gen_0 blk_mem_inst (
        .clka(clk),
        .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel)
    );

    assign vgaRGB = valid 
    ? (h_cnt < 80 || h_cnt >= 560 || h_cnt%40 == 0 || h_cnt%40 == 39 || v_cnt%40 == 0 || v_cnt%40 == 39) 
        ?12'hFB4
        :pixel
    : 12'h0;
endmodule
