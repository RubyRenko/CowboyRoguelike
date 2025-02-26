extends StaticBody2D
var can_talk = false
var dia_ind = 0
var dia_array = ["Hi there.", "", "Are you all done shopping?", "I'll be leaving now."]
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_talk and Input.is_action_just_pressed("interact"):
		$Dialogue.visible = true
		$Dialogue.set_character("Yeti")
		if dia_ind < dia_array.size() && dia_array[dia_ind] != "":
			$Dialogue.set_text(dia_array[dia_ind])
			dia_ind += 1
		elif dia_ind == dia_array.size():
			$Dialogue.visible = false
			print(owner)
			owner.queue_free()
		else:
			#if the dialogue is "" or it goes past the array
			$Dialogue.visible = false
			dia_ind += 1

func _on_interact_area_body_entered(body):
	if body.name == "CowboyPlayer":
		can_talk = true

func _on_interact_area_body_exited(body):
	if body.name == "CowboyPlayer":
		can_talk = false
		$Dialogue.visible = false
