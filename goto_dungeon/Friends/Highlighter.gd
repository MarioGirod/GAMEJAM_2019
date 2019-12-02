extends Sprite

onready var player = get_parent().player

func get_color():
	var color = Color(0, 1, 0, 1); # lime default
	if (player == 'p1'):
		color = Color(1, 1, 0, 1); # yellow
	elif (player == 'p2'):
		color = Color( 0, 1, 1, 1 ); # aqua
	elif (player == 'p3'):
		color = Color( 1, 0, 0, 1 ); # red
	return color;
	
func _ready():
	var color = get_color();
	modulate = color;