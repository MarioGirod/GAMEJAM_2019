extends Area2D

export var throw_distance = 100
export var throw_steps = 20

onready var item_class = preload("res://Player/Classes/Warrior.tscn").instance()

var target_pos: Vector2
var throw_step: Vector2
var excluded_body: Node

func _ready():
	target_pos = position

func _on_Sword_body_entered(body):
	if body == excluded_body:
		return
	if body.has_method("changeClass"):
		body.changeClass(item_class)
		get_parent().remove_child(self)

func throw(_position, throw_dir, _excluded_body):
	target_pos = _position + (throw_dir*throw_distance)
	position = _position
	throw_step = (target_pos-position)/throw_steps
	excluded_body = _excluded_body

func _physics_process(delta):
	if throw_step.length() > 0:
		position = position + throw_step
		if (target_pos - position).length() < throw_step.length():
			throw_step = Vector2()
			position = target_pos
			excluded_body = null