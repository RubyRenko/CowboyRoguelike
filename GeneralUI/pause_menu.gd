extends Control

var example_inv = {"darkhat": 0, "cadejo": 0, "tractor": 1, "wampus": 1}
@onready var inventory_display = $InventoryDisplay
@onready var main = get_tree().get_root().get_node("Main")
@onready var button_sounds = [get_node("Button1Audio"), get_node("Button2Audio")]
var is_paused = false
var display_inv = true

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") && is_paused:
		unpause()
	elif Input.is_action_just_pressed("pause") && !is_paused:
		pause()

func pause():
	get_tree().paused = true
	show()
	var inv = main.get_node("CowboyPlayer").inventory
	inventory_display.update_inv(inv)
	is_paused = true

func unpause():
	get_tree().paused = false
	hide()
	is_paused = false

func toggle_controls():
	$ControlsText.visible = true
	$ControlsTitle.visible = true
	$Inventory2.visible = true
	$Inventory.visible = false
	$InventoryDisplay.visible = false
	display_inv = false

func toggle_inventory():
	$ControlsText.visible = false
	$ControlsTitle.visible = false
	$Inventory2.visible = false
	$Inventory.visible = true
	$InventoryDisplay.visible = true
	display_inv = true
	
func _on_continue_button_pressed():
	button_sounds.pick_random().play()
	unpause()

func _on_controls_button_pressed():
	if display_inv:
		button_sounds.pick_random().play()
		toggle_controls()
	else:
		button_sounds.pick_random().play()
		toggle_inventory()

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://main_menu2.tscn")
