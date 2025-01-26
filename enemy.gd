extends CharacterBody2D

const SPEED = 120
var hp = 20
var chase = null
var hurt = false
var next_hurt = 0
@onready var main = get_tree().get_root().get_node("Main")

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
			print("hurt player")
			main.get_node("CowboyPlayer").hp -= 1
			next_hurt = 1;
			#making the next_hurt value higher makes it take more time
	
	if hp <= 0:
		#if the enemy hp drops to zero, then it dies
		queue_free()

"""
func chase_after(node):
	#the offset makes it jittery, comment out if you don't like
	#var x_offset = randi_range(0, 10)
	#var y_offset = randi_range(0, 10)
	position.x = move_toward(position.x, node.position.x, SPEED)
	position.y = move_toward(position.y, node.position.y, SPEED)
"""

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
		hurt = true

func _on_hit_area_body_exited(body):
	if body.name == "CowboyPlayer":
		hurt = false
