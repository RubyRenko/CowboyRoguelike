extends Area2D


var speed = 750
var damage : int
var stun_chance = 0
var slow = 0
@onready var sounds = $BulletSfx
@onready var sounds2 = $BulletDebuffSfx

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#makes the bullt go straight in front
	var velocity = Vector2(0, speed).rotated(rotation)
	position += velocity * delta

func _on_body_entered(body):
	var miss_sounds = ["miss","miss2"]
	
	if body.is_in_group("player"):
		#if it hits the player or spawns inside the player
		#just skips
		pass
	elif body.is_in_group("enemy"):
		#print("detected enemy")
		if body.flash_animation: 
			body.flash_animation.play("flash")
		deal_dmg(body)
		body.hit_by_player = true
		sounds.play_sfx("hit")
	elif body.is_in_group("boss"):
		if body.flash_animation: 
			body.flash_animation.play("flash")
		body.take_damage()
		sounds.play_sfx("hit")
	else:
		#if it hits anything else, disappears
		speed = 0
		visible = false;
		sounds.play_sfx(miss_sounds.pick_random())
		await sounds.finished
		queue_free()

func deal_dmg(body):
	body.hp -= damage
	if stun_chance > 0 && randi_range(0, 100) <= 5 * stun_chance:
		body.stun += 1
		sounds2.play_sfx("stunhit")
	if slow:
		body.slow += slow
		sounds2.play_sfx("slowhit")
