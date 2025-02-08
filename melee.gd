extends Area2D
var damage = 10

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.hp -= 10
