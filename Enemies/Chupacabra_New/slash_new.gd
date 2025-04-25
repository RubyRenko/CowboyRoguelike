extends State

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var chupacabra_slash: AudioStreamPlayer2D = $"../../Chupacabra_Slash"

func enter():
	super.enter()
	chupacabra_slash.play()
	sprite.play("slash")
	owner.player.hurt(1)
 
func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
