`include "consts.v"
module gameController(
    input wire clk,
    input wire [2:0] state,
    input [3:0] key,
    input [3:0] prev_key,
    input [4:0] maxShipCount,
    input cheat,
    output reg actionDone,
    output wire [3:0] x,
    output wire [3:0] y,
    output reg [575:0] raw_map,
    output wire gameover,
    output reg side
);

integer setShipCount;
wire direction;
reg winner;

reg [575:0] map [1:0];
reg [575:0] mask [1:0];
always @ (*) begin
    if(state == `INIT) begin
        raw_map = 576'b0;
    end
    else if(state == `PLAYERA_SET || state == `PLAYERB_SET) begin
        raw_map = map[side];
    end
    else if(state == `PLAYERA_ATTACK || state == `PLAYERB_ATTACK) begin
        raw_map = cheat ? map[!side] : mask[!side] & map[!side];
    end
    else if(state == `FIN) begin
        raw_map = map[!winner];
    end
    else begin
        raw_map = 576'b0;
    end
end

assign gameover = (mask[!side] ^ map[!side]) == 576'b0;

always @ (*) begin
    if(state == `INIT) begin
        side = 0;
    end
    else if(state == `PLAYERA_SET || state == `PLAYERA_ATTACK) begin
        side = 0;
    end
    else if(state == `PLAYERB_SET || state == `PLAYERB_ATTACK) begin
        side = 1;
    end
    else if(state == `FIN) begin
        side = winner;
    end
    else begin
        side = 0;
    end
end

always @ (posedge clk) begin
    if(state == `FIN) begin
        winner <= winner;
    end
    else begin
        winner <= side;
    end
end

posSelection posselect(
    .clk(clk),
    .state(state),
    .key(key),
    .prev_key(prev_key),
    .x(x),
    .y(y),
    .direction(direction)
);

reg [575:0] ship_gen;
wire [2:0] ship_len;

assign ship_len = (setShipCount % 5 == 0) ? 3'b010 : (setShipCount % 5 == 1 || setShipCount % 5 == 2) ? 3'b011 : (setShipCount % 5 == 3) ? 3'b100 : 3'b101;


