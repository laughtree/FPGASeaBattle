`include "consts.v"
module timer #(
    parameter MAX_SEC = 3
)(
    input wire clk,
    input wire rst,
    input [2:0] state,
    output timeup
);
`define MAX_COUNT MAX_SEC * 100000000

integer count;
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end else begin
        count <= (count == `MAX_COUNT ? 0 : count + (state == `FIN));
    end
end

assign timeup = (count == `MAX_COUNT);

endmodule