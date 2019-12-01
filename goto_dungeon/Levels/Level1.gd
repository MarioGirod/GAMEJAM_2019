extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var room1 = get_node("Room1")
onready var room2 = get_node("Room2")
onready var room3 = get_node("Room3")

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.current_level_path = "res://Levels/Level1.tscn"

func room_complete(room):
	print("room "+room.name+" complete")
	var camera_follower = get_node("CameraFollower")
	
	if room == room1:
		camera_follower.set_position(room2.get_position())
	if room == room2:
		camera_follower.set_position(room3.get_position())
		#room1.remove_child(camera)
		#room2.add_child(camera)


func orc_ded():
	pass # Replace with function body.
