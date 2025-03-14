extends AudioStreamPlayer2D

var sounds = {
			"bite" : preload("res://Assets/Sound/Goat Head WAVs/Goat Head Bite.wav"),
			"hover" : preload("res://Assets/Sound/Goat Head WAVs/Goat Head Hover.wav"),
			"spawn1" : preload("res://Assets/Sound/Goat Head WAVs/Goat Head Spawn.wav"),
			"spawn2" : preload("res://Assets/Sound/Goat Head WAVs/Goat Head Spawn 2.wav")
			}

func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
