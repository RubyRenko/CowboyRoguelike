extends Camera2D

var decay = 0.5  # How quickly the shaking stops [0, 1].
var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
var max_roll = 0.05  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount):
	trauma = min(amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-0.5, 5)
	offset.x = max_offset.x * amount * randf_range(-0.5, 5)
	offset.y = max_offset.y * amount * randf_range(-0.5, 5)
