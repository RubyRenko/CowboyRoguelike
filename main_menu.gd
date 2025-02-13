extends Node2D

func _on_forest_button_pressed():
	get_tree().change_scene_to_file("res://forest_room.tscn")

func _on_desert_button_pressed():
	get_tree().change_scene_to_file("res://desert_room.tscn")
