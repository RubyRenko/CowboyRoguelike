extends CharacterBody2D

const SPEED = 3
var hp = 20
var chase = false
var chasePos := position
@onready var main = get_tree().get_root().get_node("Main")

func _physics_process(delta):
	if chase:
		#print("chasing")
		chase_after(main.get_node("CowboyPlayer"))
	
	if hp <= 0:
		queue_free()

func _on_sense_area_body_entered(body):
	if body.name == "CowboyPlayer":
		#print("player detected!")
		chase = true
		chasePos = body.position

func _on_sense_area_body_exited(body):
	if body.name == "CowboyPlayer":
		#print("player left, not chasing")
		chase = false

func chase_after(node):
	#the offset makes it jittery, comment out if you don't like
	var x_offset = randi_range(0, 10)
	var y_offset = randi_range(0, 10)
	position.x = move_toward(position.x, node.position.x+x_offset, SPEED)
	position.y = move_toward(position.y, node.position.y+y_offset, SPEED)
