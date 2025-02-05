extends Node2D
@onready var enemy = load("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $CowboyPlayer.hp <= 0:
		#if the player runs out of hp
		#print("game over")
		get_tree().change_scene_to_file("res://game_over.tscn")
	
	#when space is pressed, spawns an enemy
	#ui accept is default, can be changed to whatever button
	if Input.is_action_just_pressed("ui_accept"):
		spawn_enemy()

func spawn_enemy():
	#create a new enemy instance
	#add it to the enemy group and set the position randomly
	var e = enemy.instantiate()
	e.position = Vector2(randi_range(100,1052), randi_range(100,548))
	add_child(e)
