extends AudioStreamPlayer2D

var sounds = {
			"hit" : preload("res://Assets/Sound/General Sound WAVs/Player Hitmarker.wav"),
			"miss" : preload("res://Assets/Sound/General Sound WAVs/Bullet Ricochet.wav"),
			"miss2" : preload("res://Assets/Sound/General Sound WAVs/Bullet Ricochet 2.wav")
			}

func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
