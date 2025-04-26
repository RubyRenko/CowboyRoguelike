extends CharacterBody2D

#stats
var base_spd = 280
var speed = 280
var hp = 20

var chase = null
var hurt = false
var next_hurt = 0
var hit_by_player = false

#status effects
var stun = 0
var slow = 0

@onready var main = get_tree().get_root().get_node("Main")
@onready var coin = load("res://Items/DroppablePickup.tscn")
@onready var blood = load("res://Enemies/GoatHead/goat_blood.tscn")
@onready var death_sprite = load("res://Enemies/enemy_death_splat.tscn")
@onready var sprite_anim = $MothSpriteAlt
@onready var hp_bar = $HpBar
@onready var sounds = $MothkidSfx
@onready var loot_table = ["beans", "jerky", "gator", "wampus", "flatwoods", "jackalope"]

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
	elif chase != null:
		#when chasing, minus the chased from the enemy's position to get the direction
		velocity = (chase.position - position ).normalized()  * speed
		if randi_range(0, 10) == 0:
			velocity += Vector2(randi_range(-3,3), randi_range(-3, 3)) * speed
			if !sounds.playing:
				sounds.play_sfx("hover")
	elif randi_range(0,30) == 0:
		#when not chasing, every few seconds, choose a random direction and move towards it
		#this will make the enemy wander naturally
		var rand_direction =  Vector2(randi_range(-20,20), randi_range(-20,20))
		velocity = rand_direction * speed * delta
	
	move_and_collide(velocity * delta)
	if velocity.x > 0:
		sprite_anim.flip_h = false
	else:
		sprite_anim.flip_h = true
	if hurt:
		#if the player is too close (in the hit area), then hurts the player
		next_hurt -= delta
		if next_hurt <= 0:
			#next hurt is a variable to make it so it's not constantly hurting
			#whenever the player is too close and kills it too quickly
			#print("hurt player")
			main.get_node("CowboyPlayer").hurt(2)
			#main.get_node("CowboyPlayer").hp -= 1
			next_hurt = 1.5
			#making the next_hurt value higher makes it take more time
			sounds.play_sfx("attack")
	
	if hp <= 0:
		#if the enemy hp drops to zero, then it dies
		die()

func die():
	var main = get_tree().get_root().get_node("Main")
	
	var d = death_sprite.instantiate()
	d.sound = ["moth1", "moth2"].pick_random()
	d.position = Vector2(position.x, position.y+30)
	main.add_child(d)
	
	for i in range(randi_range(1,5)):
		var c = coin.instantiate()
		c.create_pickup("coin")
		c.position = position + Vector2(randi_range(10,30), randi_range(10,30))
		main.add_child(c)
	
	if randi_range(0,5) == 0:
		var p = loot_table.pick_random()
		EnemyLoot.CreateLoot(p, self)
		
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
