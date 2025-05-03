class_name Enemy_Base extends CharacterBody2D

#stats
var base_spd
var speed
var hp
var damage

#status effects
var stun = 0
var slow = 0

var target = null
var chase = null
var hurt : bool = false
var next_hurt = 0
var hit_by_player : bool = false

var sounds
var sprite_anim
var death_sounds : Array[String]
var loot_table : Array[String]
var attack_sfx

@onready var main = get_tree().get_root().get_node("Main")
@onready var death_sprite = load("res://Enemies/enemy_death_splat.tscn")
@onready var coin = load("res://Items/DroppablePickup.tscn")
@onready var hp_bar = $HpBar

func _ready() -> void:
	sprite_anim.play()
	hp_bar.max_value = hp
	var spawn_sounds = ["spawn1", "spawn2"]
	sounds.play_sfx(spawn_sounds.pick_random())
	target = main.get_node("%CowboyPlayer")

var slow_modifier = 1
func status_checks(delta):
	#makes sure the hp display is up to date
	hp_bar.value = hp
	if slow > 0:
		speed = base_spd - 100
		slow -= delta * slow_modifier
	else:
		speed = base_spd
		
func _after_movement_checks(delta):
	if velocity.x > 0:
		sprite_anim.flip_h = true
	else:
		sprite_anim.flip_h = false
	if hurt:
		#if the player is too close (in the hit area), then hurts the player
		next_hurt -= delta
		if next_hurt <= 0:
			main.get_node("CowboyPlayer").hurt(damage)
			next_hurt = 1.5
			#making the next_hurt value higher makes it take more time
			sounds.play_sfx(attack_sfx)
	
	if hp <= 0:
		#if the enemy hp drops to zero, then it dies
		die()

func _determine_movement(delta):
	pass

func _physics_process(delta):
	status_checks(delta)
	_determine_movement(delta)
	move_and_collide(velocity * delta)
	_after_movement_checks(delta)

func die():
	var main = get_tree().get_root().get_node("Main")
	
	var d = death_sprite.instantiate()
	d.sound = death_sounds.pick_random()
	d.position = Vector2(position.x, position.y+30)
	main.add_child(d)
	
	for i in range(randi_range(1,5)):
		var c = coin.instantiate()
		c.create_pickup("coin")
		c.position = position + Vector2(randi_range(10,30), randi_range(10,30))
		main.add_child(c)
	
	if randi_range(0,5) == 0:
		var p = loot_table.pick_random()
		EnemyLoot.CreateLoot(p, self)
	queue_free()

func _on_sense_area_body_entered(body):
	if body.name == "CowboyPlayer":
		chase = body

func _on_sense_area_body_exited(body):
	if body.name == "CowboyPlayer":
		chase = null

func _on_hit_area_body_entered(body):
	if body.name == "CowboyPlayer":
		chase = null
		hurt = true

func _on_hit_area_body_exited(body):
	if body.name == "CowboyPlayer":
		chase = body
		hurt = false
