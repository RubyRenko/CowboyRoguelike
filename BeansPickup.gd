extends Area2D

func _on_body_entered(body):
	if body.name == "CowboyPlayer":
		body.hp += 2
		if body.hp > body.max_hp:
			body.hp = body.max_hp
		queue_free()
