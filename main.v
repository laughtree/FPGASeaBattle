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

    wire [2:0] state;
    wire [3:0] key_num;
    wire [3:0] prev_key_num;
    wire actionDone;
    wire [3:0] x;
    wire [3:0] y;
    wire [575:0] raw_map;
    wire gameover;
    wire side;

    FSM fsm(
        .clk(clk),
        .rst(rst),
        .key_num(key_num),
        .actionDone(actionDone),
        .gameover(gameover),
        .state(state)
    );

    keyTrans KT(
        .clk(clk),
        .rst(rst),
        .state(state),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA),
        .key_num(key_num),
        .prev_key_num(prev_key_num)
    );

    gameController GC(
        .clk(clk),
        .state(state),
        .key(key_num),
        .prev_key(prev_key_num),
        .maxShipCount(5),
        .actionDone(actionDone),
        .x(x),
        .y(y),
        .raw_map(raw_map),
        .gameover(gameover),
        .side(side)
    );

    ScreenController SC(
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .side(side),
        .vgaRGB({VGA_R, VGA_G, VGA_B}),
        .hsync(HSYNC),
        .vsync(VSYNC)
    );


endmodule
