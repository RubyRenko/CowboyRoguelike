extends Node2D
const DESERT_SCENE_PATH : String = "res://Rooms/Desert/desert_room.tscn"
var loading_desert = false
@onready var cowboy = load("res://Player/cowboy_player.tscn")

func _process(delta):
	if loading_desert && (ResourceLoader.load_threaded_get_status(DESERT_SCENE_PATH) == ResourceLoader.THREAD_LOAD_LOADED):
		var new_scene :PackedScene = ResourceLoader.load_threaded_get(DESERT_SCENE_PATH)
		get_tree().change_scene_to_packed(new_scene)
		
func _on_forest_button_pressed():
	get_tree().change_scene_to_file("res://Rooms/Forest/forest_room.tscn")


func _on_texture_button_pressed() -> void:
	ResourceLoader.load_threaded_request(DESERT_SCENE_PATH)
	loading_desert = true
	CowboyPlayer.init_stats()
