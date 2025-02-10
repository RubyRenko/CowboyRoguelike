extends HBoxContainer

enum MODES {simple, partial}

var heart_full = preload("res://Assets/hud assets/cow boy heart-02.png")
var heart_half = preload("res://Assets/hud assets/half heart with black.png")
var heart_empty = preload("res://Assets/hud assets/empty heart.png")
#var armor_full = preload("")
#var armor_half = preload("")

func update_health(value, max):
	update_partial(value, max)

func update_partial(value, max):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).visible = true
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).visible = true
			get_child(i).texture = heart_half
		elif max > i * 2:
			get_child(i).visible = true
			get_child(i).texture = heart_empty
		else:
			get_child(i).visible = false
