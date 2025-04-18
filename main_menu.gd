extends Node2D
const DESERT_SCENE_PATH : String = "res://desert_room.tscn"
var loading_desert = false
@onready var cowboy = load("res://cowboy_player.tscn")

func _process(delta):
	if loading_desert && (ResourceLoader.load_threaded_get_status(DESERT_SCENE_PATH) == ResourceLoader.THREAD_LOAD_LOADED):
		var new_scene :PackedScene = ResourceLoader.load_threaded_get(DESERT_SCENE_PATH)
		get_tree().change_scene_to_packed(new_scene)
		
func _on_forest_button_pressed():
	
	get_tree().change_scene_to_file("res://forest_room.tscn")

func _on_desert_button_pressed():
	ResourceLoader.load_threaded_request(DESERT_SCENE_PATH)
	loading_desert = true
	var player = cowboy.instantiate()
	player.ranged_dmg = 5
	player.melee_dmg = 5
	player.speed = 300.0
	player.max_ammo = 6
	player.max_hp = 8
	player.hp = player.max_hp
	player.money = 0
	player.queue_free()
	$DesertButton.hide()
	$Label.hide()
	$Label2.hide()
	$LoadingLabel.show()


func _on_texture_button_pressed() -> void:
	ResourceLoader.load_threaded_request(DESERT_SCENE_PATH)
	loading_desert = true
	var player = cowboy.instantiate()
	player.ranged_dmg = 5
	player.melee_dmg = 5
	player.speed = 300.0
	player.max_ammo = 6
	player.max_hp = 8
	player.hp = player.max_hp
	player.money = 0
	player.queue_free()
