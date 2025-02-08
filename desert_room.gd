extends Node2D

var rng = RandomNumberGenerator.new()
@onready var tilemap = $DesertTile
@onready var spawn_points = $SpawnPoints.get_children()
@onready var enemies = [load("res://enemy.tscn"), load("res://goat_head.tscn")]

#ids to get each tile from the tilemap
var tile_ids = [Vector2i(0, 0), Vector2i(1,0), #base tiles
				Vector2i(0,1), Vector2i(1,1), Vector2i(0,2)] #vegetation

#array with duplicates so that the empty tiles are more likely
var tileset_prob = [
				Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0),
				Vector2i(1,0), Vector2i(1,0), Vector2i(1,0), Vector2i(1,0),
				Vector2i(0,1),
				Vector2i(1,1),
				Vector2i(0,2)]

#how many rows and columns to generate
#can be adjusted to get bigger rooms
var room_height = 12
var room_width = 18
# Called when the node enters the scene tree for the first time.
func _ready():
	#sets the rng seed and creates room
	rng.set_seed(randi())
	create_room(room_height, room_width)
	#randomly spawns 2-5 enemies from each spawn point
	for i in range(rng.randi_range(2, 5)):
		spawn_enemy(spawn_points[i].position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if the player runs out of health, goes to the gameover screen
	if $CowboyPlayer.hp <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
	
	if Input.is_action_just_pressed("ui_accept"):
		var all_children = get_children()
		for child in all_children:
			if child.is_in_group("enemy"):
				child.queue_free()
		create_room(room_height, room_width)
		for i in range(rng.randi_range(2, 5)):
			spawn_enemy(spawn_points[i].position)
		$CowboyPlayer.position = Vector2(542, 358)

func create_room(height, width, padding = 6):
	#nested for loops to get i rows and j columns
	#padding is so that around the room there's still tiles and doesn't stop suddenly
	for i in range(-padding, height+padding):
		for j in range(-padding*2, width+(padding*2)):
			#0 is the layer, Vector2i(j,i) is the coordinate the tile will be placed at
			#0 is what tileset it is
			#tileset_prob is the coordinates for the actual tile from the tileset
			tilemap.set_cell(0, Vector2i(j,i), 0, tileset_prob.pick_random())
	
	#creates invisible wall around the edge of the room
	for i in range(height+1):
		tilemap.set_cell(1, Vector2i(-1, i), 1, Vector2i(0,0))
		tilemap.set_cell(1, Vector2i(width+1, i), 1, Vector2i(0,0))
	for i in range(width+1):
		tilemap.set_cell(1, Vector2i(i,-1), 1, Vector2i(0,0))
		tilemap.set_cell(1, Vector2i(i, height+1), 1, Vector2i(0,0))

func spawn_enemy(spawn_pos):
	#create a new enemy instance and set the position
	var e = enemies.pick_random().instantiate()
	e.position = spawn_pos
	add_child(e)
