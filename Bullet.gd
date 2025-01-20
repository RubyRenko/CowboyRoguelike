extends Node2D

const SPEED = 750
var damage = 5
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2(0, SPEED).rotated(rotation)
	position += velocity * delta

func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		pass
	elif body.is_in_group("enemy"):
		print("bullet hit")
		body.hp -= damage
		queue_free()
	else:
		queue_free()
