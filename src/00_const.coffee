ZAMBONI_SCALE = 0.375

WALL_LEFT = 0
WALL_RIGHT = App.width - WALL_LEFT
WALL_TOP = 192
WALL_BOTTOM = App.height - (WALL_TOP - 128)

ARENA_WIDTH = WALL_RIGHT - WALL_LEFT
ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP

BLOOD_COLOR = "#BA1A19"
ICE_COLOR = "rgba(192, 255, 255, 0.2)"

MAX_PLAYERS = 4

TEAMS = ["smiley", "spike", "hiss", "mutant", "monster", "robo"]

ALL_MUSIC = [
  "Spiked Punch"
  "Snake Or Die"
  "Monsters Don't Get Cold"
  "Pure Robot Love Connection"
]

TEAM_MUSIC =
  smiley: ALL_MUSIC
  spike: ALL_MUSIC
  hiss: ALL_MUSIC
  mutant: ALL_MUSIC
  monster: ALL_MUSIC
  robo: ALL_MUSIC
