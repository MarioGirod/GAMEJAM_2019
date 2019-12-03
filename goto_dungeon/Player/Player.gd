extends KinematicBody2D

export var player = "p3"
export (int) var walk_speed = 100
var move_dir = Vector2()
var view_dir = Vector2()
var velocity: Vector2


func get_input():
	move_dir = Vector2()
	if Input.is_action_pressed(player+'_right'):
		move_dir.x += 1
	if Input.is_action_pressed(player+'_left'):
		move_dir.x -= 1
	if Input.is_action_pressed(player+'_down'):
		move_dir.y += 1
	if Input.is_action_pressed(player+'_up'):
		move_dir.y -= 1
	move_dir = move_dir.normalized()
	if move_dir.length() > 0:
		view_dir = move_dir


func drop_class():
	if $Class.classname == "NakedGuy":
		return
	else:
		var item = $Class.drop_item()
		get_parent().add_child(item)
		item.throw(position, view_dir, self)
		var naked_guy_scene = preload("res://Player/Classes/NakedGuy.tscn").instance()
		remove_child($Class)
		naked_guy_scene.name = "Class"
		add_child(naked_guy_scene)


func attack():
	$Class.attack()


func changeClass(item_class):
	if $Class.classname == "NakedGuy":
		remove_child($Class)
		item_class.name = "Class"
		add_child(item_class)


func _physics_process(delta):
	if Input.is_action_just_pressed(player+"_drop"):
		drop_class()
	
	if Input.is_action_just_pressed(player+"_attack"):
		attack()
	
	get_input()
	velocity = move_and_slide(move_dir*walk_speed)
	$Class.movement_animation(move_dir)
