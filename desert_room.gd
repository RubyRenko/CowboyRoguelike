extends Node2D

var rng = RandomNumberGenerator.new()
@onready var tilemap = $DesertTile
@onready var spawn_points = $SpawnPoints.get_children()
@onready var enemies = [load("res://enemy.tscn"), load("res://goat_head.tscn")]

var tile_ids = [Vector2i(0, 0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(0,2)]
var tileset_prob = [Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0),
				Vector2i(1,0), Vector2i(1,0), Vector2i(1,0), Vector2i(1,0),
				Vector2i(0,1),
				Vector2i(1,1),
				Vector2i(0,2)]
var room_height = 12
var room_width = 18
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.set_seed(randi())
	create_room(room_height, room_width)
	for i in range(randi_range(2, 5)):
		spawn_enemy(spawn_points[i].position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $CowboyPlayer.hp <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")

func create_room(height, width, padding = 5):
	for i in range(-padding, height+padding):
		for j in range(-padding*2, width+(padding*2)):
			tilemap.set_cell(0, Vector2i(j,i), 0, tileset_prob.pick_random())

func spawn_enemy(spawn_pos):
	#create a new enemy instance
	#add it to the enemy group and set the position randomly
	var e = enemies.pick_random().instantiate()
	e.position = spawn_pos
	add_child(e)
