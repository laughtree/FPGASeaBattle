module pixel_addr_gen(
    input wire [9:0] h_cnt,
    input wire [9:0] v_cnt,
    input wire [3:0] part,
    output reg pixel_addr
    );

    always @* begin
        case (part)
            1: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40);
            2: pixel_addr = (39 - h_cnt % 40) + 40*(v_cnt % 40);
            3: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40 + 40);
            4: pixel_addr = (h_cnt % 40) + 40*((39 - v_cnt % 40) + 40);
            5: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40 + 80);
            6: pixel_addr = h_cnt % 40 + 40*(v_cnt % 40 + 120);
            default: pixel_addr = 0;
        endcase
    end
endmodule
