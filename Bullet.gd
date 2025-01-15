extends Area2D

const SPEED = 750
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2(0, SPEED).rotated(rotation)
	position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		pass
	else:
		queue_free()
