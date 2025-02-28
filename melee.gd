extends Area2D
var damage = 10

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		deal_dmg(body)
	if body.is_in_group("enemy"):
		body.hp -= damage

func deal_dmg(body):
	body.hp -= damage
	if randi_range(0, 100) <= 5 * owner.inventory["darkhat"]:
		body.stun += 1
	body.slow += owner.inventory["cadejo"]
