extends Node2D

@onready var tilemap = $ForestTile
@onready var tile_details = $ForestDetail
@onready var player = $CowboyPlayer
@onready var enemies = [
				#load("res://goat_head.tscn"), load("res://goat_head_alt.tscn"), #desert enemies
				load("res://moth.tscn"), load("res://moth_alt.tscn"), load("res://larva.tscn") #forest enemies
				]
@onready var wave_timer = $Gui/WaveTimer
@onready var wave_display = $Gui/WaveAnim
@onready var shop_spawn = load("res://shop.tscn")
#@onready var boss = load("res://chubacabra.tscn") #boss, change with mothman
@onready var wave_sfx = $WaveSfxPlayer

var color_palette = 0
var room_width = 80
var room_height = 80

var wave = 1
var spawn_points = []
var difficulty = 1

var tile_ids = [
			Vector2i(1,1), Vector2i(5,0), Vector2i(5,1), #base grass tiles
			Vector2i(6,0), Vector2i(7,0), Vector2i(6,1), Vector2i(7,1), Vector2i(6,2), Vector2i(7,2) #dirt tiles
			]

var dirt_prob = [
			Vector2i(6,0), Vector2i(6,0),Vector2i(6,0),
			Vector2i(7,0), Vector2i(6,1), Vector2i(7,1), Vector2i(6,2), Vector2i(7,2)
			]

var grass_prob = [
			Vector2i(1,1), Vector2i(1,1), Vector2i(1,1),
			Vector2i(5,0), Vector2i(5,1), #base grass tiles
			]

# Called when the node enters the scene tree for the first time.
func _ready():
	start_up()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	"""if Input.is_action_just_pressed("ui_accept"):
		#var all_children = get_children()
		#for child in all_children:
			#if child.is_in_group("enemy"):
				#child.queue_free()
		tilemap.clear()
		tile_details.clear()
		create_room(room_width, room_height)
		for i in range(randi_range(10, 20)):
			create_detail(room_width, room_height)
		#for i in range(rng.randi_range(2, 5)):
			#spawn_enemy(spawn_points[i].position)
		#$CowboyPlayer.position = Vector2(542, 358)"""
	
	if player.hp <= 0:
		clean_up()
		$Gui.visible = false
		player.die()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")

func create_room(width, height, padding = 12):
	var terrain_start_point = []
	#nested for loops to get i rows and j columns
	#padding is so that around the room there's still tiles and doesn't stop suddenly
	#base dirt tiles
	for i in range(-padding, height+padding):
		for j in range(-padding*2, width+(padding*2)):
			#0 is the layer, Vector2i(j,i) is the coordinate the tile will be placed at
			#0 is what tileset it is
			#tileset_prob is the coordinates for the actual tile from the tileset
			if randi_range(0,10) > 0:
				tilemap.set_cell(0, Vector2i(j, i), color_palette, tile_ids[3])
			else:
				tilemap.set_cell(0, Vector2i(j, i), color_palette, dirt_prob.pick_random())
			if randi_range(0, 40) == 0:
				terrain_start_point.append(Vector2i(j, i))
			
			if i == 30 || i == height - 30 || j == 30 || j == width - 30:
				if i > 0 && i < height && j > 0 && j < width:
					spawn_points.append(Vector2i(j, i))
	
	#create grass patches
	var to_tile = []
	for tile in terrain_start_point:
		to_tile.append(tile)
		var size_x = randi_range(2, 5)
		var size_y = randi_range(2, 5)
		for x in range(-size_x, size_x):
			for y in range(-size_y, size_y):
				var new_tile = tile + Vector2i(x, y)
				to_tile.append(new_tile)
	
	tilemap.set_cells_terrain_connect(1, to_tile, 0, color_palette)
	
	for tile in to_tile:
		if (tilemap.get_cell_atlas_coords(1,tile) == Vector2i(1,1)) and (randi_range(0,10) == 0):
			tilemap.set_cell(1, tile, color_palette, grass_prob.pick_random())
	
	#creates invisible wall around the edge of the room
	for i in range(height+1):
		tilemap.set_cell(2, Vector2i(-1, i), 3, Vector2i(0,0))
		tilemap.set_cell(2, Vector2i(width+1, i), 3, Vector2i(0,0))
		if i == 0:
			pass
		elif i % 3 == 0:
			var tree = tile_details.tile_set.get_pattern(0)
			tile_details.set_pattern(0, Vector2i(-1, i), tree)
			tile_details.set_pattern(0, Vector2i(width+1, i), tree)
	for i in range(width+1):
		tilemap.set_cell(2, Vector2i(i,-1), 3, Vector2i(0,0))
		tilemap.set_cell(2, Vector2i(i, height+1), 3, Vector2i(0,0))
		if i % 3 == 0:
			var tree = tile_details.tile_set.get_pattern(0)
			tile_details.set_pattern(0, Vector2i(i, -1), tree)
			tile_details.set_pattern(0, Vector2i(i, height+1), tree)

