module gameController(
    input wire clk,
    input wire [2:0] state,
    input [3:0] key,
    input [3:0] prev_key,
    input [4:0] maxShipCount,
    output reg actionDone,
    output reg [3:0] x,
    output reg [3:0] y,
    output wire [575:0] raw_map,
    output reg gameover,
    output reg side
);

parameter [2:0] INIT = 3'b000;
parameter [2:0] PLAYERA_SET = 3'b001;
parameter [2:0] PLAYERB_SET = 3'b010;
parameter [2:0] PLAYERA_ATTACK = 3'b011;
parameter [2:0] PLAYERB_ATTACK = 3'b100;
parameter [2:0] FIN = 3'b101;

parameter ENTER = 4'b0001;
parameter W = 4'b0010;
parameter A = 4'b0011;
parameter S = 4'b0100;
parameter D = 4'b0101;
parameter SPACE = 4'b0110;

integer setShipCount;
reg direction;
reg winner;

reg [575:0] map [1:0];
assign raw_map = map[side];

always @ (*) begin
    if(state == INIT) begin
        side = 0;
    end
    else if(state == PLAYERA_SET || state == PLAYERA_ATTACK) begin
        side = 0;
    end
    else if(state == PLAYERB_SET || state == PLAYERB_ATTACK) begin
        side = 1;
    end
    else if(state == FIN) begin
        side = winner;
    end
    else begin
        side = 0;
    end
end

always @ (posedge clk) begin
    if(state >= PLAYERA_SET && state <= PLAYERB_ATTACK) begin
        if(key != prev_key) begin
            case(key)
            ENTER: begin
                x <= 0;
                y <= 0;
                direction <= 0;
            end
            W: begin
                y <= y > 0 ? y - 1 : y;
            end
            A: begin
                x <= x > 0 ? x - 1 : x;
            end
            S: begin
                y <= y < 11 ? y + 1 : y;
            end
            D: begin
                x <= x < 11 ? x + 1 : x;
            end
            SPACE: begin
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

