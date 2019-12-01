extends Node2D

var levers_called = []

func lever_called(lever):
	levers_called.append(lever)
	print(levers_called.size())
	if levers_called.size() == 3:
		var root = get_parent()
		if root.has_method("room_complete"):
			root.room_complete(self)

func lever_left(lever):
	levers_called.erase(lever)
	print(levers_called.size())