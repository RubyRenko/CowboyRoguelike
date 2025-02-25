extends Label

func display_wave(wave):
	visible = true
	if wave == 15:
		text = "Wave 15: Boss Incoming"
	if wave % 5 == 0:
		text = "Wave " + str(wave) + ": Shop"
	else:
		text = "Wave " + str(wave)
	$AnimationPlayer.play("wave_fade")
	await get_tree().create_timer(3).timeout
	visible = false
