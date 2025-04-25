extends Area2D
var damage = 10

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		deal_dmg(body)
	if body.is_in_group("enemy"):
		body.hp -= damage

func slash():
	$AnimatedSprite2D.play("default")
	visible = true
	set_collision_mask_value(2, true)

func deal_dmg(body):
	body.hp -= damage
	if randi_range(0, 100) <= 5 * owner.inventory["darkhat"]:
		body.stun += 1
	body.slow += owner.inventory["cadejo"]
	$AudioStreamPlayer2D.play()


func _on_animated_sprite_2d_animation_finished():
	visible = false
	set_collision_mask_value(2, false)
