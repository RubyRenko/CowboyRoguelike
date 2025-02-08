extends CharacterBody2D
class_name CowboyPlayer

@onready var main = get_tree().get_root().get_node("Main")
@onready var bullet_display = get_node("HUD/BulletHUD")
@onready var hp_display = get_node("HUD/HpDisplay")
@onready var dash_available = $Dash_Available
@onready var dash_timer = $Dash_Timer
@onready var coin = get_node("HUD/Money")

var bullet = load("res://bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#stats
static var ranged_dmg = 5
static var melee_dmg = 5
static var speed = 300.0
static var ammo = 6
static var hp = 8
static var money = 0

#all dash variables
var dash_speed = 600
var dashing = false
var can_dash = true

func _ready() :
	bullet_display.play("default")
	bullet_display.frame = 6
	hp_display.update_health(hp)
	$CenterPoint/Melee.damage = melee_dmg

func _physics_process(delta):
	#takes care of player movement, gets direction from input keys
	#and looks at where the mouse position is
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.y < 0:
		$CowboyAnim.play("back")
	elif direction.x > 0:
		$CowboyAnim.play("side")
		$CowboyAnim.flip_h = false
	elif direction.x < 0:
		$CowboyAnim.play("side")
		$CowboyAnim.flip_h = true
	else:
		$CowboyAnim.play("front")
		
	velocity = direction * speed
	$CenterPoint.look_at(get_global_mouse_position())
	move_and_collide(velocity * delta)
	
	#updates hud elements
	hp_display.update_health(hp)
	coin.set_text(str(money))
	
	if Input.is_action_just_pressed("shoot"):
		#shoots if there is still ammo
		if ammo > 0:
			shoot()
			ammo -= 1
			bullet_display.frame -= 1
			#print(ammo)
		else:
			#otherwise plays empty sfx
			$AudioPlayer.play_sfx("empty")
	
	#reloads and puts ammo back at 6
	if Input.is_action_just_pressed("reload"):
		ammo = 6;
		bullet_display.frame = 6
		$AudioPlayer.play_sfx("reload")
	
	#handles melee animation and collision
	if Input.is_action_just_pressed("melee"):
		$AnimationPlayer.play("melee")
	
	if $AnimationPlayer.is_playing():
		$CenterPoint/Melee.visible = true
		$CenterPoint/Melee.set_collision_mask_value(2, true)
	else:
		$CenterPoint/Melee.visible = false
		$CenterPoint/Melee.set_collision_mask_value(2, false)
	
	#handles dash
	if dashing:
		speed = dash_speed
		set_collision_layer_value(3, true)
		set_collision_layer_value(1, false)
		#$CowboyCollision.set_collision_layer_value(3)
	else:
		speed = 300
		set_collision_layer_value(3, false)
		set_collision_layer_value(1, true)
		#$CowboyCollision.set_collision_layer_value(1)

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_available.start()

func shoot():
	#makes 1 bullet right in front
	var b = bullet.instantiate()
	b.damage = ranged_dmg
	b.global_position = $CenterPoint/GunPoint.global_position
	b.global_rotation = $CenterPoint/GunPoint.global_rotation - deg_to_rad(90)
	main.add_child(b)
	$AudioPlayer.play_sfx("fire")

func set_hp(health):
	var heart = hp_display.get_node("Heart1")
	for i in range(health/2):
		var h = heart.instantiate()
		h.positon.x += 50 * (1+i)

func hurt(amount, shake = 0.2):
	hp -= amount
	$Camera2D.add_trauma(shake)

func _on_dash_available_timeout():
	can_dash = true

func _on_dash_timer_timeout():
	dashing = false

"""
old scatter shot code
var gun = 1
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
	
	func scatter_shot():
	#makes a scatter shot with 3 bullets in front
	var a = bullet.instantiate()
	var b = bullet.instantiate()
	var c = bullet.instantiate()
	a.damage = damage-3
	a.global_position = $Marker2D.global_position
	a.global_rotation = $Marker2D.global_rotation - deg_to_rad(90)
	main.add_child(a)
	b.damage = damage-3
	b.global_position = $Marker2D.global_position
	b.global_rotation = $Marker2D.global_rotation - deg_to_rad(75)
	main.add_child(b)
	c.damage = damage-3
	c.global_position = $Marker2D.global_position
	c.global_rotation = $Marker2D.global_rotation - deg_to_rad(105)
	main.add_child(c)
"""
