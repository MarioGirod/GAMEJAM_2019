extends KinematicBody2D
tool

export var character_scene = preload("res://CharacterScenes/NakedGuy.tscn")

signal item_touched(item)

func _on_Area2D_body_entered(body):
	if body == throw_exclude:
		return

	if body.has_method("change_character_with_item"):
		body.change_character_with_item(self, character_scene, CharacterType.DIVERS)

	emit_signal("item_touched", self)


var throw_from: Vector2
var throw_dir: Vector2
var throw_time = 0
var throw_base_speed = 48 * 4
var throw_speed = 0
var throw_exclude = null

# gets called from Character
func throw_it(exclude, from: Vector2, dir: Vector2):
	Tween.new()
	position = from
	throw_from = from
	throw_dir = dir
	throw_time = 0.33
	throw_exclude = exclude
	throw_speed = throw_base_speed

func _physics_process(delta):
	if throw_time > 0:
		throw_time -= delta
		move_and_slide(throw_dir * throw_speed)
	else:
		throw_time = 0
		throw_exclude = null