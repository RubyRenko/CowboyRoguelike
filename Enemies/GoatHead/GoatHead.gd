class_name GoatHead extends Enemy_Base

@onready var blood = load("res://Enemies/GoatHead/goat_blood.tscn")
@onready var blood_timer = $Blood_Timer
@onready var flash_animation = $GoatSprite/FlashAnimation

func _init():
	base_spd = 280
	speed = 280
	hp = 6
	loot_table = ["beans", "jerky", "gator", "wampus", "flatwoods", "jackalope"]
	death_sounds = ["goat1", "goat2"]
	attack_sfx = "bite"
	damage = 2

func _ready():
	sounds = $GoatHeadSfx
	sprite_anim = $GoatSprite
	
	super._ready()

func _determine_movement(delta):
	if stun > 0:
		stun -= delta
		velocity = Vector2(0,0)
	elif chase != null:
		velocity = (chase.position - position).normalized() * speed
		if !sounds.playing:
			sounds.play_sfx("hover")
	elif !hurt and target != null:
		velocity = (target.position - position).normalized() * speed/3
		if !sounds.playing:
			sounds.play_sfx("hover")
	elif randi_range(0,30) == 0:
		var rand_direction =  Vector2(randi_range(-20,20), randi_range(-20,20))
		velocity = rand_direction * speed * delta
		if !sounds.playing:
				sounds.play_sfx("hover")

func spawn_blood():
	var b = blood.instantiate()
	b.position = Vector2(position.x, position.y+30)
	b.z_index = 0
	main.add_child(b)

func _on_timer_timeout():
	#print("Spawning blood")
	spawn_blood()
	blood_timer.start()
