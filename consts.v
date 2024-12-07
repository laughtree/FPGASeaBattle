`ifndef CONSTS_V
`define CONSTS_V

// states
`define INIT 3'b000
`define PLAYERA_SET 3'b001
`define PLAYERB_SET 3'b010
`define PLAYERA_ATTACK 3'b011
`define PLAYERB_ATTACK 3'b100
`define FIN 3'b101

// key
`define KEY_W 9'h01D
`define KEY_A 9'h01C
`define KEY_S 9'h01B
`define KEY_D 9'h023
`define KEY_ENTER 9'h05A
`define KEY_SPACE 9'h029

// key_num
`define ENTER 4'b0001
`define W 4'b0010
`define A 4'b0011
`define S 4'b0100
`define D 4'b0101
`define SPACE 4'b0110

`endif 