func create_detail(range_x, range_y):
	var point = Vector2i(randi_range(0, range_x), randi_range(0, range_y))
	var detail_array = [Vector2i(7,0), Vector2i(9,0), Vector2i(11,0), Vector2i(13,0), 
						Vector2i(7,2), Vector2i(9,2), Vector2i(11,2), Vector2i(13,2),
									   Vector2i(9,4), Vector2i(11,4), Vector2i(13,4)]
	if point == Vector2i(16, 12):
		point.x += 2
		point.y += 2
	while tile_details.get_cell_atlas_coords(0, point) != Vector2i(-1,-1):
		point.x += randi_range(-3, 3)
		point.y += randi_range(-3, 3)
	if tile_details.get_cell_atlas_coords(0, point) == Vector2i(-1,-1):
		if point in spawn_points:
			spawn_points.pop_at(spawn_points.find(point))
		if randi_range(0,1) == 0:
			#50% chance for a big item, a pattern
			var pattern_ind : int
			if color_palette == 0 || color_palette == 3:
				pattern_ind = randi_range(0,7)
			else:
				pattern_ind = color_palette * 9 + randi_range(0,7)
			var pattern = tile_details.tile_set.get_pattern(pattern_ind)
			tile_details.set_pattern(0, point, pattern)
		else:
			#50% chance for a small item
			var color
			if color_palette == 0 || color_palette == 3:
				color = 0
			else:
				color = 1
			tile_details.set_cell(0, point, color, detail_array.pick_random())

func start_up():
	create_room(room_width, room_height)
	for i in range(randi_range(10, 20)):
			create_detail(room_width, room_height)
	player.position = tilemap.map_to_local(Vector2i(room_width, room_height))
	#starts wave timer and makes the first wave spawn earlier
	wave_timer.start()
	wave_timer.wait_time = 20

func clean_up():
	var all_children = get_children()
	for child in all_children:
		if child.is_in_group("enemy") || child.is_in_group("enemy_prod"):
			child.queue_free()

func spawn_enemy(spawn_pos, difficult = 1):
	#create a new enemy instance and set the position
	var e = enemies.pick_random().instantiate()
	e.hp += (e.hp/2) * (difficulty-1)
	e.position = spawn_pos
	add_child(e)

func spawn_wave(difficulty):
	var spawn_array = spawn_points.duplicate()
	var spawn_1 = spawn_array.slice(0, spawn_array.size()/4)
	var spawn_2 = spawn_array.slice(spawn_array.size()/4, (spawn_array.size()/4)*2)
	var spawn_3 = spawn_array.slice((spawn_array.size()/4)*2, (spawn_array.size()/4)*3)
	var spawn_4 = spawn_array.slice((spawn_array.size()/4)*2, spawn_array.size())
	var subsections = [spawn_1, spawn_2, spawn_3, spawn_4]
	print(spawn_array.size())
	print(spawn_1)
	print(spawn_2)
	print(spawn_3)
	print(spawn_4)
	
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

func _on_child_exiting_tree(node):
	if node.name == "Shop":
		wave_timer.wait_time = 5
		wave_timer.start()
		wave_timer.wait_time = 30
		wave_sfx.play_sfx("shop_leave")
	if node.is_in_group("enemy") && node.hit_by_player:
		var kill_sounds = ["kill1", "kill2", "kill3", "kill4"]
		wave_sfx.play_sfx(kill_sounds.pick_random())

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
	#uncomment and swap chupacabra for mothman here
	"if wave == 15:
		wave_timer.stop()
		var chupacabra = boss.instantiate()
		chupacabra.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
		chupacabra.scale = Vector2(1.5, 1.5)
		add_child(chupacabra)"
	if wave % 5 == 0:
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
