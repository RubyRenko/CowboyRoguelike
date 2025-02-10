extends Node2D

@onready var tilemap = $ForestTile
@onready var tile_details = $ForestDetail
@onready var enemies = [load("res://enemy.tscn"), load("res://goat_head.tscn")]

var color_palette = 0
var room_width = 36
var room_height = 24

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
	#tilemap.set_cells_terrain_connect(0, [Vector2i(0,0), Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(1,2)], 0, 0)
	create_room(room_width, room_height)
	for i in range(randi_range(3, 8)):
			create_detail(room_width, room_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		#var all_children = get_children()
		#for child in all_children:
			#if child.is_in_group("enemy"):
				#child.queue_free()
		tilemap.clear()
		tile_details.clear()
		create_room(room_width, room_height)
		for i in range(randi_range(5,12)):
			create_detail(room_width, room_height)
		#for i in range(rng.randi_range(2, 5)):
			#spawn_enemy(spawn_points[i].position)
		#$CowboyPlayer.position = Vector2(542, 358)


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
	for i in range(width+1):
		tilemap.set_cell(2, Vector2i(i,-1), 3, Vector2i(0,0))
		tilemap.set_cell(2, Vector2i(i, height+1), 3, Vector2i(0,0))

func create_detail(range_x, range_y):
	var point_x = randi_range(0, range_x)
	var point_y = randi_range(0, range_y)
	if tile_details.get_cell_atlas_coords(0, Vector2i(point_x, point_y)) == Vector2i(-1,-1):
		var pattern_ind : int
		if color_palette == 0 || color_palette == 3:
			pattern_ind = randi_range(0,8)
		else:
			pattern_ind = color_palette * 9 + randi_range(0,8)
		var pattern = tile_details.tile_set.get_pattern(pattern_ind)
		tile_details.set_pattern(0, Vector2i(point_x, point_y), pattern)
