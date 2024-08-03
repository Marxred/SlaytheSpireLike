## 全局加载 管理所有事件，统一处理事件，所有场景均可使用

extends Node
## 状态转换
signal card_drag_started(card_ui: Card)
signal card_drag_ended(card_ui: Card)
signal card_aim_started(card_ui: Card)
signal card_aim_ended(card_ui: Card)
##
signal card_played(card: Card)
## 战斗时显示和隐藏卡牌提示
signal card_tooltip_show(icon: Texture, text: String)
signal card_tooltip_hide
##
signal card_hand_drawn
signal player_hand_discarded
signal player_turn_ended
##
signal player_hited
signal player_died
##
signal enemy_action_completed(enemy:Enemy)
signal enemy_trun_ended
##
signal battle_over_requested(text: String, type:BattleOverPanel.TYPE)
signal battle_won
##
signal map_exited
signal shop_exited
signal campfire_exited
signal battle_reward_exited
signal treasure_room_exited
##
signal card_pile_preview_requested(cardpile:CardPile)
