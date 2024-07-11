class_name StatsUI
extends HBoxContainer
## 状态UI类
## 作为player或enemy类的附属节点，它们改变状态时发出信号调用update_stats
## 血量和护甲小于零时隐藏状态

@onready var block: HBoxContainer = $Block
@onready var block_label: Label = $Block/BlockLabel
@onready var health: HBoxContainer = $Health
@onready var health_label: Label = $Health/HealthLabel

func update_stats(stats: Stats)->void:
	block_label.text = str(stats.block)
	health_label.text = str(stats.health)
	
	block.visible = stats.block > 0
	health.visible = stats.health > 0
