extends Node2D

const SPEED = 750
var damage = 5
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#makes the bullt go straight in front
	var velocity = Vector2(0, SPEED).rotated(rotation)
	position += velocity * delta

func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		#if it hits the player or spawns inside the player
		#just skips
		pass
	elif body.is_in_group("enemy"):
		#if it hits an enemy, it deals damage to the enemy
		print("bullet hit")
		body.hp -= damage
		queue_free()
	else:
		#if it hits anything else, disappears
		queue_free()
