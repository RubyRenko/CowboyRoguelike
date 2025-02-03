extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$text.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if (body.name == "CowboyPlayer"):
		$text.visible = true

func _on_area_2d_body_exited(body):
	if (body.name == "CowboyPlayer"):
		$text.visible = false
