extends Node2D

var rng = RandomNumberGenerator.new()
@onready var tilemap = $DesertTileBase
@onready var tile_detail = $DesertTileDetail
@onready var tile_patterns = [
	tile_detail.tile_set.get_pattern(0), #patterns 0-6 are 2x3
	tile_detail.tile_set.get_pattern(1),
	tile_detail.tile_set.get_pattern(2),
	tile_detail.tile_set.get_pattern(3),
	tile_detail.tile_set.get_pattern(4),
	tile_detail.tile_set.get_pattern(5),
	tile_detail.tile_set.get_pattern(6),
	tile_detail.tile_set.get_pattern(7), #patterns 7-8 are 2x4
	tile_detail.tile_set.get_pattern(8),
	tile_detail.tile_set.get_pattern(9), #patterns 9-16 are 2x2
	tile_detail.tile_set.get_pattern(10),
	tile_detail.tile_set.get_pattern(11),
	tile_detail.tile_set.get_pattern(12),
	tile_detail.tile_set.get_pattern(13),
	tile_detail.tile_set.get_pattern(14),
	tile_detail.tile_set.get_pattern(15),
	tile_detail.tile_set.get_pattern(16),
	tile_detail.tile_set.get_pattern(17), #patterns 17-18 are 3x2
	tile_detail.tile_set.get_pattern(18),
	tile_detail.tile_set.get_pattern(19), #patterns 19-20 are 3x3
	tile_detail.tile_set.get_pattern(20),
	tile_detail.tile_set.get_pattern(21), #patterns 21-23 are 4x5
	tile_detail.tile_set.get_pattern(22),
	tile_detail.tile_set.get_pattern(23),
	tile_detail.tile_set.get_pattern(24), #pattern 24 is 3x5
	tile_detail.tile_set.get_pattern(25) #pattern 25 is 3x4
	]
@onready var player = $CowboyPlayer
@onready var enemies = [
				load("res://Enemies/GoatHead/goat_head.tscn"), load("res://Enemies/GoatHead/goat_head_alt.tscn"), #desert enemies
				load("res://Enemies/Moths/moth.tscn"), load("res://Enemies/Moths/moth_alt.tscn"), load("res://Enemies/Larva/larva.tscn") #forest enemies
				]
@onready var wave_timer : Timer = $Gui/WaveTimer
@onready var wave_display = $Gui/WaveAnim
@onready var shop_spawn = load("res://Shop/shop.tscn")
@onready var boss = load("res://Enemies/Chupacabra_New/chubacabra_new.tscn")
@onready var wave_sfx = $WaveSfxPlayer
@onready var nav_arrow = $CowboyPlayer/nav_arrow

@export var wave_bar : TextureProgressBar
@export var enemies_rem_label : Label
var enemies_rem_text : String = "Enemies Remaining: "

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
		get_tree().change_scene_to_file("res://GeneralUI/main_menu2.tscn")


func create_room(width, height, padding = 12):
	var terrain_start_point : Array
	#nested for loops to get i rows and j columns
	#padding is so that around the room there's still tiles and doesn't stop suddenly
	for i in range(-padding, height+padding):
		for j in range(-padding*2, width+(padding*2)):
			#0 is the layer, Vector2i(j,i) is the coordinate the tile will be placed at
			#0 is what tileset it is
			#tileset_prob is the coordinates for the actual tile from the tileset
			tilemap.set_cell(Vector2i(j, i), 0, Vector2i(6, 0))
			
			if i == 15 && j >= 5 || i == height - 15 && j >= 5\
			|| j == 15 && i >= 5|| j == width - 15 && i >= 5:
				if i > 0 && i < height && j > 0 && j < width:
					spawn_points.append(Vector2i(j, i))
	
	# sets the invisible walls
	for i in (height+1):
		tilemap.set_cell(Vector2i(-1, i), 0, Vector2i(13, 0))
		tilemap.set_cell(Vector2i(width+1, i), 0, Vector2i(13, 0))
		
	for i in (width+1):
		tilemap.set_cell(Vector2i(i, -1), 0, Vector2i(13, 0))
		tilemap.set_cell(Vector2i(i, height+1), 0, Vector2i(13, 0))
	
	"""#create grass patches
	var to_tile = []
	for tile in terrain_start_point:
		to_tile.append(tile)
		var size_x = randi_range(3, 5)
		var size_y = randi_range(3, 5)
		for x in range(-size_x, size_x):
			for y in range(-size_y, size_y):
				var new_tile = tile + Vector2i(x, y)
				to_tile.append(new_tile)
	
	desert_tile[1].set_cells_terrain_connect(to_tile, 0, 1)"""

func create_detail(width, height, amount = 50):
	var invalid_array = [
		Vector2i(width/2-1, height/2-1), Vector2i(width/2, height/2-1), Vector2i(width/2+1, height/2-1),
		Vector2i(width/2-1, height/2), Vector2i(width/2, height/2), Vector2i(width/2+1, height/2),
		Vector2i(width/2-1, height/2+1),Vector2i(width/2, height/2+1), Vector2i(width/2+1, height/2+1)]
	
	for i in amount:
		var spawn_point = Vector2i(randi_range(3, room_width-3), randi_range(3, room_height-3))
		var pattern_ind = randi_range(0, 25)
		var pattern = tile_patterns[pattern_ind]
		if pattern_ind <= 6:
			# checks in a 2x3 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 2, 3, invalid_array)
		elif pattern_ind <= 8:
			# checks in a 2x4 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 2, 4, invalid_array)
		elif pattern_ind <= 16:
			# checks in a 2x2 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 2, 2, invalid_array)
		elif pattern_ind <= 18:
			# checks in a 3x2 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 3, 2, invalid_array)
		elif pattern_ind <= 20:
			# checks in a 3x3 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 3, 3, invalid_array)
		elif pattern_ind <= 23:
			# checks in a 4x5 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 4, 5, invalid_array)
		elif pattern_ind == 24:
			# checks in a 3x5 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 3, 5, invalid_array)
		elif pattern_ind == 25:
			# checks in a 3x4 area if it's clear and can be spawned there
			spawn_desert_pattern(pattern, spawn_point, 3, 4, invalid_array)

