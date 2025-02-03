extends HBoxContainer

enum MODES {simple, partial}

var heart_full = preload("res://Assets/hud assets/cow boy heart-02.png")
var heart_half = preload("res://Assets/hud assets/cow boy half heart.png")
#var heart_empty = preload("")
#var armor_full = preload("")
#var armor_half = preload("")

func update_health(value):
	update_partial(value)

func update_partial(value):
	for i in get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).visible = value > i * 2
