extends AudioStreamPlayer2D


var sounds = {
			"attack" : preload("res://Assets/Sound/Larga Larva WAVs/Large Larva Bite.wav"),
			"spawn1" : preload("res://Assets/Sound/Larga Larva WAVs/Large Larva Summon.wav"),
			"spawn2" : preload("res://Assets/Sound/Larga Larva WAVs/Large Larva Summon 2.wav"),
			"slither" : preload("res://Assets/Sound/Larga Larva WAVs/Large Larva Slither.wav")
			}

func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
