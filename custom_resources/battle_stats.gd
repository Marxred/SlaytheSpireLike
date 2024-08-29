class_name BattleStats
extends Resource

@export_range(0, 3) var battle_tier:int=0
@export var gold_reward_min:int=0
@export var gold_reward_max:int=0

@export_range(0.0, 10.0) var weight:float=0
@export var Enemies:PackedScene
