extends AudioStreamPlayer2D

var sounds = {"fire" : preload("res://Assets/Sound/Player Gun Fire(even shorter).wav"),
			"empty" : preload("res://Assets/Sound/Player Gun Click.wav"),
			"reload" : preload("res://Assets/Sound/Player Reload.wav"),
			"dash" : preload("res://Assets/Sound/General Sound WAVs/Player Dash.wav"),
			"step1" : preload("res://Assets/Sound/General Sound WAVs/Player Footstep 1.wav"),
			"step2" : preload("res://Assets/Sound/General Sound WAVs/Player Footstep 2.wav"),
			"melee" : preload("res://Assets/Sound/General Sound WAVs/Player Whip Attack.wav"),
			"hurt1" : preload("res://Assets/Sound/General Sound WAVs/Player Hurt 1.wav"),
			"hurt2" : preload("res://Assets/Sound/General Sound WAVs/Player Hurt 2.wav"),
			"hurt3" : preload("res://Assets/Sound/General Sound WAVs/Player Hurt 3.wav"),
			"coin" : preload("res://Assets/Sound/General Sound WAVs/Coin Collect.wav"),
			"die1" : preload("res://Assets/Sound/General Sound WAVs/Player Die 1.wav"),
			"die2" : preload("res://Assets/Sound/General Sound WAVs/Player Die 2.wav"),
			"die3" : preload("res://Assets/Sound/General Sound WAVs/Player Die 3.wav")
			}

func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