func spawn_desert_pattern(pattern, spawn_point, x_dim, y_dim, invalid_array):
	# checks in a x_dim by y_dim if the spaces are clear to be spawned in
	var valid_spawn = true
	for x in x_dim:
		for y in y_dim:
			if spawn_point + Vector2i(x, y) in invalid_array:
					valid_spawn = false
	# if can spawn, then sets the pattern and appends the tiles
	# taken up by the pattern onto the invalid array
	if valid_spawn:
		tile_detail.set_pattern(spawn_point, pattern)
		for x in x_dim:
			for y in y_dim:
				invalid_array.append(spawn_point + Vector2i(x, y))

func spawn_enemy(spawn_pos, difficult = 1):
	#create a new enemy instance and set the dddddddddposition
	var e = enemies.pick_random().instantiate()
	e.position = spawn_pos
	add_child(e)

func start_up():
	create_room(room_width, room_height)
	create_detail(room_width, room_height)
	"var pattern = tile_detail.tile_set.get_pattern(randi_range(5, 7))
	tile_detail.set_pattern(Vector2i(0,0), pattern)"
	player.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
	#starts wave timer and makes the first wave spawn earlier
	wave_timer.start()
	wave_timer.wait_time = 30
	nav_arrow.visible = false

func clean_up():
	var all_children = get_children()
	for child in all_children:
		if child.is_in_group("enemy") || child.is_in_group("enemy_prod"):
			child.queue_free()

var enemies_spawned : int = 0
var enemies_left : int = 0
func spawn_wave(difficulty):
	wave_timer.stop()
	enemies_rem_label.visible = true
	var spawn_array = spawn_points.duplicate()
	var spawn_1 = spawn_array.slice(0, spawn_array.size()/4)
	var spawn_2 = spawn_array.slice(spawn_array.size()/4, (spawn_array.size()/4)*2)
	var spawn_3 = spawn_array.slice((spawn_array.size()/4)*2, (spawn_array.size()/4)*3)
	var spawn_4 = spawn_array.slice((spawn_array.size()/4)*2, spawn_array.size())
	var subsections = [spawn_1, spawn_2, spawn_3, spawn_4]
	
	var player_position = tilemap.local_to_map(player.position)
	var num_to_spawn = difficulty * 4 + randi_range(0, 3)
	enemies_spawned = num_to_spawn
	enemies_left = num_to_spawn
	enemies_rem_label.text = enemies_rem_text + str(enemies_left)
	for i in range(num_to_spawn):
		var section = subsections.pick_random()
		var spawn_pos = section.pick_random()
		while spawn_pos == player_position:
			spawn_pos = section.pick_random()
		section.pop_at(section.find(spawn_pos))
		#spawn_enemy(tilemap.map_to_local(spawn_pos), difficulty)
		print("spawned enemy at " + str(spawn_pos))
	

func _on_wave_timer_timeout():
	print("wave ", wave)
	wave_display.display_wave(wave)
	wave_bar.change_wave(wave)
	if wave == 16:
		get_tree().change_scene_to_file("res://Rooms/Forest/forest_room.tscn")
	elif wave == 15:
		#uncomment when chupacabra is ready
		wave_timer.stop()
		var chupacabra = boss.instantiate()
		chupacabra.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
		chupacabra.scale = Vector2(1.5, 1.5)
		add_child(chupacabra)
		enemies_rem_label.text = enemies_rem_text.to_upper() + "1"
	elif wave % 5 == 0:
		shop_wave()
	elif wave == 14:
		wave_sfx.play_sfx("new_wave")
		$Gui/WaveBarLabel.text = "BOSS INCOMING:"
		print("enemy spawn")
		spawn_wave(difficulty)
	elif (wave+1) % 5 == 0:
		wave_sfx.play_sfx("new_wave")
		$Gui/WaveBarLabel.text = "SHOP INCOMING:"
		print("enemy spawn")
		spawn_wave(difficulty)
	else:
		wave_sfx.play_sfx("new_wave")
		$Gui/WaveBarLabel.text = "NEXT WAVE:"
		print("enemy spawn")
		spawn_wave(difficulty)
	wave += 1
	
func shop_wave():
	#clears the previous waves and stops timer
	enemies_rem_label.visible = false
	wave_sfx.play_sfx("shop_summon")
	wave_timer.stop()
	clean_up()
	#spawn shop
	var shop = shop_spawn.instantiate()
	shop.position = tilemap.map_to_local(Vector2i(room_width/2, room_height/2))
	add_child(shop)
	$Gui/WaveBarLabel.text = "SHOP"
	print("shop spawn")
	difficulty += 1
	nav_arrow.visible = true

func _on_child_exiting_tree(node):
	if node.name == "Shop":
		wave_timer.wait_time = 5
		wave_timer.start()
		wave_timer.wait_time = 30
		wave_sfx.play_sfx("shop_leave")
		nav_arrow.visible = false
	if node.is_in_group("enemy") && node.hit_by_player:
		var kill_sounds = ["kill1", "kill2", "kill3", "kill4"]
		wave_sfx.play_sfx(kill_sounds.pick_random())
		enemies_left -= 1
		enemies_rem_label.text = enemies_rem_text + str(enemies_left)
		if enemies_left <= 0:
			wave_timer.wait_time = 5
			wave_timer.start()
			
