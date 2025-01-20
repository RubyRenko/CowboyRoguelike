extends CharacterBody2D

const SPEED = 3
var hp = 20
var chase = false
var hurt = false
var chasePos := position
var next_hurt = 0
@onready var main = get_tree().get_root().get_node("Main")

func _physics_process(delta):
	$HpDisplay.set_text("hp: " + str(hp))
	if chase:
		#print("chasing")
		chase_after(main.get_node("CowboyPlayer"))
	if hurt:
		next_hurt -= delta
		if next_hurt <= 0:
			print("hurt player")
			main.get_node("CowboyPlayer").hp -= 1
			next_hurt = 1;
	
	if hp <= 0:
		queue_free()


func chase_after(node):
	#the offset makes it jittery, comment out if you don't like
	#var x_offset = randi_range(0, 10)
	#var y_offset = randi_range(0, 10)
	position.x = move_toward(position.x, node.position.x, SPEED)
	position.y = move_toward(position.y, node.position.y, SPEED)

func _on_sense_area_body_entered(body):
	if body.name == "CowboyPlayer":
		#print("player detected!")
		chase = true
		chasePos = body.position

func _on_sense_area_body_exited(body):
	if body.name == "CowboyPlayer":
		#print("player left, not chasing")
		chase = false

func _on_hit_area_body_entered(body):
	if body.name == "CowboyPlayer":
		hurt = true
		

func _on_hit_area_body_exited(body):
	if body.name == "CowboyPlayer":
		hurt = false
