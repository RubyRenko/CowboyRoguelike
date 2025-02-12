extends Node2D

@onready var cowboy = load("res://cowboy_player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
"""
	var player = cowboy.instantiate()
	player.ranged_dmg = 5
	player.melee_dmg = 5
	player.speed = 300.0
	player.ammo = 6
	player.hp = 8
	player.money = 0
"""


func _on_forest_button_pressed():
	var player = cowboy.instantiate()
	player.ranged_dmg = 5
	player.melee_dmg = 5
	player.speed = 300.0
	player.ammo = 6
	player.hp = 8
	player.money = 0
	get_tree().change_scene_to_file("res://forest_room.tscn")


func _on_desert_button_pressed():
	var player = cowboy.instantiate()
	player.ranged_dmg = 5
	player.melee_dmg = 5
	player.speed = 300.0
	player.ammo = 6
	player.hp = 8
	player.money = 0
	get_tree().change_scene_to_file("res://desert_room.tscn")
