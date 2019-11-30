extends Node2D
var game_scene_path = "res://Levels/Level1.tscn"

func _ready():
	pass 


func _input(event):
	if event.is_action_pressed('ui_focus_next') or event.is_action_pressed('ui_cancel'):
		globals.start_level(game_scene_path)