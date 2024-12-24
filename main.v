module main(
    input wire clk,
    input wire rst,
    inout wire PS2_CLK,
    inout wire PS2_DATA,
    input wire [15:0] SW,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output HSYNC,
    output VSYNC,
    output [2:0] state
    );

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
        .maxShipCount(SW[1] + SW[2] + SW[3] + SW[4] + SW[5] + SW[6] + SW[7] + SW[8] + SW[9] + SW[10] + SW[11] + SW[12] + SW[13] + SW[14] + SW[15]),
        .cheat(SW[0]),
        .actionDone(actionDone),
        .gameover(gameover),
        .x(x),
        .y(y),
        .raw_map(raw_map),
        .side(side)
    );

    ScreenController SC(
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .side(side),
        .raw_map(raw_map),
        .state(state),
        .vgaRGB({VGA_R, VGA_G, VGA_B}),
        .hsync(HSYNC),
        .vsync(VSYNC)
    );


endmodule
