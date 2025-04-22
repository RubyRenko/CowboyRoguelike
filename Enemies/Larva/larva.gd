extends CharacterBody2D

#stats
var base_spd = 300
var speed = 300
var hp = 40

var chase = null
var rand_direction : Vector2
var hurt = false
var next_hurt = 0
var hit_by_player = false

#status effects
var stun = 0
var slow = 0

@onready var main = get_tree().get_root().get_node("Main")
@onready var coin = load("res://coin.tscn")
@onready var blood = load("res://goat_blood.tscn")
@onready var death_sprite = load("res://enemy_death_splat.tscn")
@onready var sprite_anim = $LarvaSprite
@onready var hp_bar = $HpBar
@onready var sounds = $LarvaSfx
@onready var loot_table = [load("res://Items/beans_pickup.tscn"), 
						load("res://Items/jerky_pickup.tscn"), 
						load("res://Items/gator_pickup.tscn"),
						load("res://Items/wampus_pickup.tscn"),
						load("res://Items/flatwoods_pickup.tscn"),
						load("res://Items/jackalop_pickup.tscn")
						]
func _ready():
	sprite_anim.play()
	hp_bar.max_value = hp
	sounds.play_sfx(["spawn1", "spawn2"].pick_random())

func _physics_process(delta):
	#makes sure the hp display is up to date
	hp_bar.value = hp
	if slow > 0:
		speed = base_spd - 100
		slow -= delta*2
	else:
		speed = base_spd
	if stun > 0:
		stun -= delta*2
		velocity = Vector2(0,0)
	elif sprite_anim.frame < 3 || sprite_anim.frame == 7:
		velocity = Vector2(0,0)
		rand_direction = Vector2(randf_range(-1, 1), randf_range(-1,1)) * 50
		if !sounds.playing:
			sounds.play_sfx("slither")
	elif chase != null && sprite_anim.frame > 3 && sprite_anim.frame < 7:
		#when chasing, minus the chased from the enemy's position to get the direction
		velocity = (chase.position - position ).normalized() * speed
		if !sounds.playing:
			sounds.play_sfx("slither")
	elif sprite_anim.frame > 3:
		velocity = rand_direction * speed * delta
	
	move_and_collide(velocity * delta)
	if velocity.x > 0:
		sprite_anim.flip_h = false
	elif velocity.x < 0:
		sprite_anim.flip_h = true
	if hurt:
		#if the player is too close (in the hit area), then hurts the player
		next_hurt -= delta
		if next_hurt <= 0 && velocity != Vector2(0, 0):
			#next hurt is a variable to make it so it's not constantly hurting
			#whenever the player is too close and kills it too quickly
			#print("hurt player")
			main.get_node("CowboyPlayer").hurt(3)
			#main.get_node("CowboyPlayer").hp -= 1
			next_hurt = 1
			#making the next_hurt value higher makes it take more time
			sounds.play_sfx("attack")
	
	if hp <= 0:
		#if the enemy hp drops to zero, then it dies
		die()

func die():
	var main = get_tree().get_root().get_node("Main")
	
	var d = death_sprite.instantiate()
	d.sound = ["larva1", "larva2"].pick_random()
	d.position = Vector2(position.x, position.y+30)
	main.add_child(d)
	
	for i in range(randi_range(1,5)):
		var c = coin.instantiate()
		c.position = position + Vector2(randi_range(10,30), randi_range(10,30))
		main.add_child(c)
		
	if randi_range(0,5) == 0:
		var p = loot_table.pick_random().instantiate()
		if p.is_in_group("sellable"):
			p.sold = true
		p.position = position
		main.add_child(p)
	queue_free()

func _on_sense_area_body_entered(body):
	if body.name == "CowboyPlayer":
		#print("player detected!")
		chase = body

func _on_sense_area_body_exited(body):
	if body.name == "CowboyPlayer":
		#print("player left, not chasing")
		chase = null

func _on_hit_area_body_entered(body):
	if body.name == "CowboyPlayer":
		chase = null
		hurt = true

func _on_hit_area_body_exited(body):
	if body.name == "CowboyPlayer":
		chase = body
		hurt = false
