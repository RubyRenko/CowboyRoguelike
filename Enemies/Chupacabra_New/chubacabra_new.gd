extends CharacterBody2D

@onready var player: CowboyPlayer = $"../CowboyPlayer"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $Boss_UI/ProgressBar
@onready var state_machine = $FiniteStateMachine
@onready var main: Node2D = $"."

var direction : Vector2
var target : Vector2
var speed = 250
var DEF = 0
var next_hurt = 0

var health = 300:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
func _ready():
	set_physics_process(false)
 
func _process(delta):
	if state_machine.current_state.name == "Follow":
		direction = player.position - position
	elif state_machine.current_state.name == "Dash":
		direction = target - position
	
	if health <= 0:
		queue_free()
	#direction = player.position - position
	if direction.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
 
func _physics_process(delta):
	velocity = direction.normalized() * speed
	move_and_collide(velocity * delta)
 
func take_damage():
	health -= 10 - DEF
