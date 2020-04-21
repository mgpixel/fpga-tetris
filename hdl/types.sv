package types;

typedef enum logic [2:0] {
  EMPTY,
  CYAN,
  BLUE,
  ORANGE,
  YELLOW,
  GREEN,
  RED,
  MAGENTA
} block_color;

typedef enum logic [2:0] {
  I_CYAN,
  J_BLUE,
  L_ORANGE,
  O_YELLOW,
  P_GREEN,
  T_MAGENTA,
  Z_RED
} block_t;

typedef enum logic [1:0] {
  LEFT,
  RIGHT,
  DOWN,
  ROTATE
} direction;

typedef enum logic [1:0] {
  ROT_LEFT,
  ROT_RIGHT,
  ROT2,
  NORMAL
} orientation;

endpackage