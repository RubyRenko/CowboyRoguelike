extends Area2D

var speed = 600
var damage : int

# Called when the node enters the scene tree for the first time.
func _process(delta):
	#makes the bullt go straight in front
	var velocity = Vector2(0, speed).rotated(rotation)
	position += velocity * delta
	await get_tree().create_timer(5).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.hurt(damage)
		queue_free()
	else:
		#if it hits anything else, disappears
		queue_free()
