extends AudioStreamPlayer2D



var sounds = [ preload("res://Assets/Sound/General Sound WAVs/Player Die 1.wav"),
			preload("res://Assets/Sound/General Sound WAVs/Player Die 2.wav"), 
			preload("res://Assets/Sound/General Sound WAVs/Player Die 3.wav")
			]

func play_sfx():
	stream = sounds.pick_random()
	play()
