extends AnimatedSprite2D

var sound = "moth1"

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	$DeathAudioPlayer.play_sfx(sound)

func _on_death_audio_player_finished():
	queue_free()
