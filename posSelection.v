`include "consts.v"
module posSelection(
    input clk,
    input [2:0] state, 
    input [3:0] key,
    input [3:0] prev_key,
    output reg [3:0] x,
    output reg [3:0] y,
    output reg direction
);

always @ (posedge clk) begin
    if(state == `PLAYERA_SET || state == `PLAYERB_SET || state == `PLAYERA_ATTACK || state == `PLAYERB_ATTACK) begin
        if(key != prev_key) begin
            case(key)
            `ENTER: begin
                x <= 0;
                y <= 0;
                direction <= 0;
            end
            `W: begin
                y <= y > 0 ? y - 1 : y;
            end
            `A: begin
                x <= x > 0 ? x - 1 : x;
            end
            `S: begin
                y <= y < 11 ? y + 1 : y;
            end
            `D: begin
                x <= x < 11 ? x + 1 : x;
            end
            `SPACE: begin
                direction <= ~direction;
            end
            endcase
        end
    end
    else begin
        direction <= 0;
        x <= 0;
        y <= 0;
    end
end
endmodule