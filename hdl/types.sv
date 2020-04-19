package types;

typedef enum logic [3:0] {
  EMPTY,
  CYAN,
  BLUE,
  ORANGE,
  YELLOW,
  GREEN,
  RED,
  MAGENTA
} block_color;

typedef enum logic [3:0] {
  I_CYAN,
  J_BLUE,
  L_ORANGE,
  O_YELLOW,
  P_GREEN,
  T_MAGENTA,
  Z_RED
} block_t;

endpackage