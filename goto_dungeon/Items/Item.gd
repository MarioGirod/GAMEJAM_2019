extends Node2D
tool

export var character_scene = preload("res://CharacterScenes/NakedGuy.tscn")

signal item_touched(item)

func _on_Area2D_body_entered(body):
	if body.has_method("change_character_with_item"):
		body.change_character_with_item(self, character_scene, CharacterType.DIVERS)

	emit_signal("item_touched", self)
