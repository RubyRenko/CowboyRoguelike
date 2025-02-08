extends CharacterBody2D

const SPEED = 280
var hp = 20
var chase = null
var hurt = false
var next_hurt = 0
@onready var main = get_tree().get_root().get_node("Main")
@onready var coin = load("res://pickup.tscn")
@onready var blood = load("res://goat_blood.tscn")
@onready var blood_timer = $Blood_Timer

func _physics_process(delta):
	#makes sure the hp display is up to date
	$HpDisplay.set_text("hp: " + str(hp))
	
	if chase != null:
		#when chasing, minus the chased from the enemy's position to get the direction
		velocity = (chase.position - position).normalized() * SPEED
	elif randi_range(0,30) == 0:
		#when not chasing, every few seconds, choose a random direction and move towards it
		#this will make the enemy wander naturally
		var rand_direction =  Vector2(randi_range(-20,20), randi_range(-20,20))
		velocity = rand_direction * SPEED * delta
	
	move_and_collide(velocity * delta)
	
	if hurt:
		#if the player is too close (in the hit area), then hurts the player
		next_hurt -= delta
		if next_hurt <= 0:
			#next hurt is a variable to make it so it's not constantly hurting
			#whenever the player is too close and kills it too quickly
			#print("hurt player")
			main.get_node("CowboyPlayer").hurt(1)
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
	queue_free()

func spawn_blood():
	var b = blood.instantiate()
	b.position = Vector2(position.x, position.y+30)
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
	spawn_blood()
	$Blood_Timer.start()
