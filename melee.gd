extends Area2D
var damage = 5

func _on_body_entered(body):
	#print("Detected: " + body.name)
	if body.is_in_group("enemy"):
		print("Detected enemy")
		body.hp -= damage
