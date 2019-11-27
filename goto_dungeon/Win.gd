extends Node2D
var start_scene_path = "res://Start.tscn"

func _ready():
	pass 


func _input(event):
	if event.is_action_pressed('ui_focus_next') or event.is_action_pressed('ui_cancel'):
		globals.switch_scene(start_scene_path)
