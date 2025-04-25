extends Area2D

var hurt = false
var next_hurt = 0
@onready var main = get_tree().get_root().get_node("Main")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hurt:
		next_hurt -= delta
		if next_hurt <= 0:
			main.get_node("CowboyPlayer").hurt(1)
			next_hurt = 1.5

func _on_body_entered(body):
	if body.name == "CowboyPlayer":
		hurt = true

func _on_body_exited(body):
	if body.name == "CowboyPlayer":
		hurt = false

func _on_timer_timeout():
	queue_free()
