extends Node2D

@onready var arrow = $Arrow
@export var rotation_speed : float = 1.0
@export var orbit_radius : float = 50.0
@onready var target = get_node("/root/Path/To/Wagon/Wagon")  # Adjust the path to your target node

var angle : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.show_arrow:
		# Orbit the arrow around the player
		angle += rotation_speed * delta
		position = Vector2(cos(angle), sin(angle)) * orbit_radius

		# Point the arrow towards the target
		var direction = (target.position - global_position).normalized()
		var target_angle = direction.angle()
		rotation = target_angle
		visible = true
	else:
		visible = false
pass
