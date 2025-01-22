extends CharacterBody2D
class_name CowboyPlayer

@onready var main = get_tree().get_root().get_node("Main")
var bullet = load("res://bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var ammo = 6
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gun = 1
var hp = 20

func _physics_process(delta):
	#takes care of player movement, gets direction from input keys
	#and looks at where the mouse position is
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()
	
	#handles shooting with the different guns
	if gun == 1 and Input.is_action_just_pressed("shoot"):
		if ammo > 0:
			shoot()
			ammo -= 1
			print(ammo)
	
	if gun == 2 and Input.is_action_just_pressed("shoot"):
		if ammo > 0:
			scatter_shot()
			ammo -= 2
			print(ammo)
	
	#changes gun back and forth from revolver to shotgun
	if Input.is_action_just_pressed("gun_change"):
		gun += 1
		if gun > 2:
			gun = 1
	
	#reloads and puts ammo back at 6
	if Input.is_action_just_pressed("reload"):
		ammo = 6;

func shoot():
	#makes 1 bullet right in front
	var b = bullet.instantiate()
	b.damage = 5
	b.global_position = $Marker2D.global_position
	b.global_rotation = $Marker2D.global_rotation - deg_to_rad(90)
	main.add_child(b)

func scatter_shot():
	#makes a scatter shot with 3 bullets in front
	var a = bullet.instantiate()
	var b = bullet.instantiate()
	var c = bullet.instantiate()
	a.damage = 2
	a.global_position = $Marker2D.global_position
	a.global_rotation = $Marker2D.global_rotation - deg_to_rad(90)
	main.add_child(a)
	b.damage = 3
	b.global_position = $Marker2D.global_position
	b.global_rotation = $Marker2D.global_rotation - deg_to_rad(75)
	main.add_child(b)
	c.damage = 3
	c.global_position = $Marker2D.global_position
	c.global_rotation = $Marker2D.global_rotation - deg_to_rad(105)
	main.add_child(c)
