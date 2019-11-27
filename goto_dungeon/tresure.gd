extends Area2D
var win_scene_path = "res://Win.tscn"
onready var globals = get_node("/root/globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in self.get_overlapping_bodies():
		if body.name == "Character":
			globals.switch_scene(win_scene_path)
			