// 依據現在所選位置預生成船
// 不知道為什麼切不出去
always @ (*) begin
    ship_gen = 576'b0;
    if(direction == 0) begin // vertical
        if(setShipCount % 5 == 0) begin // ship len = 2
            if(y <= 10) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 1;

                ship_gen[(y + 1) * 48 + x * 4] = side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] = 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 1) * 48 + x * 4 + 2] = 0;
                ship_gen[(y + 1) * 48 + x * 4 + 3] = 0;
            end
        end
        else if(setShipCount % 5 == 1 || setShipCount % 5 == 2) begin // ship len = 3
            if(y <= 9) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 1;
                
                ship_gen[(y + 1) * 48 + x * 4] = side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] = 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 1) * 48 + x * 4 + 2] = 1;
                ship_gen[(y + 1) * 48 + x * 4 + 3] = 0;

                ship_gen[(y + 2) * 48 + x * 4] = side;
                ship_gen[(y + 2) * 48 + x * 4 + 1] = 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 2) * 48 + x * 4 + 2] = 0;
                ship_gen[(y + 2) * 48 + x * 4 + 3] = 0;
            end
        end
        else if(setShipCount % 5 == 3) begin // ship len = 4
            if(y <= 8) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 1;

                ship_gen[(y + 1) * 48 + x * 4] = side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] = 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 1) * 48 + x * 4 + 2] = 1;
                ship_gen[(y + 1) * 48 + x * 4 + 3] = 0;

                ship_gen[(y + 2) * 48 + x * 4] = side;
                ship_gen[(y + 2) * 48 + x * 4 + 1] = 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 2) * 48 + x * 4 + 2] = 1;
                ship_gen[(y + 2) * 48 + x * 4 + 3] = 0;

                ship_gen[(y + 3) * 48 + x * 4] = side;
                ship_gen[(y + 3) * 48 + x * 4 + 1] = 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 3) * 48 + x * 4 + 2] = 0;
                ship_gen[(y + 3) * 48 + x * 4 + 3] = 0;
            end
        end
        else if(setShipCount % 5 == 4) begin // ship len = 5
            if(y <= 7) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 1;

                ship_gen[(y + 1) * 48 + x * 4] = side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] = 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 1) * 48 + x * 4 + 2] = 1;
                ship_gen[(y + 1) * 48 + x * 4 + 3] = 0;

                ship_gen[(y + 2) * 48 + x * 4] = side;
                ship_gen[(y + 2) * 48 + x * 4 + 1] = 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 2) * 48 + x * 4 + 2] = 1;
                ship_gen[(y + 2) * 48 + x * 4 + 3] = 0;

                ship_gen[(y + 3) * 48 + x * 4] = side;
                ship_gen[(y + 3) * 48 + x * 4 + 1] = 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 3) * 48 + x * 4 + 2] = 1;
                ship_gen[(y + 3) * 48 + x * 4 + 3] = 0;

                ship_gen[(y + 4) * 48 + x * 4] = side;
                ship_gen[(y + 4) * 48 + x * 4 + 1] = 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 4) * 48 + x * 4 + 2] = 0;
                ship_gen[(y + 4) * 48 + x * 4 + 3] = 0;
            end
        end
    end
    else begin // horizontal
        if(setShipCount % 5 == 0) begin // ship len = 2
            if(x <= 10) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 0;

                ship_gen[y * 48 + (x + 1) * 4] = side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] = 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 1) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] = 1;
            end
        end
        else if(setShipCount % 5 == 1 || setShipCount % 5 == 2) begin // ship len = 3
            if(x <= 9) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 0;

                ship_gen[y * 48 + (x + 1) * 4] = side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] = 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 1) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] = 1;

                ship_gen[y * 48 + (x + 2) * 4] = side;
                ship_gen[y * 48 + (x + 2) * 4 + 1] = 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 2) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 2) * 4 + 3] = 1;
            end
        end
        else if(setShipCount % 5 == 3) begin // ship len = 4
            if(x <= 8) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 0;

                ship_gen[y * 48 + (x + 1) * 4] = side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] = 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 1) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] = 1;

                ship_gen[y * 48 + (x + 2) * 4] = side;
                ship_gen[y * 48 + (x + 2) * 4 + 1] = 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 2) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 2) * 4 + 3] = 1;

                ship_gen[y * 48 + (x + 3) * 4] = side;
                ship_gen[y * 48 + (x + 3) * 4 + 1] = 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 3) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 3) * 4 + 3] = 1;
            end
        end
        else if(setShipCount % 5 == 4) begin // ship len = 5
            if(x <= 7) begin
                ship_gen[y * 48 + x * 4] = side;
                ship_gen[y * 48 + x * 4 + 1] = 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] = 1;
                ship_gen[y * 48 + x * 4 + 3] = 0;

                ship_gen[y * 48 + (x + 1) * 4] = side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] = 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 1) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] = 1;

                ship_gen[y * 48 + (x + 2) * 4] = side;
                ship_gen[y * 48 + (x + 2) * 4 + 1] = 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 2) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 2) * 4 + 3] = 1;

                ship_gen[y * 48 + (x + 3) * 4] = side;
                ship_gen[y * 48 + (x + 3) * 4 + 1] = 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 3) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 3) * 4 + 3] = 1;

                ship_gen[y * 48 + (x + 4) * 4] = side;
                ship_gen[y * 48 + (x + 4) * 4 + 1] = 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 4) * 4 + 2] = 0;
                ship_gen[y * 48 + (x + 4) * 4 + 3] = 1;
            end
        end
    end
end

reg putable;
integer j;

