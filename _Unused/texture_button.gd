extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_rect().has_point(event.position):
				_button_pressed()
			
func _button_pressed():
	get_tree().change_scene_to_file("res://desert_room.tscn")
