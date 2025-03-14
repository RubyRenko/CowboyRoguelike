extends Node2D

var rng = RandomNumberGenerator.new()
@onready var tilemap = $DesertTile
@onready var tile_detail = $DesertSprites
@onready var player = $CowboyPlayer
@onready var enemies = [
				load("res://goat_head.tscn"), load("res://goat_head_alt.tscn"), #desert enemies
				load("res://moth.tscn"), load("res://moth_alt.tscn"), load("res://larva.tscn") #forest enemies
				]
@onready var wave_timer = $Gui/WaveTimer
@onready var wave_display = $Gui/WaveAnim
@onready var shop_spawn = load("res://shop.tscn")
@onready var boss = load("res://chubacabra.tscn")
@onready var wave_sfx = $WaveSfxPlayer


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
var difficulty = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	start_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if the player runs out of health, goes to the gameover screen
	if player.hp <= 0:
		clean_up()
		$Gui.visible = false
		player.die()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")
	
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
			
			if i == 15 || i == height - 15 || j == 15 || j == width - 15:
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
	for i in range(randi_range(10, 20)):
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
			if tile in spawn_points:
				spawn_points.remove_at(spawn_points.find(tile))
		tile_detail.set_pattern(Vector2i(spawn_x, spawn_y), pattern)
	
	#create cactus
	for i in range(randi_range(25, 50)):
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
			if tile in spawn_points:
				spawn_points.remove_at(spawn_points.find(tile))
		tile_detail.set_pattern(Vector2i(spawn_x, spawn_y), pattern)

func spawn_enemy(spawn_pos, difficult = 1):
	#create a new enemy instance and set the position
	var e = enemies.pick_random().instantiate()
	e.hp += (e.hp/2) * (difficulty-1)
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
		if child.is_in_group("enemy") || child.is_in_group("enemy_prod"):
			child.queue_free()

func spawn_wave(difficulty):
	var spawn_array = spawn_points.duplicate()
	var spawn_1 = spawn_array.slice(0, spawn_array.size()/4)
	var spawn_2 = spawn_array.slice(spawn_array.size()/4, (spawn_array.size()/4)*2)
	var spawn_3 = spawn_array.slice((spawn_array.size()/4)*2, (spawn_array.size()/4)*3)
	var spawn_4 = spawn_array.slice((spawn_array.size()/4)*2, spawn_array.size())
	var subsections = [spawn_1, spawn_2, spawn_3, spawn_4]
	"print(spawn_array.size())
	print(spawn_1)
	print(spawn_2)
	print(spawn_3)
	print(spawn_4)"
	
	var player_position = tilemap.local_to_map(player.position)
	var num_to_spawn = difficulty * 4 + randi_range(0, 3)
	for i in range(num_to_spawn):
		var section = subsections.pick_random()
		var spawn_pos = section.pick_random()
		while spawn_pos == player_position:
			spawn_pos = section.pick_random()
		section.pop_at(section.find(spawn_pos))
		spawn_enemy(tilemap.map_to_local(spawn_pos), difficulty)
		print("spawned enemy at " + str(spawn_pos))
	

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
	if wave == 16:
		get_tree().change_scene_to_file("res://forest_room.tscn")
	elif wave == 15:
		#uncomment when chupacabra is ready
		pass
		"wave_timer.stop()
		var chupacabra = boss.instantiate()
		chupacabra.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
		chupacabra.scale = Vector2(1.5, 1.5)
		add_child(chupacabra)"
	elif wave % 5 == 0:
		#clears the previous waves and stops timer
		wave_sfx.play_sfx("shop_summon")
		wave_timer.stop()
		clean_up()
		#spawn shop
		var shop = shop_spawn.instantiate()
		shop.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
		add_child(shop)
		$Gui/WaveBarLabel.text = "Shop"
		print("shop spawn")
		difficulty += 1
	elif wave == 14:
		wave_sfx.play_sfx("new_wave")
		$Gui/WaveBarLabel.text = "Boss incoming:"
		print("enemy spawn")
		spawn_wave(difficulty)
	elif (wave+1) % 5 == 0:
		wave_sfx.play_sfx("new_wave")
		$Gui/WaveBarLabel.text = "Shop incoming:"
		print("enemy spawn")
		spawn_wave(difficulty)
	else:
		wave_sfx.play_sfx("new_wave")
		$Gui/WaveBarLabel.text = "Next wave:"
		print("enemy spawn")
		spawn_wave(difficulty)
	wave += 1

func _on_child_exiting_tree(node):
	if node.name == "Shop":
		wave_timer.wait_time = 5
		wave_timer.start()
		wave_timer.wait_time = 30
		wave_sfx.play_sfx("shop_leave")
	if node.is_in_group("enemy") && node.hit_by_player:
		var kill_sounds = ["kill1", "kill2", "kill3", "kill4"]
		wave_sfx.play_sfx(kill_sounds.pick_random())
