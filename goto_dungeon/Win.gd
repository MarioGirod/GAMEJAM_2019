extends Node2D
var start_scene_path = "res://Start.tscn"
var font = preload("res://assets/RobotoBold120.tres")


func _draw():
	font.size = 50
	draw_string(font, Vector2(270,520), "Dungon Quest solved", Color(1,1,1)) 


func _input(event):
	if event.is_action_pressed('ui_accept'):
		globals.switch_scene(start_scene_path)
