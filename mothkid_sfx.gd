extends AudioStreamPlayer2D

var sounds = {
			"attack" : preload("res://Assets/Sound/Mothkid Grunt WAVs/Mothkid Grunt Melee.wav"),
			"hover" : preload("res://Assets/Sound/Mothkid Grunt WAVs/Mothkid Grunt Hover.wav"),
			"spawn1" : preload("res://Assets/Sound/Mothkid Grunt WAVs/Mothkid Grunt Summon 1.wav"),
			"spawn2" : preload("res://Assets/Sound/Mothkid Grunt WAVs/Mothkid Grunt Summon 2.wav")
			}

func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
