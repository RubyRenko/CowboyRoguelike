extends Node2D
const DESERT_SCENE_PATH : String = "res://desert_room.tscn"
var loading_desert = false

func _process(delta):
	if loading_desert && (ResourceLoader.load_threaded_get_status(DESERT_SCENE_PATH) == ResourceLoader.THREAD_LOAD_LOADED):
		var new_scene :PackedScene = ResourceLoader.load_threaded_get(DESERT_SCENE_PATH)
		get_tree().change_scene_to_packed(new_scene)
		
func _on_forest_button_pressed():
	get_tree().change_scene_to_file("res://forest_room.tscn")

func _on_desert_button_pressed():
	ResourceLoader.load_threaded_request(DESERT_SCENE_PATH)
	loading_desert = true
	$DesertButton.hide()
	$Label.hide()
	$Label2.hide()
	$LoadingLabel.show()
