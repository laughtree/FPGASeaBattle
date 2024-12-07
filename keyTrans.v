`include "consts.v"
module keyTrans(
    input wire clk,
    input wire rst,
    input wire state,
    inout PS2_CLK,
    inout PS2_DATA,
    output reg [3:0] key_num,
    output reg [3:0] prev_key_num
);
    wire key_valid;
    wire [8:0] last_change;
    wire [511:0] key_down;

    KeyboardDecoder KeyboardDecoder_inst (
        .rst(rst),
        .clk(clk),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid)
    );

    reg [3:0] last_key;
    always @ (*) begin
        case(last_change)
            `KEY_ENTER: last_key = 4'b0001;
            `KEY_W: last_key = 4'b0010;
            `KEY_A: last_key = 4'b0011;
            `KEY_S: last_key = 4'b0100;
            `KEY_D: last_key = 4'b0101;
            `KEY_SPACE: last_key = 4'b0110;
            default: last_key = 4'b0000;
        endcase
    end

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            key_num <= 0;
            prev_key_num <= 0;
        end else begin
            prev_key_num <= key_num;
            if (key_valid) begin
                if(key_down[last_change]) begin
                    key_num <= last_key;
                end
                else
                    key_num <= 0;
            end
        end
    end





endmodule
