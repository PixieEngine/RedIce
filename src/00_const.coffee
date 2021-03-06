window.DEMO_MODE ?= true

WALL_BUFFER_HORIZONTAL = 12

WALL_LEFT = WALL_BUFFER_HORIZONTAL
WALL_RIGHT = 2 * App.width - WALL_LEFT
WALL_TOP = 192
WALL_BOTTOM = App.height - 32

ARENA_WIDTH = WALL_RIGHT - WALL_LEFT
ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP

ARENA_CENTER = Point(
  WALL_RIGHT + WALL_LEFT,
  WALL_TOP + WALL_BOTTOM
).scale(0.5)

BLOOD_COLOR = "#BA1A19"
ICE_COLOR = "rgba(192, 255, 255, 0.2)"

MAX_PLAYERS = 4

TEAMS = ["smiley", "spike", "hiss", "mutant", "monster", "robo"]

ALL_MUSIC = [
  "Smiley Smile"
  "Spiked Punch"
  "Snake Or Die"
  "Carpe Mutante"
  "Monsters Don't Get Cold"
  "Pure Robot Love Connection"
]

TEAM_MUSIC =
  smiley: ["Smiley Smile"]
  spike: ["Spiked Punch"]
  hiss: ["Snake Or Die"]
  mutant: ["Carpe Mutante"]
  monster: ["Monsters Don't Get Cold"]
  robo: ["Pure Robot Love Connection"]

PERSPECTIVE_RATIO = 4/3

PERSISTENT_CONFIG = "config"
