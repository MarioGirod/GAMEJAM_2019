extends Node2D

var font = preload("res://assets/RobotoBold120.tres")


func _draw():
	font.size = 50
	draw_string(font, Vector2(260,520), "Rest in peaces my friend", Color(1,1,1)) 

func _ready():
	globals.restart_level(3)