// 檢查是否可以放置
always @ (*) begin
    putable = (direction == 0 && y + ship_len - 1 < 12) || (direction == 1 && x + ship_len - 1 < 12);
    for(j = 0;j < ship_len && putable;j = j + 1) begin
        if(direction == 0) begin
            putable = ({map[side][(y + j) * 48 + x * 4], map[side][(y + j) * 48 + x * 4 + 1], map[side][(y + j) * 48 + x * 4 + 2], map[side][(y + j) * 48 + x * 4 + 3]} == 4'b0000);
        end
        else begin
            putable = ({map[side][y * 48 + (x + j) * 4], map[side][y * 48 + (x + j) * 4 + 1], map[side][y * 48 + (x + j) * 4 + 2], map[side][y * 48 + (x + j) * 4 + 3]} == 4'b0000);
        end
    end
end

// 攻擊判定

always @ (posedge clk) begin
    if(state == `PLAYERA_SET || state == `PLAYERB_SET) begin
        if(key != prev_key) begin
            if(key == `ENTER) begin
                if(setShipCount < maxShipCount) begin
                    if(putable) begin
                        map[side] <= map[side] | ship_gen;
                        setShipCount <= setShipCount + 1;
                    end
                    actionDone <= 0;
                end
                else begin
                    actionDone <= 1;
                    setShipCount <= 0;
                end
            end
            else
                actionDone <= 0;
        end
        else
            actionDone <= 0;
    end
    else if(state == `PLAYERA_ATTACK || state == `PLAYERB_ATTACK) begin
        if(key != prev_key) begin
            if(key == `ENTER) begin
                if({map[!side][y * 48 + x * 4], map[!side][y * 48 + x * 4 + 1], map[!side][y * 48 + x * 4 + 2], map[!side][y * 48 + x * 4 + 3]} != 4'b0000) begin
                    {map[!side][y * 48 + x * 4], map[!side][y * 48 + x * 4 + 1], map[!side][y * 48 + x * 4 + 2], map[!side][y * 48 + x * 4 + 3]} <= {map[!side][y * 48 + x * 4], map[!side][y * 48 + x * 4 + 1], map[!side][y * 48 + x * 4 + 2], map[!side][y * 48 + x * 4 + 3]} == 4'b0000 ? 4'b1111 : {map[!side][y * 48 + x * 4], map[!side][y * 48 + x * 4 + 1], map[!side][y * 48 + x * 4 + 2], map[!side][y * 48 + x * 4 + 3]};
                    {mask[!side][y * 48 + x * 4], mask[!side][y * 48 + x * 4 + 1], mask[!side][y * 48 + x * 4 + 2], mask[!side][y * 48 + x * 4 + 3]} <= {map[!side][y * 48 + x * 4], map[!side][y * 48 + x * 4 + 1], map[!side][y * 48 + x * 4 + 2], map[!side][y * 48 + x * 4 + 3]} == 4'b0000 ? 4'b1111 : {map[!side][y * 48 + x * 4], map[!side][y * 48 + x * 4 + 1], map[!side][y * 48 + x * 4 + 2], map[!side][y * 48 + x * 4 + 3]};
                    {mask[side][y * 48 + x * 4], mask[side][y * 48 + x * 4 + 1], mask[side][y * 48 + x * 4 + 2], mask[side][y * 48 + x * 4 + 3]} <= {map[side][y * 48 + x * 4], map[side][y * 48 + x * 4 + 1], map[side][y * 48 + x * 4 + 2], map[side][y * 48 + x * 4 + 3]};
                    actionDone <= 0;
                end
                else begin
                    actionDone <= 1;
                end
            end
            else
                actionDone <= 0;
        end
        else
            actionDone <= 0;
    end
    else begin
        setShipCount <= 0;
        actionDone <= 0;
        map[0] <= 576'b0;
        map[1] <= 576'b0;
        mask[0] <= 576'b0;
        mask[1] <= 576'b0;
    end
end

endmodule
