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

    parameter [8:0] KEY_W = 9'h1D;
    parameter [8:0] KEY_A = 9'h1C;
    parameter [8:0] KEY_S = 9'h1B;
    parameter [8:0] KEY_D = 9'h23;
    parameter [8:0] KEY_ENTER = 9'h5A;
    parameter [8:0] KEY_SPACE = 9'h29;

    reg [3:0] last_key;
    always @ (*) begin
        case(last_change)
            KEY_ENTER: last_key = 1;
            KEY_W: last_key = 2;
            KEY_A: last_key = 3;
            KEY_S: last_key = 4;
            KEY_D: last_key = 5;
            KEY_SPACE: last_key = 6;
            default: last_key = 0;
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
