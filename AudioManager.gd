extends Node2D

var sounds = {"fire" : preload("res://Assets/Sound/Player Gun Fire(even shorter).wav"),
			"empty" : preload("res://Assets/Sound/Player Gun Click.wav"),
			"reload" : preload("res://Assets/Sound/Player Reload.wav")}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play(sound):
	if sound in sounds:
		pass
