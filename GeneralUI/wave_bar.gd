extends TextureProgressBar

@export var wave_number_sprite : Sprite2D
@onready var wave_timer: Timer = $"../WaveTimer"
var wave_time_left = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func change_wave(wave : int) -> void:
	(wave_number_sprite.texture as AtlasTexture).region.position.x = ((wave-1) % 5) * 270
	(wave_number_sprite.texture as AtlasTexture).region.position.y = floor((wave-1) / 5) * 270

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
		value = wave_timer.time_left
		#print(wave_timer.time_left)
