extends AudioStreamPlayer2D

var sounds = {
			"stunhit" : preload("res://Assets/Sound/General Sound WAVs/Stun Debuff.wav"),
			"slowhit" : preload("res://Assets/Sound/General Sound WAVs/Slow Debuff.wav"),
			}
			
func play_sfx(sound):
	if sound in sounds:
		stream = sounds[sound]
		play()
