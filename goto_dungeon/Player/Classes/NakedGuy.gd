extends Node2D

class_name NakedGuy

export var classname = "NakedGuy"

func movement_animation(velocity: Vector2):
	if velocity.length() > 0:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")
	if velocity.x > 0:
		$Sprite.flip_h = false
	if velocity.x < 0:
		$Sprite.flip_h = true

func attack():
	return false
	
func drop_item():
	return false