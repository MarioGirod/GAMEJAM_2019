extends Node2D
var level_1_path = "res://Levels/Level1.tscn"
var level_8_path = "res://Friends/CharacterTest.tscn"
var level_9_path = "res://Friends/Enemy_Orc_Test.tscn"

var font = preload("res://assets/RobotoBold120.tres")


func _draw():
	font.size = 36
	draw_string(font, Vector2(40,550), "Welcome to the dungeon! Press a number to select a level.", Color(1,1,1)) 


func _input(event):
	if event.is_action_pressed('select_level_1') or event.is_action_pressed('ui_cancel'):
		globals.start_level(level_1_path)
	
	# Test level
	if event.is_action_pressed('select_level_8') or event.is_action_pressed('ui_cancel'):
		globals.start_level(level_8_path)
	if event.is_action_pressed('select_level_9') or event.is_action_pressed('ui_cancel'):
		globals.start_level(level_9_path)