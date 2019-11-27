extends KinematicBody2D

export var id = 0
var speed = 200
var direction = "down"

func _ready():
	$Animation.play("down")


func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1, 0.1)


func _process(delta):
	var move = Vector2(0,0)
	
	var diagonal_speed = round(speed / 1.414)
	
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		move.x = 1 * diagonal_speed
		move.y = -1 * diagonal_speed
		$Animation.play("move_right")
		direction = "right"
	
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		move.x = -1 * diagonal_speed
		move.y = -1 * diagonal_speed
		$Animation.play("move_left")
		direction = "left"
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		move.x = 1 * diagonal_speed
		move.y = 1 * diagonal_speed
		$Animation.play("move_right")
		direction = "right"
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		move.x = -1 * diagonal_speed
		move.y = 1 * diagonal_speed
		$Animation.play("move_left")
		direction = "left"
		
	elif Input.is_action_pressed("ui_right"):
		move.x = 1 * speed
		$Animation.play("move_right")
		direction = "right"
		
	elif Input.is_action_pressed("ui_left"):
		move.x = -1 * speed
		$Animation.play("move_left")
		direction = "left"
		
	elif Input.is_action_pressed("ui_down"):
		move.y = 1 * speed
		$Animation.play("move_down")
		direction = "down"
	
	elif Input.is_action_pressed("ui_up"):
		move.y = -1 * speed
		$Animation.play("move_up")
		direction = "up"
		
	if not move:
		$Animation.play(direction)
	
	move_and_slide(move)
