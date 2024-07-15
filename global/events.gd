## 全局加载 管理总事件

extends Node
## 状态转换
signal card_drag_started(card_ui: Card)
signal card_drag_ended(card_ui: Card)
signal card_aim_started(card_ui: Card)
signal card_aim_ended(card_ui: Card)
## 
signal card_played(card: Card)
## 显示和隐藏卡牌提示
signal card_tooltip_show(icon: Texture, text: String)
signal card_tooltip_hide
