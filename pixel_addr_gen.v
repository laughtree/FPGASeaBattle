module pixel_addr_gen(
    input wire [9:0] h_cnt,
    input wire [9:0] v_cnt,
    input wire [3:0] part, 
    output reg [12:0] pixel_addr
    );

    integer position;

    always @* begin
        position = (h_cnt<80 || h_cnt >= 560) ?-1 :(h_cnt-80)/40 + v_cnt/40*12; 
    end

    always @* begin
        case (part)
            3'b001: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40);
            3'b010: pixel_addr = (39 - (h_cnt % 40)) + 40*(v_cnt % 40);
            3'b011: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40 + 40);
            3'b100: pixel_addr = h_cnt % 40 + 40*(39 - (v_cnt % 40) + 40);
            3'b101: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40 + 80);
            3'b110: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40 + 120);
            default: pixel_addr = 40 % 40 + 40*(44 % 40);
        endcase
    end
endmodule
