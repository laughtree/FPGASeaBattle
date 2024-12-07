`include "consts.v"
module FSM(
    input clk,
    input rst,
    input [3:0] key_num,
    input actionDone,
    input gameover,
    output reg [2:0] state
);

reg [2:0] next_state;

always @ (posedge clk or posedge rst) state <= rst ? `INIT : next_state;

always @ (*) begin
    case(state)
        `INIT: begin
            next_state = `PLAYERA_SET;
        end
        `PLAYERA_SET: begin
            next_state = (actionDone && key_num == 1) ? `PLAYERB_SET : `PLAYERA_SET;
        end
        `PLAYERB_SET: begin
            next_state = (actionDone && key_num == 1) ? `PLAYERA_ATTACK : `PLAYERB_SET;
        end
        `PLAYERA_ATTACK: begin
            next_state = gameover ? `FIN : actionDone ? `PLAYERB_ATTACK : `PLAYERA_ATTACK;
        end
        `PLAYERB_ATTACK: begin
            next_state = gameover ? `FIN : actionDone ? `PLAYERA_ATTACK : `PLAYERB_ATTACK;
        end
        `FIN: begin
            next_state = key_num == 1 ? `INIT : `FIN;
        end
        default: begin
            next_state = `INIT;
        end
    endcase
end

endmodule
