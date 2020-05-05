package types;

typedef enum logic [2:0] {
  EMPTY,
  CYAN,
  BLUE,
  ORANGE,
  YELLOW,
  GREEN,
  MAGENTA,
  RED
} block_color;

typedef enum logic [1:0] {
  ROT_LEFT,
  ROT_RIGHT,
  ROT2,
  NORMAL
} orientation;

endpackage