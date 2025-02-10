extends Node2D

@onready var tilemap = $ForestTile
@onready var tile_details = $ForestDetail
@onready var enemies = [load("res://enemy.tscn"), load("res://goat_head.tscn")]

var color_palette = 2

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
	tile_details.set_pattern(0, Vector2i(0,0), tile_details.tile_set.get_pattern(0))
	#tilemap.set_cells_terrain_connect(0, [Vector2i(0,0), Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(1,2)], 0, 0)
	create_room(24, 36)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		#var all_children = get_children()
		#for child in all_children:
			#if child.is_in_group("enemy"):
				#child.queue_free()
		tilemap.clear()
		create_room(24, 36)
		#for i in range(rng.randi_range(2, 5)):
			#spawn_enemy(spawn_points[i].position)
		#$CowboyPlayer.position = Vector2(542, 358)


func create_room(height, width, padding = 12):
	var terrain_start_point = []
	#nested for loops to get i rows and j columns
	#padding is so that around the room there's still tiles and doesn't stop suddenly
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
	
	var to_tile = []
	for tile in terrain_start_point:
		to_tile.append(tile)
		var size_x = randi_range(2, 4)
		var size_y = randi_range(2, 4)
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
