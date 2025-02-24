extends State
var in_slash_range = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	in_slash_range = false
 
func exit():
	super.exit()
	owner.set_physics_process(false)
 
func transition():
	var distance = owner.direction.length()
	if in_slash_range:
		get_parent().change_state("Slash")
	elif distance > 300 and randi_range(0, 30) == 0:
		get_parent().change_state("Dash")

func _on_slash_area_body_entered(body):
	in_slash_range = true
