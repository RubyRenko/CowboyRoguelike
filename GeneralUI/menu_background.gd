extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().size
	
	var texture_size = texture.get_size()
	
	var scale_x = screen_size.x / texture_size.x
	var scale_y = screen_size.y / texture_size.y
	
	var scale_factor = min(scale_x, scale_y)
	
	scale = Vector2(scale_factor, scale_factor)
	
	position = screen_size / 2
	pass # Replace with function body.
