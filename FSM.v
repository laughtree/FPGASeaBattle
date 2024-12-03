module FSM(
    input clk,
    input rst
);

parameter [2:0] INIT = 3'b000;
parameter [2:0] PLAYERA_SET = 3'b001;
parameter [2:0] PLAYERB_SET = 3'b010;
parameter [2:0] PLAYERA_ATTACK = 3'b011;
parameter [2:0] PLAYERB_ATTACK = 3'b100;
parameter [2:0] FIN = 3'b101;

reg [2:0] next_state;
reg [2:0] state;

keyTrans KT(
    .clk(clk),
    .rst(rst),
    .state(state),
    .key_num(key_num),
    .prev_key_num(prev_key_num)
);

wire setDone;
gameController GC(
    .clk(clk),
    .state(state),
    .key(key),
    .prev_key(prev_key),
    .setDone(setDone)
);

always @ (posedge clk or posedge rst) state <= rst ? INIT : next_state;

always @ (*) begin
    case(state)
        INIT: begin
            next_state = PLAYERA_SET;
        end
        PLAYERA_SET: begin
            next_state = (setDone && key == 0) ? PLAYERB_SET : PLAYERA_SET;
        end
        PLAYERB_SET: begin
            next_state = (setDone && key == 0) ? PLAYERA_ATTACK : PLAYERB_SET;
        end
        PLAYERA_ATTACK: begin
            next_state = PLAYERB_ATTACK;
        end
        PLAYERB_ATTACK: begin
            next_state = FIN;
        end
        FIN: begin
            next_state = INIT;
        end
        default: begin
            next_state = INIT;
        end
    endcase
end

endmodule
