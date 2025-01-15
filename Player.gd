extends CharacterBody2D
var Bullet = load("res://bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		var b = Bullet.instantiate()
		add_child(b)
		b.transform = $Marker2D.global_transform
