class_name Larva extends Enemy_Base

var rand_direction : Vector2

func _init() -> void:
	#stats
	base_spd = 300
	speed = 300
	hp = 40
	loot_table = ["beans", "jerky", "gator", "wampus", "flatwoods", "jackalope"]
	death_sounds = ["larva1", "larva2"]
	attack_sfx = "attack"
	damage = 3
	slow_modifier = 2
	default_dir_left = false;

func _ready():
	sounds = $LarvaSfx
	sprite_anim = $LarvaSprite
	
	super._ready()

func _determine_movement(delta):
	if stun > 0:
		stun -= delta*2
		velocity = Vector2(0,0)
	elif sprite_anim.frame < 3 || sprite_anim.frame == 7:
		velocity = Vector2(0,0)
		rand_direction = Vector2(randf_range(-1, 1), randf_range(-1,1)) * 50
		if !sounds.playing:
			sounds.play_sfx("slither")
	elif chase != null && sprite_anim.frame > 3 && sprite_anim.frame < 7:
		velocity = (chase.position - position).normalized() * speed
		if !sounds.playing:
			sounds.play_sfx("slither")
	elif !hurt and target != null && sprite_anim.frame > 3 && sprite_anim.frame < 7:
		velocity = (target.position - position).normalized() * speed/3
		if !sounds.playing:
			sounds.play_sfx("slither")
	elif sprite_anim.frame > 3:
		velocity = rand_direction * speed * delta

func _after_movement_checks(delta):
	if velocity.x > 0:
		sprite_anim.flip_h = false
	elif velocity.x < 0:
		sprite_anim.flip_h = true
	if hurt:
		next_hurt -= delta
		if next_hurt <= 0 && velocity != Vector2(0, 0):
			main.get_node("CowboyPlayer").hurt(3)
			next_hurt = 1
			sounds.play_sfx(attack_sfx)
	if hp <= 0:
		die()
