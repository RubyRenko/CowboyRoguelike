class_name MothAlt extends Enemy_Base

func _init() -> void:
	#stats
	base_spd = 280
	speed = 280
	hp = 20
	loot_table = ["beans", "jerky", "gator", "wampus", "flatwoods", "jackalope"]
	death_sounds = ["moth1", "moth2"]
	attack_sfx = "attack"
	damage = 2
	slow_modifier = 2

func _ready():
	sounds = $MothkidSfx
	sprite_anim = $MothSpriteAlt
	
	super._ready()
	
func _determine_movement(delta):
	if stun > 0:
		stun -= delta*2
		velocity = Vector2(0,0)
	elif chase != null:
		velocity = (chase.position - position ).normalized()  * speed
		if randi_range(0, 10) == 0:
			velocity += Vector2(randi_range(-3,3), randi_range(-3, 3)) * speed
			if !sounds.playing:
				sounds.play_sfx("hover")
	elif randi_range(0,30) == 0:
		var rand_direction =  Vector2(randi_range(-20,20), randi_range(-20,20))
		velocity = rand_direction * speed * delta
