extends Area2D

func _on_body_entered(body):
	#print("body detected")
	if body.name == "CowboyPlayer":
		#print("add 1 heart")
		body.max_hp += 2
		body.hp += 2
		#print(body.hp)
		queue_free()
