class_name Stats
extends Resource
## 状态基类，有最基本的状态，血量，护甲。
## 

@export var MAX_HEALTH: int = 1
@export var ART: Texture
var health:int: set = set_health
var MAX_BLOCK: int = 999
var block:int: set = set_block

## 状态改变时会发出
signal stats_changed

func set_health(v:int)->void:
	health = clampi(v, 0, MAX_HEALTH)
	stats_changed.emit()

func set_block(v:int)->void:
	block = clampi(v, 0, MAX_BLOCK)
	stats_changed.emit()

func take_damage(damage: int)->void:
	if damage <= 0:
		return
	
	var block_damage: int = damage
	damage = clampi(damage - block, 0, damage)
	block -= block_damage
	health -= damage

func heal(amount: int)->void:
	health += amount


func new_instance()->Stats:
	var instance: Stats = self.duplicate()
	instance.health = MAX_HEALTH
	instance.block = 0
	return instance
