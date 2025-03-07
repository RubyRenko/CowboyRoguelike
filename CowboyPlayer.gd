extends CharacterBody2D
class_name CowboyPlayer

@onready var main = get_tree().get_root().get_node("Main")
@onready var bullet_display = get_node("HUD/BulletDisplay")
@onready var hp_display = get_node("HUD/HpDisplay")
@onready var dash_available = $Dash_Available
@onready var dash_timer = $Dash_Timer
@onready var reload_timer = $Reload_Timer
@onready var coin = get_node("HUD/Money")
@onready var thunder = get_node("ThunderbirdArea")
@onready var thunder_timer = $Thunder_Timer

var bullet = load("res://bullet.tscn")
var bullet_n = load("res://bullet_nessie.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#stats
#static stats carry over when changing scenes
static var ranged_dmg = 5
static var melee_dmg = 5
static var speed = 300.0
static var max_ammo = 6
var ammo = max_ammo
static var max_hp = 8
static var hp = 8
static var money = 0
static var armor = 0
static var inventory = {"darkhat": 0, "cadejo": 0, "tractor": 0}

#all dash variables
var dash_speed = 600.0
var dashing = false
var can_dash = true
var can_reload = true
var thunder_start = true

#animation variables
var sprite_dir = ""

func _ready():
	bullet_display.update_bullets(ammo, max_ammo)
	hp_display.update_health(hp, max_hp, armor)
	$CenterPoint/Melee.damage = melee_dmg
	thunder.hide()

func _physics_process(delta):
	#takes care of player movement, gets direction from input keys
	#and looks at where the mouse position is
	var direction = Input.get_vector("left", "right", "up", "down")
	set_move_anim(direction)
	velocity = direction * speed
	$CenterPoint.look_at(get_global_mouse_position())
	move_and_collide(velocity * delta)
	
	
	if Input.is_action_just_pressed("shoot"):
		#shoots if there is still ammo
		if ammo > 0:
			shoot()
			ammo -= 1
			#print(ammo)
		else:
			#otherwise plays empty sfx
			$AudioPlayer.play_sfx("empty")
	
	#reloads and puts ammo back at 6
	if Input.is_action_just_pressed("reload") && can_reload:
		ammo = max_ammo;
		$AudioPlayer.play_sfx("reload")
		can_reload = false
		reload_timer.start()
	
	#handles melee animation and collision
	if Input.is_action_just_pressed("melee"):
		$CenterPoint/Melee.damage = melee_dmg
		$CenterPoint/Melee.slash()
	
	#handles dash
	if dashing:
		if sprite_dir == "front":
			$CowboyAnim.play("front_dash")
			$DashEffect.visible = true
			$DashEffect.gravity = Vector2(0, -980)
		elif sprite_dir == "back":
			$CowboyAnim.play("back_dash")
			$DashEffect.visible = true
			$DashEffect.gravity = Vector2(0, 980)
		elif sprite_dir == "left":
			$CowboyAnim.play("side_dash")
			$CowboyAnim.flip_h = true
			$DashEffect.visible = true
			$DashEffect.gravity = Vector2(980, 0)
		elif sprite_dir == "right":
			$CowboyAnim.play("side_dash")
			$CowboyAnim.flip_h = false
			$DashEffect.visible = true
			$DashEffect.gravity = Vector2(-980, 0)
		speed = dash_speed
		$CowboyAnim.speed_scale = 5
		set_collision_layer_value(3, true)
		set_collision_layer_value(1, false)
		#$CowboyCollision.set_collision_layer_value(3)
	else:
		speed = 300
		#$DashEffect.visible = false
		$DashEffect.gravity = Vector2(0, 0)
		$CowboyAnim.speed_scale = 2.5
		set_collision_layer_value(3, false)
		set_collision_layer_value(1, true)
		#$CowboyCollision.set_collision_layer_value(1)

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_available.start()
	
	#updates hud elements
	hp_display.update_health(hp, max_hp, armor)
	coin.set_text(str(money))
	bullet_display.update_bullets(ammo, max_ammo)

func shoot():
	#makes 1 bullet right in front
	var b
	if "nessie" in inventory:
		b = bullet_n.instantiate()
	else:
		b = bullet.instantiate()
	b.damage = ranged_dmg
	b.stun_chance = inventory["darkhat"]
	b.slow = inventory["tractor"]
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
	if armor > 0 and amount <= armor:
		armor -= amount
		if armor < 0:
			armor = 0
		$Camera2D.add_trauma(shake)
	elif armor > 0 and amount > armor:
		hp -= amount - armor
		armor -= amount
		if armor < 0:
			armor = 0
		$Camera2D.add_trauma(shake)
	else:
		hp -= amount
		$Camera2D.add_trauma(shake)

func set_move_anim(direction):
	if direction.y < 0:
		$CowboyAnim.play("back")
		sprite_dir = "back"
	elif direction.y > 0:
		$CowboyAnim.play("front")
		sprite_dir = "front"
	elif direction.x > 0:
		$CowboyAnim.play("side")
		$CowboyAnim.flip_h = false
		sprite_dir = "right"
	elif direction.x < 0:
		$CowboyAnim.play("side")
		$CowboyAnim.flip_h = true
		sprite_dir = "left"
	elif sprite_dir == "left":
		$CowboyAnim.play("side_idle")
		$CowboyAnim.flip_h = true
	elif sprite_dir == "right":
		$CowboyAnim.play("side_idle")
		$CowboyAnim.flip_h = false
	elif sprite_dir == "back":
		$CowboyAnim.play("back_idle")
		$CowboyAnim.flip_h = false
	else:
		$CowboyAnim.play("front_idle")
		$CowboyAnim.flip_h = false

func _on_dash_available_timeout():
	can_dash = true

func _on_dash_timer_timeout():
	dashing = false

func _on_thunder_timer_timeout():
	thunder.deal_dmg()

func _on_reload_timer_timeout():
	can_reload = true

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
