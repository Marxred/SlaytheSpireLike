class_name RunStartup
extends Resource

enum ENTER_GAME{NEW_RUN, CONTINUED_RUN}

@export var char_stat: CharacterStats
@export var type: ENTER_GAME
