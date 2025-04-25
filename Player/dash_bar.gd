extends ProgressBar

@onready var dash_available: Timer = $"../Dash_Available"
var dash_time_left = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
		if dash_available.time_left <= 0:
			set_visible(false)
			prog_reset()
		else:
			set_visible(true)
			prog_down()
		
		#print(dash_available.time_left)
			
func prog_down():
	$".".value-=2

func prog_reset():
	$".".value = $".".max_value
