extends CharacterBody2D

@onready var death_sprite = load("res://enemy_death_splat.tscn")
@onready var player: CowboyPlayer = $"../CowboyPlayer"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var progress_bar: ProgressBar = $Boss_UI/ProgressBar
@onready var state_machine = $FiniteStateMachine
@onready var chupacabra_death: AudioStreamPlayer2D = $Chupacabra_Death
@onready var main = get_tree().get_root().get_node("Main")
@onready var coin = load("res://coin.tscn")
@onready var loot_table = [load("res://Items/cadejo_pickup.tscn"), 
						load("res://Items/double_chamber.tscn"), 
						load("res://Items/gator_pickup.tscn"),
						load("res://Items/wampus_pickup.tscn"),
						load("res://Items/flatwoods_pickup.tscn"),
						load("res://Items/jackalop_pickup.tscn"),
						load("res://Items/dark_watcher_pickup.tscn"),
						load("res://Items/nessie_pickup.tscn"),
						load("res://Items/thunderbird_pickup.tscn"),
						load("res://Items/tractor_pickup.tscn"),
						load("res://Items/sinkhole_pickup.tscn")
						]


var direction : Vector2
var target : Vector2
var speed = 250
var DEF = 0
var next_hurt = 0
 
var health = 100:
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
	
	#direction = player.position - position
	if direction.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	if health <= 0:
		die()
 	
func die():
	var main = get_tree().get_root().get_node("Main")
	
	var d = death_sprite.instantiate()
	d.position = Vector2(position.x, position.y+30)
	main.add_child(d)
	
	for i in range(randi_range(1,5)):
		var c = coin.instantiate()
		c.position = position + Vector2(randi_range(10,30), randi_range(10,30))
		main.add_child(c)
		
	var p = loot_table.pick_random().instantiate()
	if p.is_in_group("sellable"):
		p.sold = true
	p.position = position
	main.add_child(p)
	
	queue_free()
	
func _physics_process(delta):
	velocity = direction.normalized() * speed
	move_and_collide(velocity * delta)
 
func take_damage():
	health -= 10 - DEF
