extends Node2D
class_name State
 
@onready var debug: Label = $"../../Debug"
@onready var player: CowboyPlayer = $"../CowboyPlayer"
 
func _ready():
	set_physics_process(false)
 
func enter():
	set_physics_process(true)
 
func exit():
	set_physics_process(false)
 
func transition():
	pass
 
func _physics_process(_delta):
	transition()
	debug.text = name
