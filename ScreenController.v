module ScreenController(
    input clk,
    input rst,
    input [3:0] x,
    input [3:0] y,
    input side,
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
    wire [11:0] render;
    wire [3:0] renderR, renderB;
    reg [3:0] map [0:143];
    wire [2:0] part;
    integer position, i;

    initial begin
        for(i=0; i<144; i = i+1)
            map[i] = 4'b0000;
        map[4] = 4'b0010;
        map[64] = 4'b1100;
    end

    always @(posedge clk) begin
        position <= (h_cnt<80 || h_cnt >= 560) ?-1 :(h_cnt-80)/40 + v_cnt/40*12; 
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
        .part(part),//map[position][2:0]
        .pixel_addr(pixel_addr)
    );

    blk_mem_gen_0 blk_mem_inst (
        .clka(clk),
        .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel)
    );

    assign part = map[position][2:0];

    assign renderR = (pixel[11:8] + 4'h2) > 15 ? 15 : pixel[11:8] + 4'h2;
    assign renderB = (pixel[3:0] + 4'h2) > 15 ? 15 : pixel[3:0] + 4'h2;
    assign render  = {(map[position][3] ? renderR : pixel[11:8]), pixel[7:4], (map[position][3] ? pixel[3:0] : renderB)};

    assign vgaRGB = valid 
    ? (h_cnt < 80 || h_cnt >= 560 || h_cnt%40 == 0 || h_cnt%40 == 39 || v_cnt%40 == 0 || v_cnt%40 == 39 || ((h_cnt%40 == 1 || h_cnt%40 == 38) && (v_cnt%40 == 1 || v_cnt % 40 == 38))) 
        ?12'hFB4
        :(pixel == 12'hFFF || map[position] == 4'b0000)
            ?(((((h_cnt - 80) / 40) == x) && ((v_cnt / 40) == y)) 
                ?{4'hD - ((side == 0) * 3), 4'hA, 4'h3 - ((side == 1) * 3)}
                :12'hA70)
            :render
    : 12'h0;
endmodule
