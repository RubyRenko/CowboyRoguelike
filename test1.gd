extends Node2D
@onready var enemy = load("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $CowboyPlayer.hp <= 0:
		#if the player runs out of hp
		#pauses the game and makes the gameover text visible
		#print("game over")
		$GUI/GameOverText.visible = true
		get_tree().paused = true
		#insert scene change to game over screen here
	
	#when space is pressed, spawns an enemy
	#ui accept is default, can be changed to whatever button
	if Input.is_action_just_pressed("ui_accept"):
		spawn_enemy()

func spawn_enemy():
	#create a new enemy instance
	#add it to the enemy group and set the position randomly
	var e = enemy.instantiate()
	e.position = Vector2(randi_range(0,1152), randi_range(0,648))
	add_child(e)
