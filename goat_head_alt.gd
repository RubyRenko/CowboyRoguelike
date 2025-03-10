extends CharacterBody2D

#stats
var base_spd = 200
var speed = 200
var hp = 15

var chase = null
var hurt = false
var next_hurt = 0
var hit_by_player = false

#status effects
var stun = 0
var slow = 0

@onready var main = get_tree().get_root().get_node("Main")
@onready var coin = load("res://coin.tscn")
@onready var blood = load("res://goat_blood.tscn")
@onready var blood_bullet = load("res://goat_blood_bullet.tscn")
@onready var blood_timer = $Blood_Timer
@onready var sprite_anim = $GoatSpriteAlt
@onready var hp_bar = $HpBar
@onready var bullet_spawn = $CenterPoint/GunPoint
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
	
func _physics_process(delta):
	#makes sure the hp display is up to date
	hp_bar.value = hp
	if slow > 0:
		speed = base_spd - 100
		slow -= delta
	else:
		speed = base_spd
	if stun > 0:
		stun -= delta
		velocity = Vector2(0,0)
	elif chase != null:
		#when chasing, minus the chased from the enemy's position to get the direction
		$CenterPoint.look_at(chase.position)
		velocity = (chase.position - position).normalized() * speed
	elif randi_range(0,30) == 0:
		#when not chasing, every few seconds, choose a random direction and move towards it
		#this will make the enemy wander naturally
		var rand_direction =  Vector2(randi_range(-20,20), randi_range(-20,20))
		velocity = rand_direction * speed * delta
	
	move_and_collide(velocity * delta)
	if velocity.x > 0:
		sprite_anim.flip_h = true
	else:
		sprite_anim.flip_h = false
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
	
	if hp <= 0:
		#if the enemy hp drops to zero, then it dies
		die()

func die():
	var main = get_tree().get_root().get_node("Main")
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

func spawn_blood():
	var b = blood.instantiate()
	b.position = Vector2(position.x, position.y+30)
	b.z_index = 0
	main.add_child(b)

func shoot_blood():
	var b = blood_bullet.instantiate()
	b.damage = 1
	b.global_position = bullet_spawn.global_position
	b.global_rotation = bullet_spawn.global_rotation - deg_to_rad(90)
	b.z_index = 0
	main.add_child(b)

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

func _on_timer_timeout():
	#print("Spawning blood")
	if chase != null:
		shoot_blood()
	#spawn_blood()
	blood_timer.start()
