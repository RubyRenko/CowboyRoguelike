extends State
var in_slash_range = false

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var chupacabra_run_1: AudioStreamPlayer2D = $"../../Chupacabra_Run_1"
@onready var chupacabra_run_2: AudioStreamPlayer2D = $"../../Chupacabra_Run_2"


func enter():
	super.enter()
	owner.set_physics_process(true)
	sprite.play("follow")
	chupacabra_run_1.play()
	chupacabra_run_2.play()
	in_slash_range = false
 
func exit():
	super.exit()
	owner.set_physics_process(false)
 
func transition():
	var distance = owner.direction.length()
	if in_slash_range:
		chupacabra_run_1.stop()
		chupacabra_run_2.stop()
		get_parent().change_state("Slash")
	elif distance > 300 and randi_range(0, 30) == 0:
		chupacabra_run_1.stop()
		chupacabra_run_2.stop()
		get_parent().change_state("Roar")

func _on_slash_area_body_entered(body):
	in_slash_range = true
