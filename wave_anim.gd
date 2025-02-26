extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_wave(wave):
	visible = true
	frame = wave-1
	$AnimationPlayer.play("wave_fade2")
	await get_tree().create_timer(3).timeout
	visible = false
