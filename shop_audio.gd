extends AudioStreamPlayer2D

var sounds = {
			"buy" : preload("res://Assets/Sound/General Sound WAVs/Item Bought.wav"),
			"no_funds" : preload("res://Assets/Sound/General Sound WAVs/Insufficient Funds.wav")
			}

func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
