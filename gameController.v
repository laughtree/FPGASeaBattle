module gameController(
    input wire clk,
    input wire [2:0] state,
    input [3:0] key,
    input [3:0] prev_key,
    output reg setDone
);

parameter [2:0] INIT = 3'b000;
parameter [2:0] PLAYERA_SET = 3'b001;
parameter [2:0] PLAYERB_SET = 3'b010;
parameter [2:0] PLAYERA_ATTACK = 3'b011;
parameter [2:0] PLAYERB_ATTACK = 3'b100;
parameter [2:0] FIN = 3'b101;



always @ (posedge clk) begin
    case(state) 
        INIT: begin
            setDone <= 0;
        end

    endcase
end

endmodule
