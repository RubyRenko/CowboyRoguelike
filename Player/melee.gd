extends Area2D
var damage = 4
@onready var sounds = $MeleeDebuffSFX
@onready var cam = $"../../Camera2D"

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		deal_dmg(body)
	if body.is_in_group("enemy"):
		body.hp -= damage

func slash():
	$AnimatedSprite2D.play("default")
	visible = true
	set_collision_mask_value(2, true)

func deal_dmg(body, shake = 0.2):
	body.hp -= damage
	if randi_range(0, 100) <= 5 * owner.inventory["darkhat"]:
		body.stun += 1
		sounds.play_sfx("stunhit")
	body.slow += owner.inventory["cadejo"]
	if body.slow >= 1:
		sounds.play_sfx("slowhit")
	$MeleeHitSFX.play()
	cam.add_trauma(shake)


func _on_animated_sprite_2d_animation_finished():
	visible = false
	set_collision_mask_value(2, false)
