extends NakedGuy

func _ready():
	classname = "Warrior"

func attack():
	$AnimationPlayer.play("Attack")
	return true
	
func drop_item():
	var sword = load("res://Player/Items/Sword.tscn").instance()
	return sword