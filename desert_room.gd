extends Node2D

var rng = RandomNumberGenerator.new()
@onready var tilemap = $DesertTile
@onready var tile_detail = $DesertSprites
@onready var player = $CowboyPlayer
@onready var enemies = [load("res://goat_head.tscn")]
@onready var wave_timer = $WaveTimer
@onready var wave_display = $Gui/WaveAnim
@onready var shop_spawn = load("res://shop.tscn")
@onready var boss = load("res://chubacabra.tscn")


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
var room_height = 50
var room_width = 50

var wave = 1
var spawn_points = []
var difficulty = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	start_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if the player runs out of health, goes to the gameover screen
	if player.hp <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
	
	"""if Input.is_action_just_pressed("ui_accept"):
		clean_up()
		start_up()"""

func create_room(width, height, padding = 6):
	#nested for loops to get i rows and j columns
	#padding is so that around the room there's still tiles and doesn't stop suddenly
	for i in range(-padding, height+padding):
		for j in range(-padding*2, width+(padding*2)):
			#0 is the layer, Vector2i(j,i) is the coordinate the tile will be placed at
			#0 is what tileset it is
			#tileset_prob is the coordinates for the actual tile from the tileset
			tilemap.set_cell(0, Vector2i(j,i), 0, tileset_prob.pick_random())
			
			if i == 10 || i == height - 10 || j == 10 || j == width - 10:
				if i > 0 && i < height && j > 0 && j < width:
					spawn_points.append(Vector2i(j, i))
	
	#creates invisible wall around the edge of the room
	for i in range(height+1):
		tilemap.set_cell(1, Vector2i(-1, i), 1, Vector2i(0,0))
		tilemap.set_cell(1, Vector2i(width+1, i), 1, Vector2i(0,0))
		if i % 2 == 0:
			var cactus = tile_detail.tile_set.get_pattern(randi_range(0,1))
			var cactus2 = tile_detail.tile_set.get_pattern(randi_range(0,1))
			tile_detail.set_pattern(Vector2i(-1, i), cactus)
			tile_detail.set_pattern(Vector2i(width+1, i), cactus2)
		
	for i in range(width+1):
		tilemap.set_cell(1, Vector2i(i,-1), 1, Vector2i(0,0))
		tilemap.set_cell(1, Vector2i(i, height+1), 1, Vector2i(0,0))
		if i % 2 == 0:
			var cactus = tile_detail.tile_set.get_pattern(randi_range(0,1))
			var cactus2 = tile_detail.tile_set.get_pattern(randi_range(0,1))
			tile_detail.set_pattern(Vector2i(i, -1), cactus)
			tile_detail.set_pattern(Vector2i(i, height+1), cactus2)

