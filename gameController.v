module gameController(
    input wire clk,
    input wire [2:0] state,
    input [3:0] key,
    input [3:0] prev_key,
    input [4:0] maxShipCount,
    output reg actionDone,
    output reg [3:0] x,
    output reg [3:0] y,
    output reg [575:0] raw_map,
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
            endcase
        end
    end
    else begin
        x <= 0;
        y <= 0;
    end
end

always @ (posedge clk) begin
    if(state >= PLAYERA_SET && state <= PLAYERB_SET) begin
        if(key != prev_key) begin
            if(key == ENTER) begin
                raw_map[y*48 + x*4] <= side;
            end
        end
    end
end

endmodule
