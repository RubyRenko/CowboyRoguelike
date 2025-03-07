extends ProgressBar

@onready var wave_timer: Timer = $"../WaveTimer"
var wave_time_left = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
		value = wave_timer.time_left
		#print(wave_timer.time_left)
