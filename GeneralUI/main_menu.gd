extends Node2D
const DESERT_SCENE_PATH : String = "res://Rooms/Desert/desert_room.tscn"
const FOREST_SCENE_PATH : String = "res://Rooms/Forest/forest_room.tscn"
var loading_desert = false
var loading_forest = false

@onready var start_button = $TextureButtonDesert

func _ready():
	start_button.pressed.connect(_on_texture_button_pressed)

func _process(delta):
	if loading_desert && (ResourceLoader.load_threaded_get_status(DESERT_SCENE_PATH) == ResourceLoader.THREAD_LOAD_LOADED):
		var new_scene :PackedScene = ResourceLoader.load_threaded_get(DESERT_SCENE_PATH)
		get_tree().change_scene_to_packed(new_scene)
	if loading_forest && (ResourceLoader.load_threaded_get_status(FOREST_SCENE_PATH) == ResourceLoader.THREAD_LOAD_LOADED):
		var new_scene :PackedScene = ResourceLoader.load_threaded_get(FOREST_SCENE_PATH)
		get_tree().change_scene_to_packed(new_scene)
		
		
		
		
func _on_forest_button_pressed() -> void:
	ResourceLoader.load_threaded_request(FOREST_SCENE_PATH)
	loading_forest = true
	CowboyPlayer.init_stats()


func _on_texture_button_pressed() -> void:
	ResourceLoader.load_threaded_request(DESERT_SCENE_PATH)
	print("START BUTTON PRESSED")
	loading_desert = true
