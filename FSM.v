module FSM(
    input clk,
    input rst,
    input [3:0] key_num,
    input actionDone,
    input gameover,
    output reg [2:0] state
);

parameter [2:0] INIT = 3'b000;
parameter [2:0] PLAYERA_SET = 3'b001;
parameter [2:0] PLAYERB_SET = 3'b010;
parameter [2:0] PLAYERA_ATTACK = 3'b011;
parameter [2:0] PLAYERB_ATTACK = 3'b100;
parameter [2:0] FIN = 3'b101;

reg [2:0] next_state;

always @ (posedge clk or posedge rst) state <= rst ? INIT : next_state;

always @ (*) begin
    case(state)
        INIT: begin
            next_state = PLAYERA_SET;
        end
        PLAYERA_SET: begin
            next_state = (actionDone && key_num == 1) ? PLAYERB_SET : PLAYERA_SET;
        end
        PLAYERB_SET: begin
            next_state = (actionDone && key_num == 1) ? PLAYERA_ATTACK : PLAYERB_SET;
        end
        PLAYERA_ATTACK: begin
            next_state = gameover ? FIN : actionDone ? PLAYERB_ATTACK : PLAYERA_ATTACK;
        end
        PLAYERB_ATTACK: begin
            next_state = gameover ? FIN : actionDone ? PLAYERA_SET : PLAYERB_ATTACK;
        end
        FIN: begin
            next_state = key_num == 1 ? INIT : FIN;
        end
        default: begin
            next_state = INIT;
        end
    endcase
end

endmodule
