extends State

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var chupacabra_roar: AudioStreamPlayer2D = $"../../Chupacabra_Roar"


func enter():
	super.enter()
	chupacabra_roar.play()
	sprite.play("roar")
	
 
func transition():
	await get_tree().create_timer(2).timeout
	get_parent().change_state("Dash")
