extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Lever_body_entered(body):
	$Sprite.frame = 1
	var root = get_parent()
	print(root)
	if root.has_method("lever_called"):
		print("calling lever")
		root.lever_called(self)


func _on_Lever_body_exited(body):
	$Sprite.frame = 0