integer i;
reg [575:0] ship_gen;
always @ (*) begin
    for(i = 0; i < 576; i = i + 1) begin
        ship_gen[i] = 0;
    end
    if(direction == 0) begin // vertical
        if(setShipCount % 5 == 0) begin // ship len = 2
            if(y < 10) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 1;

                ship_gen[(y + 1) * 48 + x * 4] <= side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] <= 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 1) * 48 + x * 4 + 2] <= 0;
                ship_gen[(y + 1) * 48 + x * 4 + 3] <= 0;
            end
        end
        else if(setShipCount % 5 == 1 || setShipCount % 5 == 2) begin // ship len = 3
            if(y < 9) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 1;
                
                ship_gen[(y + 1) * 48 + x * 4] <= side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] <= 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 1) * 48 + x * 4 + 2] <= 1;
                ship_gen[(y + 1) * 48 + x * 4 + 3] <= 0;

                ship_gen[(y + 2) * 48 + x * 4] <= side;
                ship_gen[(y + 2) * 48 + x * 4 + 1] <= 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 2) * 48 + x * 4 + 2] <= 0;
                ship_gen[(y + 2) * 48 + x * 4 + 3] <= 0;
            end
        end
        else if(setShipCount % 5 == 3) begin // ship len = 4
            if(y < 8) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 1;

                ship_gen[(y + 1) * 48 + x * 4] <= side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] <= 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 1) * 48 + x * 4 + 2] <= 1;
                ship_gen[(y + 1) * 48 + x * 4 + 3] <= 0;

                ship_gen[(y + 2) * 48 + x * 4] <= side;
                ship_gen[(y + 2) * 48 + x * 4 + 1] <= 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 2) * 48 + x * 4 + 2] <= 1;
                ship_gen[(y + 2) * 48 + x * 4 + 3] <= 0;

                ship_gen[(y + 3) * 48 + x * 4] <= side;
                ship_gen[(y + 3) * 48 + x * 4 + 1] <= 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 3) * 48 + x * 4 + 2] <= 0;
                ship_gen[(y + 3) * 48 + x * 4 + 3] <= 0;
            end
        end
        else if(setShipCount % 5 == 4) begin // ship len = 5
            if(y < 7) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b011 -> 正垂直頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 1;

                ship_gen[(y + 1) * 48 + x * 4] <= side;
                ship_gen[(y + 1) * 48 + x * 4 + 1] <= 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 1) * 48 + x * 4 + 2] <= 1;
                ship_gen[(y + 1) * 48 + x * 4 + 3] <= 0;

                ship_gen[(y + 2) * 48 + x * 4] <= side;
                ship_gen[(y + 2) * 48 + x * 4 + 1] <= 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 2) * 48 + x * 4 + 2] <= 1;
                ship_gen[(y + 2) * 48 + x * 4 + 3] <= 0;

                ship_gen[(y + 3) * 48 + x * 4] <= side;
                ship_gen[(y + 3) * 48 + x * 4 + 1] <= 1; // 3'b110 -> 垂直中間
                ship_gen[(y + 3) * 48 + x * 4 + 2] <= 1;
                ship_gen[(y + 3) * 48 + x * 4 + 3] <= 0;

                ship_gen[(y + 4) * 48 + x * 4] <= side;
                ship_gen[(y + 4) * 48 + x * 4 + 1] <= 1; // 3'b100 -> 反垂直頭
                ship_gen[(y + 4) * 48 + x * 4 + 2] <= 0;
                ship_gen[(y + 4) * 48 + x * 4 + 3] <= 0;
            end
        end
    end
    else begin // horizontal
        if(setShipCount % 5 == 0) begin // ship len = 2
            if(x < 10) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 0;

                ship_gen[y * 48 + (x + 1) * 4] <= side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] <= 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 1) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] <= 1;
            end
        end
        else if(setShipCount % 5 == 1 || setShipCount % 5 == 2) begin // ship len = 3
            if(x < 9) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 0;

                ship_gen[y * 48 + (x + 1) * 4] <= side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] <= 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 1) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] <= 1;

                ship_gen[y * 48 + (x + 2) * 4] <= side;
                ship_gen[y * 48 + (x + 2) * 4 + 1] <= 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 2) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 2) * 4 + 3] <= 1;
            end
        end
        else if(setShipCount % 5 == 3) begin // ship len = 4
            if(x < 8) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 0;

                ship_gen[y * 48 + (x + 1) * 4] <= side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] <= 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 1) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] <= 1;

                ship_gen[y * 48 + (x + 2) * 4] <= side;
                ship_gen[y * 48 + (x + 2) * 4 + 1] <= 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 2) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 2) * 4 + 3] <= 1;

                ship_gen[y * 48 + (x + 3) * 4] <= side;
                ship_gen[y * 48 + (x + 3) * 4 + 1] <= 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 3) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 3) * 4 + 3] <= 1;
            end
        end
        else if(setShipCount % 5 == 4) begin // ship len = 5
            if(x < 7) begin
                ship_gen[y * 48 + x * 4] <= side;
                ship_gen[y * 48 + x * 4 + 1] <= 0; // 3'b010 -> 反水平頭
                ship_gen[y * 48 + x * 4 + 2] <= 1;
                ship_gen[y * 48 + x * 4 + 3] <= 0;

                ship_gen[y * 48 + (x + 1) * 4] <= side;
                ship_gen[y * 48 + (x + 1) * 4 + 1] <= 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 1) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 1) * 4 + 3] <= 1;

                ship_gen[y * 48 + (x + 2) * 4] <= side;
                ship_gen[y * 48 + (x + 2) * 4 + 1] <= 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 2) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 2) * 4 + 3] <= 1;

                ship_gen[y * 48 + (x + 3) * 4] <= side;
                ship_gen[y * 48 + (x + 3) * 4 + 1] <= 1; // 3'b101 -> 水平中間
                ship_gen[y * 48 + (x + 3) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 3) * 4 + 3] <= 1;

                ship_gen[y * 48 + (x + 4) * 4] <= side;
                ship_gen[y * 48 + (x + 4) * 4 + 1] <= 0; // 3'b001 -> 正水平頭
                ship_gen[y * 48 + (x + 4) * 4 + 2] <= 0;
                ship_gen[y * 48 + (x + 4) * 4 + 3] <= 1;
            end
        end
    end
end

wire [2:0] ship_len;
assign ship_len = (setShipCount % 5 == 0) ? 3'b010 : (setShipCount % 5 == 1 || setShipCount % 5 == 2) ? 3'b011 : (setShipCount % 5 == 3) ? 3'b100 : 3'b101;

reg putable;
integer j;

always @ (*) begin
    putable = (direction == 0 && y + ship_len < 12) || (direction == 1 && x + ship_len < 12);
    for(j = 0;j < ship_len && putable;j = j + 1) begin
        if(direction == 0) begin
            putable = ({map[side][(y + j) * 48 + x * 4], map[side][(y + j) * 48 + x * 4 + 1], map[side][(y + j) * 48 + x * 4 + 2], map[side][(y + j) * 48 + x * 4 + 3]} == 4'b0000);
        end
        else begin
            putable = ({map[side][y * 48 + (x + j) * 4], map[side][y * 48 + (x + j) * 4 + 1], map[side][y * 48 + (x + j) * 4 + 2], map[side][y * 48 + (x + j) * 4 + 3]} == 4'b0000);
        end
    end
end

always @ (posedge clk) begin
    if(state == PLAYERA_SET || state == PLAYERB_SET) begin
        if(key != prev_key) begin
            if(key == ENTER) begin
                if(setShipCount < maxShipCount && putable) begin
                    map[side] <= map[side] | ship_gen;
                    setShipCount <= setShipCount + 1;
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
    else if(state == PLAYERA_ATTACK || state == PLAYERB_ATTACK) begin
    end
    else begin
        setShipCount <= 0;
        actionDone <= 0;
        map[0] <= 576'b0;
        map[1] <= 576'b0;
    end
end

endmodule
