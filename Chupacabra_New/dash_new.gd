extends State

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var chupacabra_charge: AudioStreamPlayer2D = $"../../Chupacabra_Charge"
var in_slash_range = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	sprite.play("dash")
	var target = owner.player.position
	if target.x > owner.position.x :
		target.x += 150
	else:
		target.x -= 150
	if target.y > owner.position.y:
		target.y += 150
	else:
		target.y -= 150
	owner.target = target
	owner.speed = 500
	#print(owner.target)
		
		
func exit():
	super.exit()
	owner.set_physics_process(false)
	owner.speed = 200
	await get_tree().create_timer(1).timeout

func transition():
	if owner.target - Vector2(5, 5) < owner.position && owner.position < owner.target + Vector2(5,5):
		get_parent().change_state("Follow")
	#elif owner.is_in_group("DesertSprite"):
			#print("Hit wall!")
	else:
		owner.target = owner.player.position#update the postion so it knows where you are
		#fixes it kinda freezing after a dash from hitting wall even though your now behind it
		
func _on_slash_area_body_entered(body):
	owner.player.hurt(0.5)
