extends Control

var example_inv = {"darkhat": 0, "cadejo": 0, "tractor": 1, "wampus": 1}
@onready var inventory_display = $InventoryDisplay
@onready var main = get_tree().get_root().get_node("Main")
var is_paused = false
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

func _on_continue_button_pressed():
	unpause()
