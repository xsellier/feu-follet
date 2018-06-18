extends Control

const MENU_SCENE = preload('res://scenes/menu.scn')

func _input(event):
  if event.is_action_pressed('ui_next'):
    get_tree().change_scene_to(MENU_SCENE)
