extends AudioStreamPlayer2D

var sounds = {
			"goat1" : preload("res://Assets/Sound/Goat Head WAVs/Goat Head Death.wav"),
			"goat2" : preload("res://Assets/Sound/Goat Head WAVs/Goat Head Death 2.wav"),
			"moth1" : preload("res://Assets/Sound/Mothkid Grunt WAVs/Mothkid Grunt Death 1.wav"),
			"moth2" : preload("res://Assets/Sound/Mothkid Grunt WAVs/Mothkid Grunt Death 2.wav"),
			"larva1" : preload("res://Assets/Sound/Larga Larva WAVs/Large Larva Die 1.wav"),
			"larva2" : preload("res://Assets/Sound/Larga Larva WAVs/Large Larva Die 2.wav")
			}

func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
