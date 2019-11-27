extends Node2D
var game_scene_path = "res://Game.tscn"

func _ready():
	pass 


func _input(event):
	if event.is_action_pressed('ui_focus_next') or event.is_action_pressed('ui_cancel'):
		globals.switch_scene(game_scene_path)