func create_detail(width, height):
	var invalid_array = [
		Vector2i(width/2-1, height/2-1), Vector2i(width/2, height/2-1), Vector2i(width/2+1, height/2-1),
		Vector2i(width/2-1, height/2), Vector2i(width/2, height/2), Vector2i(width/2+1, height/2),
		Vector2i(width/2-1, height/2+1),Vector2i(width/2, height/2+1), Vector2i(width/2+1, height/2+1)]
	
	#create buildings
	for i in range(randi_range(20, 40)):
		var spawn_x = randi_range(1, width-1)
		var spawn_y = randi_range(1, height-1)
		var spawning_tiles = [
			Vector2i(spawn_x, spawn_y), Vector2i(spawn_x+1, spawn_y), Vector2i(spawn_x+2, spawn_y),
			Vector2i(spawn_x, spawn_y+1), Vector2i(spawn_x+1, spawn_y+1), Vector2i(spawn_x+2, spawn_y+1),
			Vector2i(spawn_x, spawn_y+2), Vector2i(spawn_x+1, spawn_y+2), Vector2i(spawn_x+2, spawn_y+2)
		]
		
		var invalid_spawn = true
		while invalid_spawn:
			var found_invalid = false
			for tile in spawning_tiles:
				if tile in invalid_array:
					spawn_x += randi_range(-3, 3)
					spawn_y += randi_range(-3, 3)
					found_invalid = true
				elif tile_detail.get_cell_atlas_coords(tile) != Vector2i(-1, -1):
					invalid_array.append(Vector2i(spawn_x, spawn_y))
					spawn_x += randi_range(-3, 3)
					spawn_y += randi_range(-3, 3)
					found_invalid = true
			if found_invalid:
				spawning_tiles = [
				Vector2i(spawn_x, spawn_y), Vector2i(spawn_x+1, spawn_y), Vector2i(spawn_x+2, spawn_y),
				Vector2i(spawn_x, spawn_y+1), Vector2i(spawn_x+1, spawn_y+1), Vector2i(spawn_x+2, spawn_y+1),
				Vector2i(spawn_x, spawn_y+2), Vector2i(spawn_x+1, spawn_y+2), Vector2i(spawn_x+2, spawn_y+2)
				]
			elif !found_invalid:
				invalid_spawn = false
		
		spawning_tiles = [
			Vector2i(spawn_x, spawn_y), Vector2i(spawn_x+1, spawn_y), Vector2i(spawn_x+2, spawn_y),
			Vector2i(spawn_x, spawn_y+1), Vector2i(spawn_x+1, spawn_y+1), Vector2i(spawn_x+2, spawn_y+1),
			Vector2i(spawn_x, spawn_y+2), Vector2i(spawn_x+1, spawn_y+2), Vector2i(spawn_x+2, spawn_y+2)
		]
		var pattern = tile_detail.tile_set.get_pattern(randi_range(5, 7))
		for tile in spawning_tiles:
			invalid_array.append(tile)
		tile_detail.set_pattern(Vector2i(spawn_x, spawn_y), pattern)
	
	#create cactus
	for i in range(randi_range(30, 100)):
		var spawn_x = randi_range(1, width-1)
		var spawn_y = randi_range(1, height-1)
		var spawning_tiles = [
			Vector2i(spawn_x, spawn_y), Vector2i(spawn_x, spawn_y +1)
		]
		
		var invalid_spawn = true
		while invalid_spawn:
			var found_invalid = false
			for tile in spawning_tiles:
				if tile in invalid_array:
					spawn_x += randi_range(-3, 3)
					spawn_y += randi_range(-3, 3)
					found_invalid = true
				elif tile_detail.get_cell_atlas_coords(tile) != Vector2i(-1, -1):
					invalid_array.append(Vector2i(spawn_x, spawn_y))
					spawn_x += randi_range(-3, 3)
					spawn_y += randi_range(-3, 3)
					found_invalid = true
			if found_invalid:
				spawning_tiles = [
				Vector2i(spawn_x, spawn_y), Vector2i(spawn_x, spawn_y+1)
				]
			elif !found_invalid:
				invalid_spawn = false
		
		var pattern = tile_detail.tile_set.get_pattern(randi_range(0, 4))
		for tile in spawning_tiles:
			invalid_array.append(tile)
		tile_detail.set_pattern(Vector2i(spawn_x, spawn_y), pattern)

func spawn_enemy(spawn_pos):
	#create a new enemy instance and set the position
	var e = enemies.pick_random().instantiate()
	e.position = spawn_pos
	add_child(e)

func start_up():
	create_room(room_width, room_height)
	create_detail(room_width, room_height)
	var pattern = tile_detail.tile_set.get_pattern(randi_range(5, 7))
	tile_detail.set_pattern(Vector2i(0,0), pattern)
	player.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
	#starts wave timer and makes the first wave spawn earlier
	wave_timer.start()
	wave_timer.wait_time = 30

func clean_up():
	var all_children = get_children()
	for child in all_children:
		if child.is_in_group("enemy"):
			child.queue_free()

func spawn_wave(difficulty):
	var spawn_array = spawn_points
	for i in range(randi_range(difficulty, difficulty*2)):
		#picks a random point from the possible spawn points
		#spawns an enemy and then pops the value so there isn't duplicates
		#print(spawn_array)
		var index = randi_range(1*i, 20*i)
		if index >= spawn_array.size():
			index = spawn_array.size()-1
		var spawn_pos = spawn_array.pop_at(index)
		#print(spawn_pos)
		#print(spawn_array)
		spawn_enemy(tilemap.map_to_local(spawn_pos))

func _on_wave_timer_timeout():
	print("wave ", wave)
	wave_display.display_wave(wave)
	"""if wave == 1:
		var chupacabra = boss.instantiate()
		chupacabra.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
		chupacabra.scale = Vector2(1.5, 1.5)
		add_child(chupacabra)"""
	"""if wave == 1:
		#clears the previous waves and stops timer
		wave_timer.stop()
		clean_up()
		#spawn shop
		var shop = shop_spawn.instantiate()
		shop.position = player.position
		shop.add_to_group("shop")
		add_child(shop)
		print("shop spawn")
		difficulty += 3"""
	if wave == 15:
		var chupacabra = boss.instantiate()
		chupacabra.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
		chupacabra.scale = Vector2(1.5, 1.5)
		add_child(chupacabra)
	elif wave % 5 == 0:
		#clears the previous waves and stops timer
		wave_timer.stop()
		clean_up()
		#spawn shop
		var shop = shop_spawn.instantiate()
		shop.position = player.position
		add_child(shop)
		print("shop spawn")
		difficulty += 3
	else:
		print("enemy spawn")
		spawn_wave(difficulty)
	wave += 1

func _on_child_exiting_tree(node):
	if node.name == "Shop":
		wave_timer.wait_time = 5
		wave_timer.start()
		wave_timer.wait_time = 30
