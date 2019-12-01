extends Node2D

onready var blocker0 = get_node("Blocker0")
onready var blocker1 = get_node("Blocker1")
onready var blocker2 = get_node("Blocker2")

var levers_called = []
var orcs_ded = 0

func orc_ded():
	print("orcded")
	orcs_ded += 1
	if orcs_ded >= 3:
		self.remove_child(blocker0)
		self.remove_child(blocker1)
		self.remove_child(blocker2)
		
func lever_called(lever):
	levers_called.append(lever)
	if levers_called.size() == 3:
		var root = get_parent()
		if root.has_method("room_complete"):
			root.room_complete(self)

func lever_left(lever):
	levers_called.erase(lever)

