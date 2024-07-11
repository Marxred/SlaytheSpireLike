extends CardState
## 释放卡牌状态
var played: bool

## 如果目标数组为空回到手牌
## 不为空则在场上释放
func enter()->void:
	super()
	
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "RELEASED"
	
	played = false
	
	if not card_ui.targets.is_empty():
		played = true
		print("play card for targer(s) ", card_ui.targets)


func on_input(event:InputEvent)->void:
	super(event)
	
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
